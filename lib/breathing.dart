
// // ## lib/screens/breathing_screen.dart
// // ```dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:vibraniomx/musicnft.dart';
// import 'package:vibraniomx/theme.dart';
// // import '../core/theme/app_theme.dart';
// // import '../core/models/music_nft.dart';
// // import '../widgets/breathing_visualizer.dart';
// // import '../widgets/loading_button.dart';

// class BreathingScreen extends ConsumerStatefulWidget {
//   final MusicNFT? selectedSong;
  
//   const BreathingScreen({super.key, this.selectedSong});

//   @override
//   ConsumerState<BreathingScreen> createState() => _BreathingScreenState();
// }

// class _BreathingScreenState extends ConsumerState<BreathingScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _breathingController;
//   late AnimationController _waveController;
//   late Animation<double> _breathingAnimation;
  
//   bool _isActive = false;
//   String _currentPhase = 'inhale';
//   String _breathingType = 'yang';
//   int _cycleCount = 0;
//   int _targetCycles = 10;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.selectedSong != null) {
//       _breathingType = _determineBreathingType(widget.selectedSong!);
//     }
//     _setupAnimations();
//   }

//   String _determineBreathingType(MusicNFT song) {
//     // Analyze mood categories to determine breathing type
//     final energeticMoods = [1, 4, 6, 10]; // Energetic, Focused, Uplifting, Motivational
//     final calmMoods = [0, 3, 7, 8]; // Calm, Sad, Meditative, Peaceful
    
//     int energeticCount = song.moodCategories.where((mood) => energeticMoods.contains(mood)).length;
//     int calmCount = song.moodCategories.where((mood) => calmMoods.contains(mood)).length;
    
//     return energeticCount > calmCount ? 'yang' : 'yin';
//   }

//   void _setupAnimations() {
//     _breathingController = AnimationController(
//       duration: const Duration(seconds: 8),
//       vsync: this,
//     );

//     _waveController = AnimationController(
//       duration: const Duration(seconds: 4),
//       vsync: this,
//     );

//     _breathingAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _breathingController,
//       curve: Curves.easeInOut,
//     ));

//     _breathingAnimation.addListener(() {
//       setState(() {
//         _currentPhase = _breathingAnimation.value < 0.5 ? 'inhale' : 'exhale';
//       });
//     });

//     _breathingController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         setState(() {
//           _cycleCount++;
//         });
//         if (_cycleCount >= _targetCycles) {
//           _stopBreathing();
//         } else {
//           _breathingController.reset();
//           _breathingController.forward();
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _breathingController.dispose();
//     _waveController.dispose();
//     super.dispose();
//   }

//   void _startBreathing() {
//     setState(() {
//       _isActive = true;
//       _cycleCount = 0;
//     });
//     _waveController.repeat();
//     _breathingController.forward();
//   }

//   void _stopBreathing() {
//     setState(() {
//       _isActive = false;
//       _currentPhase = 'inhale';
//     });
//     _waveController.stop();
//     _breathingController.reset();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: _breathingType == 'yang' 
//             ? AppTheme.yangGradient 
//             : AppTheme.yinGradient,
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 _buildHeader(),
//                 const SizedBox(height: 40),
//                 if (widget.selectedSong != null) _buildSongInfo(),
//                 const SizedBox(height: 40),
//                 Expanded(child: _buildBreathingVisual()),
//                 _buildControls(),
//                 const SizedBox(height: 20),
//                 _buildStats(),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             IconButton(
//               onPressed: () => Navigator.pop(context),
//               icon: const Icon(Icons.arrow_back, color: Colors.white),
//             ),
//             const Expanded(
//               child: Text(
//                 'Breathing Session',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(width: 48),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Text(
//           _breathingType == 'yang' ? 'Energizing Breath' : 'Calming Breath',
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.9),
//             fontSize: 16,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildSongInfo() {
//     final song = widget.selectedSong!;
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: song.primaryMoodColor.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(Icons.music_note, color: Colors.white),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   song.title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'by ${song.artistName}',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.8),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBreathingVisual() {
//     return Center(
//       child: BreathingVisualizer(
//         animation: _breathingAnimation,
//         breathingType: _breathingType,
//         currentPhase: _currentPhase,
//         isActive: _isActive,
//       ),
//     );
//   }

//   Widget _buildControls() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildControlButton(
//           icon: _isActive ? Icons.stop : Icons.play_arrow,
//           label: _isActive ? 'Stop' : 'Start',
//           onPressed: _isActive ? _stopBreathing : _startBreathing,
//         ),
//         _buildControlButton(
//           icon: Icons.refresh,
//           label: 'Reset',
//           onPressed: () {
//             _stopBreathing();
//             setState(() {
//               _cycleCount = 0;
//             });
//           },
//         ),
//         _buildControlButton(
//           icon: Icons.settings,
//           label: 'Settings',
//           onPressed: _showSettingsDialog,
//         ),
//       ],
//     );
//   }

//   Widget _buildControlButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: Colors.white, size: 24),
//             const SizedBox(height: 5),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStats() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildStatItem('Cycles', '$_cycleCount/$_targetCycles'),
//           _buildStatItem('Type', _breathingType.toUpperCase()),
//           _buildStatItem('Phase', _currentPhase.toUpperCase()),
//           _buildStatItem('Progress', '${((_cycleCount / _targetCycles) * 100).toInt()}%'),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.8),
//             fontSize: 10,
//           ),
//         ),
//       ],
//     );
//   }

//   void _showSettingsDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: AppTheme.surface,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Breathing Settings', style: TextStyle(color: AppTheme.textPrimary)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               title: const Text('Target Cycles', style: TextStyle(color: AppTheme.textPrimary)),
//               trailing: DropdownButton<int>(
//                 value: _targetCycles,
//                 items: [5, 10, 15, 20].map((cycles) => 
//                   DropdownMenuItem(
//                     value: cycles,
//                     child: Text('$cycles', style: const TextStyle(color: AppTheme.textPrimary)),
//                   ),
//                 ).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _targetCycles = value ?? 10;
//                   });
//                   Navigator.pop(context);
//                 },
//                 dropdownColor: AppTheme.surface,
//               ),
//             ),
//             ListTile(
//               title: const Text('Breathing Type', style: TextStyle(color: AppTheme.textPrimary)),
//               trailing: DropdownButton<String>(
//                 value: _breathingType,
//                 items: ['yin', 'yang'].map((type) => 
//                   DropdownMenuItem(
//                     value: type,
//                     child: Text(type.toUpperCase(), style: const TextStyle(color: AppTheme.textPrimary)),
//                   ),
//                 ).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _breathingType = value ?? 'yang';
//                   });
//                   Navigator.pop(context);
//                 },
//                 dropdownColor: AppTheme.surface,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close', style: TextStyle(color: AppTheme.primary)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BreathingVisualizer extends StatelessWidget {
//   final Animation<double> animation;
//   final String breathingType;
//   final String currentPhase;
//   final bool isActive;

//   const BreathingVisualizer({
//     super.key,
//     required this.animation,
//     required this.breathingType,
//     required this.currentPhase,
//     required this.isActive,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animation,
//       builder: (context, child) {
//         double scale = 1.0 + (animation.value * 0.5);
//         if (currentPhase == 'exhale') {
//           scale = 1.5 - (animation.value * 0.5);
//         }
//         return Transform.scale(
//           scale: scale,
//           child: Container(
//             width: 200,
//             height: 200,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: breathingType == 'yang'
//                 ? AppTheme.yangGradient
//                 : AppTheme.yinGradient,
//               boxShadow: isActive
//                 ? [
//                     BoxShadow(
//                       color: Colors.white.withOpacity(0.3),
//                       blurRadius: 20 * animation.value,
//                       spreadRadius: 5 * animation.value,
//                     ),
//                   ]
//                 : [],
//             ),
//             child: Center(
//               child: Icon(
//                 isActive 
//                   ? (currentPhase == 'inhale' ? Icons.arrow_upward : Icons.arrow_downward)
//                   : Icons.pause,
//                 color: Colors.white.withOpacity(0.8),
//                 size: 48,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


// ---

// # lib/features/breathing/presentation/screens/breathing_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:math' as math;

// ---

// # lib/features/breathing/presentation/widgets/breathing_wave.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';

// ---

// # lib/features/breathing/presentation/widgets/breathing_visual.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

// ---

// # lib/features/breathing/providers/breathing_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibraniomx/musicnft.dart';
import 'package:vibraniomx/theme.dart';


// Enhanced BreathingScreen with proper audio integration
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibraniomx/breathing.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:vibraniomx/musicnft.dart';
import 'package:vibraniomx/theme.dart';

// Audio Player Provider
class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  AudioPlayerNotifier() : super(const AudioPlayerState()) {
    _init();
  }

  void _init() {
    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      state = state.copyWith(position: position);
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      state = state.copyWith(duration: duration);
    });

    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((playerState) {
      state = state.copyWith(
        isPlaying: playerState == PlayerState.playing,
        isLoading: playerState == PlayerState.playing && state.duration == Duration.zero,
      );
    });
  }

  Future<void> playFromNFT(MusicNFT musicNFT) async {
    try {
      state = state.copyWith(
        isLoading: true,
        currentNFT: musicNFT,
        error: null,
      );

      // Convert IPFS URI to playable URL
      final audioUrl = _convertIPFSToUrl(musicNFT.uri);
      
      await _audioPlayer.play(UrlSource(audioUrl));
      
      state = state.copyWith(
        isLoading: false,
        isPlaying: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isPlaying: false,
        error: 'Failed to play audio: ${e.toString()}',
      );
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    state = state.copyWith(
      isPlaying: false,
      position: Duration.zero,
    );
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
    state = state.copyWith(volume: volume);
  }

  String _convertIPFSToUrl(String ipfsUri) {
    if (ipfsUri.startsWith('ipfs://')) {
      final hash = ipfsUri.substring(7);
      return 'https://ipfs.io/ipfs/$hash';
    }
    return ipfsUri;
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}

class AudioPlayerState {
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final double volume;
  final MusicNFT? currentNFT;
  final String? error;

  const AudioPlayerState({
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 0.7,
    this.currentNFT,
    this.error,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    Duration? duration,
    double? volume,
    MusicNFT? currentNFT,
    String? error,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      currentNFT: currentNFT ?? this.currentNFT,
      error: error ?? this.error,
    );
  }
}

final audioPlayerProvider = StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>(
  (ref) => AudioPlayerNotifier(),
);

// Enhanced BreathingScreen with Audio Integration
class BreathingScreen extends ConsumerStatefulWidget {
  final MusicNFT? selectedSong;
  const BreathingScreen({super.key, required this.selectedSong});

  @override
  ConsumerState<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends ConsumerState<BreathingScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  Timer? _breathingTimer;
  bool _isActive = false;
  String _currentPhase = 'inhale';
  String _breathingType = 'yang';
  int _cycleCount = 0;
  int _targetCycles = 10;
  bool _audioEnabled = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupAudio();
  }

  void _setupAnimations() {
    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _breathingController = AnimationController(
      duration: const Duration(seconds: 8), // 4 seconds inhale + 4 seconds exhale
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    _breathingAnimation.addListener(() {
      setState(() {
        _currentPhase = _breathingAnimation.value < 0.5 ? 'inhale' : 'exhale';
      });
    });

    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _cycleCount++;
        ref.read(breathingStateProvider.notifier).addCycle();
        
        if (_cycleCount >= _targetCycles) {
          _stopBreathing();
        } else {
          _breathingController.reset();
          _breathingController.forward();
        }
      }
    });
  }

  void _setupAudio() {
    if (widget.selectedSong != null && _audioEnabled) {
      // Automatically start playing the selected audio when screen loads
      Future.delayed(const Duration(milliseconds: 500), () {
        ref.read(audioPlayerProvider.notifier).playFromNFT(widget.selectedSong!);
      });
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _breathingController.dispose();
    _breathingTimer?.cancel();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isActive = true;
      _cycleCount = 0;
    });
    _waveController.repeat();
    _breathingController.forward();
    
    // Start audio if enabled and available
    if (_audioEnabled && widget.selectedSong != null) {
      final audioState = ref.read(audioPlayerProvider);
      if (!audioState.isPlaying) {
        ref.read(audioPlayerProvider.notifier).resume();
      }
    }
    
    ref.read(breathingStateProvider.notifier).startSession(_breathingType);
  }

  void _stopBreathing() {
    setState(() {
      _isActive = false;
      _currentPhase = 'inhale';
    });
    _waveController.stop();
    _breathingController.reset();
    
    // Pause audio when stopping breathing
    if (_audioEnabled) {
      ref.read(audioPlayerProvider.notifier).pause();
    }
    
    ref.read(breathingStateProvider.notifier).endSession();
  }

  void _toggleAudio() {
    setState(() {
      _audioEnabled = !_audioEnabled;
    });
    
    if (_audioEnabled && widget.selectedSong != null) {
      ref.read(audioPlayerProvider.notifier).playFromNFT(widget.selectedSong!);
    } else {
      ref.read(audioPlayerProvider.notifier).stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final breathingState = ref.watch(breathingStateProvider);
    final audioState = ref.watch(audioPlayerProvider);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _breathingType == 'yang' 
            ? AppTheme.yangGradient 
            : AppTheme.yinGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 20),
                _buildAudioPlayer(audioState),
                const SizedBox(height: 20),
                _buildTypeSelector(),
                const SizedBox(height: 40),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BreathingVisual(
                        isActive: _isActive,
                        phase: _currentPhase,
                        type: _breathingType,
                        animation: _breathingAnimation,
                      ),
                      const SizedBox(height: 40),
                      BreathingWave(
                        controller: _waveController,
                        isActive: _isActive,
                        type: _breathingType,
                      ),
                    ],
                  ),
                ),
                _buildControls(),
                const SizedBox(height: 20),
                _buildStats(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BackButton(color: Colors.white),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Breathing Session',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              _breathingType == 'yang' ? 'Energizing Breath' : 'Calming Breath',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAudioPlayer(AudioPlayerState audioState) {
    if (widget.selectedSong == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Row(
          children: [
            Icon(Icons.music_off, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'No audio selected',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.white.withOpacity(0.2),
                  child: widget.selectedSong!.coverImage.isNotEmpty
                      ? Image.network(
                          widget.selectedSong!.coverImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.music_note, color: Colors.white),
                        )
                      : const Icon(Icons.music_note, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.selectedSong!.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.selectedSong!.artistName,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _toggleAudio,
                icon: Icon(
                  _audioEnabled ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          if (_audioEnabled && audioState.duration > Duration.zero) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  _formatDuration(audioState.position),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: audioState.duration.inMilliseconds > 0
                        ? audioState.position.inMilliseconds / audioState.duration.inMilliseconds
                        : 0.0,
                    onChanged: (value) {
                      // Seek functionality would go here
                    },
                    activeColor: Colors.white,
                    inactiveColor: Colors.white.withOpacity(0.3),
                  ),
                ),
                Text(
                  _formatDuration(audioState.duration),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
          if (audioState.error != null) ...[
            const SizedBox(height: 8),
            Text(
              audioState.error!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _breathingType = 'yang'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _breathingType == 'yang' 
                    ? Colors.white.withOpacity(0.3) 
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wb_sunny, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Yang',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _breathingType = 'yin'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _breathingType == 'yin' 
                    ? Colors.white.withOpacity(0.3) 
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.nights_stay, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Yin',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    final audioState = ref.watch(audioPlayerProvider);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: _isActive ? Icons.stop : Icons.play_arrow,
          label: _isActive ? 'Stop' : 'Start',
          onPressed: _isActive ? _stopBreathing : _startBreathing,
        ),
        if (widget.selectedSong != null)
          _buildControlButton(
            icon: audioState.isPlaying ? Icons.pause : Icons.play_arrow,
            label: audioState.isPlaying ? 'Pause' : 'Play',
            onPressed: () {
              if (audioState.isPlaying) {
                ref.read(audioPlayerProvider.notifier).pause();
              } else {
                ref.read(audioPlayerProvider.notifier).resume();
              }
            },
          ),
        _buildControlButton(
          icon: Icons.settings,
          label: 'Settings',
          onPressed: _showSettings,
        ),
        _buildControlButton(
          icon: Icons.save,
          label: 'Save',
          onPressed: _saveSession,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    final breathingState = ref.watch(breathingStateProvider);
    final audioState = ref.watch(audioPlayerProvider);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Cycles', '$_cycleCount/$_targetCycles'),
              _buildStatItem('Type', _breathingType.toUpperCase()),
              _buildStatItem('Phase', _currentPhase.toUpperCase()),
              _buildStatItem('Sessions', '${breathingState.totalSessions}'),
            ],
          ),
          if (widget.selectedSong != null) ...[
            const SizedBox(height: 15),
            const Divider(color: Colors.white24),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Audio', _audioEnabled ? 'ON' : 'OFF'),
                _buildStatItem('Status', audioState.isPlaying ? 'PLAYING' : 'PAUSED'),
                _buildStatItem('Volume', '${(audioState.volume * 100).round()}%'),
                _buildStatItem('Track', widget.selectedSong!.title.length > 8 
                  ? '${widget.selectedSong!.title.substring(0, 8)}...' 
                  : widget.selectedSong!.title),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  void _showSettings() {
    final audioState = ref.read(audioPlayerProvider);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Text(
                'Breathing Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Target Cycles'),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() => 
                          _targetCycles = math.max(1, _targetCycles - 1)),
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$_targetCycles'),
                      IconButton(
                        onPressed: () => setState(() => _targetCycles++),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (widget.selectedSong != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Audio Volume'),
                    Expanded(
                      child: Slider(
                        value: audioState.volume,
                        onChanged: (value) {
                          ref.read(audioPlayerProvider.notifier).setVolume(value);
                        },
                        min: 0.0,
                        max: 1.0,
                      ),
                    ),
                    Text('${(audioState.volume * 100).round()}%'),
                  ],
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Enable Audio'),
                  value: _audioEnabled,
                  onChanged: (value) {
                    _toggleAudio();
                    Navigator.pop(context);
                  },
                ),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text('Save Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveSession() {
    ref.read(breathingStateProvider.notifier).saveSessionData({
      'type': _breathingType,
      'cycles': _cycleCount,
      'target': _targetCycles,
      'timestamp': DateTime.now().toIso8601String(),
      'audioTrack': widget.selectedSong?.title ?? 'No audio',
      'audioEnabled': _audioEnabled,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

class BreathingState {
  final bool isActive;
  final String currentType;
  final int totalSessions;
  final int totalCycles;
  final List<Map<String, dynamic>> sessionHistory;

  BreathingState({
    this.isActive = false,
    this.currentType = 'yang',
    this.totalSessions = 0,
    this.totalCycles = 0,
    this.sessionHistory = const [],
  });

  BreathingState copyWith({
    bool? isActive,
    String? currentType,
    int? totalSessions,
    int? totalCycles,
    List<Map<String, dynamic>>? sessionHistory,
  }) {
    return BreathingState(
      isActive: isActive ?? this.isActive,
      currentType: currentType ?? this.currentType,
      totalSessions: totalSessions ?? this.totalSessions,
      totalCycles: totalCycles ?? this.totalCycles,
      sessionHistory: sessionHistory ?? this.sessionHistory,
    );
  }
}

class BreathingStateNotifier extends StateNotifier<BreathingState> {
  BreathingStateNotifier() : super(BreathingState()) {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = prefs.getInt('breathing_total_sessions') ?? 0;
    final cycles = prefs.getInt('breathing_total_cycles') ?? 0;
    
    state = state.copyWith(
      totalSessions: sessions,
      totalCycles: cycles,
    );
  }

  void startSession(String type) {
    state = state.copyWith(
      isActive: true,
      currentType: type,
    );
  }

  void endSession() {
    state = state.copyWith(
      isActive: false,
      totalSessions: state.totalSessions + 1,
    );
    _saveData();
  }

  void addCycle() {
    state = state.copyWith(
      totalCycles: state.totalCycles + 1,
    );
  }

  void saveSessionData(Map<String, dynamic> sessionData) {
    final updatedHistory = [...state.sessionHistory, sessionData];
    state = state.copyWith(
      sessionHistory: updatedHistory,
    );
    _saveData();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('breathing_total_sessions', state.totalSessions);
    await prefs.setInt('breathing_total_cycles', state.totalCycles);
  }
}

final breathingStateProvider = StateNotifierProvider<BreathingStateNotifier, BreathingState>(
  (ref) => BreathingStateNotifier(),
);
class BreathingVisual extends StatefulWidget {
  final bool isActive;
  final String phase;
  final String type;
  final Animation<double> animation;

  const BreathingVisual({
    super.key,
    required this.isActive,
    required this.phase,
    required this.type,
    required this.animation,
  });

  @override
  State<BreathingVisual> createState() => _BreathingVisualState();
}

class _BreathingVisualState extends State<BreathingVisual>
    with TickerProviderStateMixin {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    if (widget.isActive) {
      _particleController.repeat();
    }
  }

  @override
  void didUpdateWidget(BreathingVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _particleController.repeat();
    } else if (!widget.isActive && oldWidget.isActive) {
      _particleController.stop();
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isYang = widget.type == 'yang';
    
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 4,
              ),
            ),
          ),
          
          // Main breathing circle
          AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) {
              final breathingScale = widget.isActive
                  ? (widget.phase == 'inhale' ? 1.25 : 0.75)
                  : 1.0;
              
              return Transform.scale(
                scale: breathingScale,
                child: Container(
                  width: 256,
                  height: 256,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isYang 
                        ? AppTheme.yangGradient
                        : AppTheme.yinGradient,
                    boxShadow: [
                      BoxShadow(
                        color: (isYang ? AppTheme.yangAccent : AppTheme.yinAccent)
                            .withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Inner glow
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        width: widget.isActive && widget.phase == 'inhale' ? 180 : 120,
                        height: widget.isActive && widget.phase == 'inhale' ? 180 : 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.6),
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      
                      // Center dot
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        width: widget.isActive && widget.phase == 'inhale' ? 24 : 16,
                        height: widget.isActive && widget.phase == 'inhale' ? 24 : 16,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Breathing instruction text
          Positioned(
            bottom: 20,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 500),
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.isActive ? 24 : 20,
                fontWeight: FontWeight.w600,
              ),
              child: Text(
                !widget.isActive 
                    ? "Ready to breathe" 
                    : widget.phase == 'inhale' 
                        ? 'Breathe In' 
                        : 'Breathe Out',
              ),
            ),
          ),
          
          // Particle effects for Yang
          if (isYang && widget.isActive) ...[
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(320, 320),
                  painter: YangParticlesPainter(_particleController.value),
                );
              },
            ),
          ],
          
          // Wave effects for Yin
          if (!isYang && widget.isActive) ...[
            AnimatedBuilder(
              animation: widget.animation,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(320, 320),
                  painter: YinWavesPainter(widget.animation.value, widget.phase),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class YangParticlesPainter extends CustomPainter {
  final double animationValue;

  YangParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw particles around the circle
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi * 2 / 8) + (animationValue * math.pi * 2);
      final particleRadius = radius * 0.8;
      final x = center.dx + math.cos(angle) * particleRadius;
      final y = center.dy + math.sin(angle) * particleRadius;
      
      final opacity = (math.sin(animationValue * math.pi * 4 + i) + 1) / 2;
      paint.color = Colors.white.withOpacity(opacity * 0.7);
      
      canvas.drawCircle(
        Offset(x, y),
        4 + (opacity * 3),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class YinWavesPainter extends CustomPainter {
  final double animationValue;
  final String phase;

  YinWavesPainter(this.animationValue, this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw expanding waves
    for (int i = 0; i < 3; i++) {
      final waveRadius = (size.width / 2) * 
          (0.6 + (animationValue + i * 0.3) % 1.0);
      
      paint.color = Colors.white.withOpacity(0.2 - (i * 0.05));
      canvas.drawCircle(center, waveRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BreathingWave extends StatefulWidget {
  final AnimationController controller;
  final bool isActive;
  final String type;

  const BreathingWave({
    super.key,
    required this.controller,
    required this.isActive,
    required this.type,
  });

  @override
  State<BreathingWave> createState() => _BreathingWaveState();
}

class _BreathingWaveState extends State<BreathingWave> {
  List<FlSpot> waveData = [];

  @override
  void initState() {
    super.initState();
    _generateWaveData();
    widget.controller.addListener(_onAnimationUpdate);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onAnimationUpdate);
    super.dispose();
  }

  void _onAnimationUpdate() {
    if (widget.isActive) {
      _generateWaveData();
    }
  }

  void _generateWaveData() {
    if (!mounted) return;
    
    setState(() {
      waveData = List.generate(100, (index) {
        final x = index.toDouble();
        final baseFrequency = widget.type == 'yang' ? 2.0 : 1.0;
        final amplitude = widget.isActive ? 1.0 : 0.3;
        final phase = widget.controller.value * 2 * math.pi;
        
        final y = amplitude * math.sin((x * baseFrequency * math.pi / 50) + phase);
        return FlSpot(x, y);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: waveData,
              isCurved: true,
              color: Colors.white,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ],
          minX: 0,
          maxX: 99,
          minY: -1.5,
          maxY: 1.5,
        ),
      ),
    );
  }
}


// import 'package:vibrani0m/breathprovider.dart';
// import 'package:vibrani0m/breathvisual.dart';
// import 'package:vibrani0m/breathwave.dart';
// import 'package:vibrani0m/theme.dart';

// class BreathingScreen extends ConsumerStatefulWidget {
//   final MusicNFT? selectedSong;
//   const BreathingScreen({super.key, required this.selectedSong});

//   @override
//   ConsumerState<BreathingScreen> createState() => _BreathingScreenState();
// }

// class _BreathingScreenState extends ConsumerState<BreathingScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _waveController;
//   late AnimationController _breathingController;
//   late Animation<double> _breathingAnimation;
//   Timer? _breathingTimer;
//   bool _isActive = false;
//   String _currentPhase = 'inhale';
//   String _breathingType = 'yang'; // 'yang' or 'yin'
//   int _cycleCount = 0;
//   int _targetCycles = 10;

//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//   }

//   void _setupAnimations() {
//     _waveController = AnimationController(
//       duration: const Duration(seconds: 4),
//       vsync: this,
//     );

//     _breathingController = AnimationController(
//       duration: const Duration(seconds: 8), // 4 seconds inhale + 4 seconds exhale
//       vsync: this,
//     );

//     _breathingAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _breathingController,
//       curve: Curves.easeInOut,
//     ));

//     _breathingAnimation.addListener(() {
//       setState(() {
//         _currentPhase = _breathingAnimation.value < 0.5 ? 'inhale' : 'exhale';
//       });
//     });

//     _breathingController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _cycleCount++;
//         if (_cycleCount >= _targetCycles) {
//           _stopBreathing();
//         } else {
//           _breathingController.reset();
//           _breathingController.forward();
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _waveController.dispose();
//     _breathingController.dispose();
//     _breathingTimer?.cancel();
//     super.dispose();
//   }

//   void _startBreathing() {
//     setState(() {
//       _isActive = true;
//       _cycleCount = 0;
//     });
//     _waveController.repeat();
//     _breathingController.forward();
    
//     // Update breathing state in provider
//     ref.read(breathingStateProvider.notifier).startSession(_breathingType);
//   }

//   void _stopBreathing() {
//     setState(() {
//       _isActive = false;
//       _currentPhase = 'inhale';
//     });
//     _waveController.stop();
//     _breathingController.reset();
    
//     // Update breathing state in provider
//     ref.read(breathingStateProvider.notifier).endSession();
//   }

//   void _toggleBreathingType() {
//     setState(() {
//       _breathingType = _breathingType == 'yang' ? 'yin' : 'yang';
//     });
//     if (_isActive) {
//       _stopBreathing();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final breathingState = ref.watch(breathingStateProvider);
    
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: _breathingType == 'yang' 
//             ? AppTheme.yangGradient 
//             : AppTheme.yinGradient,
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 _buildHeader(),
//                 const SizedBox(height: 40),
//                 _buildTypeSelector(),
//                 const SizedBox(height: 40),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       BreathingVisual(
//                         isActive: _isActive,
//                         phase: _currentPhase,
//                         type: _breathingType,
//                         animation: _breathingAnimation,
//                       ),
//                       const SizedBox(height: 40),
//                       BreathingWave(
//                         controller: _waveController,
//                         isActive: _isActive,
//                         type: _breathingType,
//                       ),
//                     ],
//                   ),
//                 ),
//                 _buildControls(),
//                 const SizedBox(height: 40),
//                 _buildStats(),
//                 const SizedBox(height: 100), // Space for bottom nav
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       children: [
//         Text(
//           'Breathing Therapy',
//           style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 10),
//         Text(
//           _breathingType == 'yang' ? 'Energizing Breath' : 'Calming Breath',
//           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//             color: Colors.white.withOpacity(0.9),
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildTypeSelector() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => _breathingType = 'yang'),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 decoration: BoxDecoration(
//                   color: _breathingType == 'yang' 
//                     ? Colors.white.withOpacity(0.3) 
//                     : Colors.transparent,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.wb_sunny,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       'Yang',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => _breathingType = 'yin'),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 decoration: BoxDecoration(
//                   color: _breathingType == 'yin' 
//                     ? Colors.white.withOpacity(0.3) 
//                     : Colors.transparent,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.nights_stay,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       'Yin',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildControls() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildControlButton(
//           icon: _isActive ? Icons.stop : Icons.play_arrow,
//           label: _isActive ? 'Stop' : 'Start',
//           onPressed: _isActive ? _stopBreathing : _startBreathing,
//         ),
//         _buildControlButton(
//           icon: Icons.settings,
//           label: 'Settings',
//           onPressed: _showSettings,
//         ),
//         _buildControlButton(
//           icon: Icons.save,
//           label: 'Save',
//           onPressed: _saveSession,
//         ),
//       ],
//     );
//   }

//   Widget _buildControlButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: Colors.white, size: 24),
//             const SizedBox(height: 5),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStats() {
//     final breathingState = ref.watch(breathingStateProvider);
    
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildStatItem('Cycles', '$_cycleCount/$_targetCycles'),
//           _buildStatItem('Type', _breathingType.toUpperCase()),
//           _buildStatItem('Phase', _currentPhase.toUpperCase()),
//           _buildStatItem('Sessions', '${breathingState.totalSessions}'),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.8),
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }

//   void _showSettings() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: 300,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             children: [
//               const Text(
//                 'Breathing Settings',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Target Cycles'),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () => setState(() => 
//                           _targetCycles = math.max(1, _targetCycles - 1)),
//                         icon: const Icon(Icons.remove),
//                       ),
//                       Text('$_targetCycles'),
//                       IconButton(
//                         onPressed: () => setState(() => _targetCycles++),
//                         icon: const Icon(Icons.add),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.primary,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 40,
//                     vertical: 15,
//                   ),
//                 ),
//                 child: const Text('Save Settings'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _saveSession() {
//     ref.read(breathingStateProvider.notifier).saveSessionData({
//       'type': _breathingType,
//       'cycles': _cycleCount,
//       'target': _targetCycles,
//       'timestamp': DateTime.now().toIso8601String(),
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Session saved successfully!'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
// }