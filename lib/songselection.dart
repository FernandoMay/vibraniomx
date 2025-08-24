// ```

// ## lib/screens/song_selection_screen.dart
// 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibraniomx/breathing.dart';
import 'package:vibraniomx/musicnft.dart';
import 'package:vibraniomx/theme.dart';
import 'package:vibraniomx/yinyang.dart';
import 'package:web3dart/web3dart.dart';
class SongSelectionScreen extends ConsumerStatefulWidget {
  const SongSelectionScreen({super.key});

  @override
  ConsumerState<SongSelectionScreen> createState() => _SongSelectionScreenState();
}

class _SongSelectionScreenState extends ConsumerState<SongSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  String selectedSide = '';
  
  // Dummy data for MusicNFTs
  final List<MusicNFT> allSongs = [
    MusicNFT(
      tokenId: BigInt.from(1),
      uri: 'ipfs://0198dbf6-1689-714d-9ad7-d0981d0ae953',
      title: 'Calm Waters',
      artistName: 'Ambient Flow',
      coverImage: 'https://example.com/calm_waters.jpg',
      moodCategories: [0, 7, 8], // Calm, Meditative, Peaceful
      artist: EthereumAddress.fromHex('0x0000000000000000000000000000000000000001'),
      price: BigInt.zero,
      streamCount: BigInt.from(12345),
    ),
    MusicNFT(
      tokenId: BigInt.from(2),
      uri: 'ipfs://0198dbf5-f58c-7605-af72-b22971f977cd',
      title: 'Forest Whispers',
      artistName: 'Nature Sounds',
      coverImage: 'https://example.com/forest_whispers.jpg',
      moodCategories: [0, 7], // Calm, Meditative
      artist: EthereumAddress.fromHex('0x0000000000000000000000000000000000000002'),
      price: BigInt.zero,
      streamCount: BigInt.from(9876),
    ),
    MusicNFT(
      tokenId: BigInt.from(3),
      uri: 'ipfs://0198dbf5-d362-7e47-b306-3e3c49c953b3',
      title: 'Deep Sleep',
      artistName: 'Dream Weaver',
      coverImage: 'https://example.com/deep_sleep.jpg',
      moodCategories: [0, 3], // Calm, Sad
      artist: EthereumAddress.fromHex('0x0000000000000000000000000000000000000003'),
      price: BigInt.zero,
      streamCount: BigInt.from(5432),
    ),
    MusicNFT(
      tokenId: BigInt.from(4),
      uri: 'ipfs://0198dbf5-aed1-78c8-ba59-53473550be3e',
      title: 'Morning Energy',
      artistName: 'Uplift Beats',
      coverImage: 'https://example.com/morning_energy.jpg',
      moodCategories: [1, 6, 10], // Energetic, Uplifting, Motivational
      artist: EthereumAddress.fromHex('0x0000000000000000000000000000000000000004'),
      price: BigInt.zero,
      streamCount: BigInt.from(23456),
    ),
    MusicNFT(
      tokenId: BigInt.from(5),
      uri: 'ipfs://0198dbf5-8b7f-7aa0-92b9-7ffb6d1efb01',
      title: 'Focus Zone',
      artistName: 'Productivity Sounds',
      coverImage: 'https://example.com/focus_zone.jpg',
      moodCategories: [4], // Focused
      artist: EthereumAddress.fromHex('0x0000000000000000000000000000000000000005'),
      price: BigInt.zero,
      streamCount: BigInt.from(18765),
    ),
    MusicNFT(
      tokenId: BigInt.from(6),
      uri: 'ipfs://0198dbf4-f7ad-7e02-a640-fb11173ad418',
      title: 'Happy Vibes',
      artistName: 'Joyful Tunes',
      coverImage: 'https://example.com/happy_vibes.jpg',
      moodCategories: [2, 6], // Happy, Uplifting
      artist: EthereumAddress.fromHex('0x0000000000000000000000000000000000000006'),
      price: BigInt.zero,
      streamCount: BigInt.from(21034),
    ),
    MusicNFT(
      tokenId: BigInt.from(7),
      uri: 'ipfs://0198dbf3-a9e4-75fa-95b7-15b4b209ce7f',
      title: 'Romantic Evening',
      artistName: 'Love Songs',
      coverImage: 'https://example.com/romantic_evening.jpg',
      moodCategories: [5, 2], // Romantic, Happy
      artist: EthereumAddress.fromHex('0x0000000000000000000000000000000000000007'),
      price: BigInt.zero,
      streamCount: BigInt.from(15432),
    ),
    MusicNFT(
      tokenId: BigInt.from(8),
      uri: 'ipfs://0198dbf3-8025-7d5f-a1ea-cd9d5c72e16f',
      title: 'Energetic Pulse',
      artistName: 'Dynamic Beats',
      coverImage: 'https://example.com/energetic_pulse.jpg',
      moodCategories: [1, 4], // Energetic, Focused
      artist: EthereumAddress.fromHex('0x0000000000000000000000000000000000000008'),
      price: BigInt.zero,
      streamCount: BigInt.from(19876),
    ),

  ];

  List<MusicNFT> filteredSongs = [];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    filteredSongs = allSongs; // Initially show all songs
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _filterSongs(String side) {
    setState(() {
      selectedSide = side;
      if (side == 'yin') {
        // Filter for calm/meditative moods (Yin)
        filteredSongs = allSongs.where((song) {
          return song.moodCategories.any((mood) => [0, 3, 7, 8].contains(mood)); // Calm, Sad, Meditative, Peaceful
        }).toList();
      } else if (side == 'yang') {
        // Filter for energetic/uplifting moods (Yang)
        filteredSongs = allSongs.where((song) {
          return song.moodCategories.any((mood) => [1, 4, 6, 10].contains(mood)); // Energetic, Focused, Uplifting, Motivational
        }).toList();
      } else {
        filteredSongs = allSongs; // Show all if no side selected
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildYinYangSelector(),
              const SizedBox(height: 20),
              Expanded(child: _buildSongList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          ),
          const Expanded(
            child: Text(
              'Select a Song',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // For alignment
        ],
      ),
    );
  }

  Widget _buildYinYangSelector() {
    return GestureDetector(
      onTapUp: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        final center = Offset(box.size.width / 2, box.size.height / 2);
        final isYin = localPosition.dx < center.dx;
        _filterSongs(isYin ? 'yin' : 'yang');
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: selectedSide == 'yin'
                  ? AppTheme.yinAccent.withOpacity(0.5)
                  : selectedSide == 'yang'
                      ? AppTheme.yangAccent.withOpacity(0.5)
                      : AppTheme.primary.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: YinYangButton()
        // YinYangWidget(
        //   size: 150,
        //   interactive: true,
        //   onTap: (isYin) => _filterSongs(isYin ? 'yin' : 'yang'),
        // ),
      ),
    );
  }

  Widget _buildSongList() {
    if (filteredSongs.isEmpty) {
      return const Center(
        child: Text(
          'No songs found for this mood.',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      itemCount: filteredSongs.length,
      itemBuilder: (context, index) {
        final song = filteredSongs[index];
        return _buildSongListItem(song);
      },
    );
  }

  Widget _buildSongListItem(MusicNFT song) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: AppTheme.surface.withOpacity(0.8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BreathingScreen(selectedSong: song),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: song.primaryMoodColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  image: song.coverImage.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(song.coverImage),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: song.coverImage.isEmpty
                    ? Icon(Icons.music_note, color: song.primaryMoodColor)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.artistName,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.play_arrow,
                            color: AppTheme.textSecondary.withOpacity(0.7),
                            size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${song.streamCount}',
                          style: TextStyle(
                            color: AppTheme.textSecondary.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.category,
                            color: song.primaryMoodColor.withOpacity(0.7),
                            size: 16),
                        const SizedBox(width: 4),
                        Text(
                          song.primaryMoodName,
                          style: TextStyle(
                            color: song.primaryMoodColor.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: AppTheme.textSecondary.withOpacity(0.5), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

extension on MusicNFT {
  Color get primaryMoodColor {
    if (moodCategories.isEmpty) return AppTheme.textSecondary;
    final primaryMood = moodCategories.first;
    switch (primaryMood) {
      case 0:
        return AppTheme.yinAccent; // Calm
      case 1:
        return AppTheme.yangAccent; // Energetic
      case 2:
        return Colors.purple; // Happy
      case 3:
        return Colors.blueGrey; // Sad
      case 4:
        return Colors.orange; // Focused
      case 5:
        return Colors.red; // Angry
      case 6:
        return Colors.lightGreen; // Uplifting
      case 7:
        return Colors.indigo; // Meditative
      case 8:
        return Colors.teal; // Peaceful
      case 9:
        return Colors.pinkAccent; // Romantic
      case 10:
        return Colors.amber; // Motivational
      default:
        return AppTheme.textSecondary;
    }
  }

  String get primaryMoodName {
    if (moodCategories.isEmpty) return 'Unknown';
    final primaryMood = moodCategories.first;
    switch (primaryMood) {
      case 0:
        return 'Calm';
      case 1:
        return 'Energetic';
      case 2:
        return 'Happy';
      case 3:
        return 'Sad';
      case 4:
        return 'Focused';
      case 5:
        return 'Angry';
      case 6:
        return 'Uplifting';
      case 7:
        return 'Meditative';
      case 8:
        return 'Peaceful';
      case 9:
        return 'Romantic';
      case 10:
        return 'Motivational';
      default:
        return 'Unknown';
    }
  }
}

