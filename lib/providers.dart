// ```

// ## lib/core/providers/app_providers.dart
// ```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibraniomx/chainservice.dart';
import 'package:vibraniomx/profile.dart';
import 'package:web3dart/web3dart.dart';
// import '../services/blockchain_service.dart';
// import '../models/user_profile.dart';
// import '../models/music_nft.dart';

final blockchainServiceProvider = Provider<BlockchainService>((ref) {
  return BlockchainService();
});

final userProfileProvider = FutureProvider.family<UserProfile?, EthereumAddress>((ref, address) async {
  final blockchainService = ref.read(blockchainServiceProvider);
  return await blockchainService.getUserProfile(address);
});

final musicRecommendationsProvider = FutureProvider.family<List<BigInt>, EthereumAddress>((ref, address) async {
  final blockchainService = ref.read(blockchainServiceProvider);
  return await blockchainService.getRecommendations(address);
});

final toursBalanceProvider = FutureProvider.family<BigInt, EthereumAddress>((ref, address) async {
  final blockchainService = ref.read(blockchainServiceProvider);
  return await blockchainService.getToursBalance(address);
});

// App State Provider
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

class AppState {
  final bool isConnected;
  final EthereumAddress? userAddress;
  final UserProfile? userProfile;
  final bool isLoading;
  final String? error;

  AppState({
    this.isConnected = false,
    this.userAddress,
    this.userProfile,
    this.isLoading = false,
    this.error,
  });

  AppState copyWith({
    bool? isConnected,
    EthereumAddress? userAddress,
    UserProfile? userProfile,
    bool? isLoading,
    String? error,
  }) {
    return AppState(
      isConnected: isConnected ?? this.isConnected,
      userAddress: userAddress ?? this.userAddress,
      userProfile: userProfile ?? this.userProfile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setConnected(bool connected, EthereumAddress? address) {
    state = state.copyWith(isConnected: connected, userAddress: address);
  }

  void setUserProfile(UserProfile? profile) {
    state = state.copyWith(userProfile: profile);
  }
}