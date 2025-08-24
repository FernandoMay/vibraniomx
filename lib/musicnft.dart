// ```

// ## lib/core/models/music_nft.dart
// ```dart
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class MusicNFT {
  final BigInt tokenId;
  final String uri;
  final String title;
  final String artistName;
  final String coverImage;
  final List<int> moodCategories;
  final EthereumAddress artist;
  final BigInt price;
  final BigInt streamCount;

  MusicNFT({
    required this.tokenId,
    required this.uri,
    required this.title,
    required this.artistName,
    required this.coverImage,
    required this.moodCategories,
    required this.artist,
    required this.price,
    required this.streamCount,
  });

  factory MusicNFT.fromContractResult(BigInt tokenId, List<dynamic> result) {
    return MusicNFT(
      tokenId: tokenId,
      uri: result[0] as String,
      title: result[1] as String,
      artistName: result[2] as String,
      coverImage: result[3] as String,
      moodCategories: (result[4] as List).cast<int>(),
      artist: result[5] as EthereumAddress,
      price: result[6] as BigInt,
      streamCount: result[7] as BigInt,
    );
  }

  bool get isForSale => price > BigInt.zero;
  
  String get priceInTours => (price / BigInt.from(10).pow(18)).toString();
  
  Color get primaryMoodColor {
    if (moodCategories.isEmpty) return Colors.grey;
    
    // Map mood categories to colors
    final moodColors = {
      0: Colors.blue,      // Calm
      1: Colors.red,       // Energetic
      2: Colors.green,     // Happy
      3: Colors.purple,    // Sad
      4: Colors.orange,    // Focused
      5: Colors.pink,      // Romantic
      6: Colors.yellow,    // Uplifting
      7: Colors.indigo,    // Meditative
      8: Colors.teal,      // Peaceful
      9: Colors.cyan,      // Creative
      10: Colors.amber,    // Motivational
    };
    
    return moodColors[moodCategories.first] ?? Colors.grey;
  }
}