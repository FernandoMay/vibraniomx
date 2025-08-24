// ```

// ## lib/core/services/blockchain_service.dart
// ```dart
import 'package:vibraniomx/main.dart';
import 'package:vibraniomx/profile.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:para/para.dart';
// import '../models/user_profile.dart';
// import '../models/music_nft.dart';

class BlockchainService {
  static final BlockchainService _instance = BlockchainService._internal();
  factory BlockchainService() => _instance;
  BlockchainService._internal();

  late Web3Client _client;
  late EthereumAddress _contractAddress;
  late EthereumAddress _toursTokenAddress;
  late DeployedContract _contract;
  late DeployedContract _toursContract;

  EthereumAddress? _userAddress;
  Credentials? _credentials;

  bool get isConnected => _userAddress != null;
  EthereumAddress? get userAddress => _userAddress;

  Future<void> initialize() async {
    final rpcUrl = dotenv.env['https://rpc.monad.testnet']!;
    final contractAddr = dotenv.env['0x2e6a0E553c62a52446e00b1FCab214b489B77051']!;
    final toursAddr = dotenv.env['0xFF38c9A0e766Ef4b85A00DD1400e942B49647113']!;

    _client = Web3Client(rpcUrl, Client());
    _contractAddress = EthereumAddress.fromHex(contractAddr);
    _toursTokenAddress = EthereumAddress.fromHex(toursAddr);

    // Load contract ABI
    _contract = DeployedContract(
      ContractAbi.fromJson(_getVibraniOmABI(), 'SimpleVibraniom'),
      _contractAddress,
    );

    _toursContract = DeployedContract(
      ContractAbi.fromJson(_getERC20ABI(), 'ERC20'),
      _toursTokenAddress,
    );
  }

  Future<void> login(
  String email,
  String externalAddress,
  String walletType,
) async {
  try {
    // Login with external wallet address
    await para.login(
      email: email,
      // externalAddress: externalAddress,
      // type: walletType, // "EVM" or "SOLANA"
    );
    
    // Check if authentication was successful
    final isActive = await para.isSessionActive();
    if (isActive) {
      final wallets = await para.fetchWallets();
      print('Authenticated with ${wallets.length} wallets');
    }
  } catch (e) {
    print('External wallet authentication failed: $e');
  }
}

  Future<bool> connectWallet() async {
    try {
      // Use Para SDK for wallet connection
      
      final walletResult = await para.createWallet(skipDistribute: true);
      if (walletResult.wallet.address != null) {
        _userAddress = EthereumAddress.fromHex(walletResult.wallet.address!);
        _credentials = EthPrivateKey.fromHex(walletResult.wallet.publicKey!);
        return true;
      }
      return false;
    } catch (e) {
      print('Wallet connection error: $e');
      return false;
    }
  }

  Future<void> disconnect() async {
    _userAddress = null;
    _credentials = null;
    await para.logout(); //.disconnectWallet();
  }

  Future<UserProfile?> getUserProfile(EthereumAddress address) async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _contract.function('profiles'),
        params: [address],
      );

      if (result.isNotEmpty) {
        return UserProfile.fromContractResult(result);
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  Future<bool> registerAsListener() async {
    if (!isConnected || _credentials == null) return false;

    try {
      final transaction = Transaction.callContract(
        contract: _contract,
        function: _contract.function('registerAsListener'),
        parameters: [],
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1), // 1 MON
      );

      final result = await _client.sendTransaction(
        _credentials!,
        transaction,
        chainId: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> registerAsArtist() async {
    if (!isConnected || _credentials == null) return false;

    try {
      final transaction = Transaction.callContract(
        contract: _contract,
        function: _contract.function('registerAsArtist'),
        parameters: [],
      );

      final result = await _client.sendTransaction(
        _credentials!,
        transaction,
        chainId: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> uploadMusic({
    required String uri,
    required String title,
    required String artistName,
    required String coverImage,
    required List<int> moodCategories,
    required BigInt price,
  }) async {
    if (!isConnected || _credentials == null) return false;

    try {
      final transaction = Transaction.callContract(
        contract: _contract,
        function: _contract.function('uploadMusic'),
        parameters: [uri, title, artistName, coverImage, moodCategories, price],
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1), // 1 MON upload fee
      );

      final result = await _client.sendTransaction(
        _credentials!,
        transaction,
        chainId: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Upload error: $e');
      return false;
    }
  }

  Future<bool> updateMoods(List<int> moods) async {
    if (!isConnected || _credentials == null) return false;

    try {
      final transaction = Transaction.callContract(
        contract: _contract,
        function: _contract.function('updateMoods'),
        parameters: [moods],
      );

      final result = await _client.sendTransaction(
        _credentials!,
        transaction,
        chainId: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Update moods error: $e');
      return false;
    }
  }

  Future<List<BigInt>> getRecommendations(EthereumAddress userAddress) async {
    try {
      final result = await _client.call(
        contract: _contract,
        function: _contract.function('recommendMusic'),
        params: [userAddress],
      );

      if (result.isNotEmpty && result[0] is List) {
        return (result[0] as List).cast<BigInt>();
      }
      return [];
    } catch (e) {
      print('Get recommendations error: $e');
      return [];
    }
  }

  Future<bool> streamMusic(BigInt tokenId) async {
    if (!isConnected || _credentials == null) return false;

    try {
      final transaction = Transaction.callContract(
        contract: _contract,
        function: _contract.function('streamMusic'),
        parameters: [tokenId],
      );

      final result = await _client.sendTransaction(
        _credentials!,
        transaction,
        chainId: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Stream music error: $e');
      return false;
    }
  }

  Future<bool> rateMusic(BigInt tokenId, int emoji) async {
    if (!isConnected || _credentials == null) return false;

    try {
      final transaction = Transaction.callContract(
        contract: _contract,
        function: _contract.function('rateMusic'),
        parameters: [tokenId, BigInt.from(emoji)],
      );

      final result = await _client.sendTransaction(
        _credentials!,
        transaction,
        chainId: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Rate music error: $e');
      return false;
    }
  }

  Future<bool> purchaseMusic(BigInt tokenId) async {
    if (!isConnected || _credentials == null) return false;

    try {
      final transaction = Transaction.callContract(
        contract: _contract,
        function: _contract.function('purchaseMusic'),
        parameters: [tokenId],
      );

      final result = await _client.sendTransaction(
        _credentials!,
        transaction,
        chainId: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Purchase music error: $e');
      return false;
    }
  }

  Future<bool> renewSubscription() async {
    if (!isConnected || _credentials == null) return false;

    try {
      final transaction = Transaction.callContract(
        contract: _contract,
        function: _contract.function('renewSubscription'),
        parameters: [],
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.parse('33000000000000000')), // 0.033 MON
      );

      final result = await _client.sendTransaction(
        _credentials!,
        transaction,
        chainId: 1,
      );

      return result.isNotEmpty;
    } catch (e) {
      print('Renew subscription error: $e');
      return false;
    }
  }

  Future<BigInt> getToursBalance(EthereumAddress address) async {
    try {
      final result = await _client.call(
        contract: _toursContract,
        function: _toursContract.function('balanceOf'),
        params: [address],
      );

      return result[0] as BigInt;
    } catch (e) {
      print('Get TOURS balance error: $e');
      return BigInt.zero;
    }
  }

  String _getVibraniOmABI() {
    // Simplified ABI - in production, load from file
    return '''[
      {
        "inputs": [{"internalType": "address", "name": "_toursToken", "type": "address"}],
        "stateMutability": "nonpayable",
        "type": "constructor"
      },
      {
        "inputs": [],
        "name": "registerAsListener",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "registerAsArtist",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "string", "name": "uri", "type": "string"},
          {"internalType": "string", "name": "title", "type": "string"},
          {"internalType": "string", "name": "artistName", "type": "string"},
          {"internalType": "string", "name": "coverImage", "type": "string"},
          {"internalType": "uint8[]", "name": "moodCategories", "type": "uint8[]"},
          {"internalType": "uint256", "name": "price", "type": "uint256"}
        ],
        "name": "uploadMusic",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function"
      },
      {
        "inputs": [{"internalType": "uint8[]", "name": "moods", "type": "uint8[]"}],
        "name": "updateMoods",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [{"internalType": "address", "name": "user", "type": "address"}],
        "name": "recommendMusic",
        "outputs": [{"internalType": "uint256[]", "name": "", "type": "uint256[]"}],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [{"internalType": "uint256", "name": "tokenId", "type": "uint256"}],
        "name": "streamMusic",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint256", "name": "tokenId", "type": "uint256"},
          {"internalType": "uint8", "name": "emoji", "type": "uint8"}
        ],
        "name": "rateMusic",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [{"internalType": "uint256", "name": "tokenId", "type": "uint256"}],
        "name": "purchaseMusic",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "renewSubscription",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function"
      },
      {
        "inputs": [{"internalType": "address", "name": "", "type": "address"}],
        "name": "profiles",
        "outputs": [
          {"internalType": "enum SimpleVibraniom.UserType", "name": "userType", "type": "uint8"},
          {"internalType": "uint8[]", "name": "recentMoods", "type": "uint8[]"},
          {"internalType": "uint256", "name": "subscriptionEnd", "type": "uint256"}
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
        "name": "musicNFTs",
        "outputs": [
          {"internalType": "string", "name": "uri", "type": "string"},
          {"internalType": "string", "name": "title", "type": "string"},
          {"internalType": "string", "name": "artistName", "type": "string"},
          {"internalType": "string", "name": "coverImage", "type": "string"},
          {"internalType": "uint8[]", "name": "moodCategories", "type": "uint8[]"},
          {"internalType": "address", "name": "artist", "type": "address"},
          {"internalType": "uint256", "name": "price", "type": "uint256"},
          {"internalType": "uint256", "name": "streamCount", "type": "uint256"}
        ],
        "stateMutability": "view",
        "type": "function"
      }
    ]''';
  }

  String _getERC20ABI() {
    return '''[
      {
        "inputs": [{"internalType": "address", "name": "account", "type": "address"}],
        "name": "balanceOf",
        "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
        "stateMutability": "view",
        "type": "function"
      }
    ]''';
  }
}