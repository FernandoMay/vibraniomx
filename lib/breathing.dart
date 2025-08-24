
// ## lib/screens/breathing_screen.dart
// ```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vibraniomx/musicnft.dart';
import 'package:vibraniomx/theme.dart';
// import '../core/theme/app_theme.dart';
// import '../core/models/music_nft.dart';
// import '../widgets/breathing_visualizer.dart';
// import '../widgets/loading_button.dart';

class BreathingScreen extends ConsumerStatefulWidget {
  final MusicNFT? selectedSong;
  
  const BreathingScreen({super.key, this.selectedSong});

  @override
  ConsumerState<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends ConsumerState<BreathingScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _waveController;
  late Animation<double> _breathingAnimation;
  
  bool _isActive = false;
  String _currentPhase = 'inhale';
  String _breathingType = 'yang';
  int _cycleCount = 0;
  int _targetCycles = 10;

  @override
  void initState() {
    super.initState();
    if (widget.selectedSong != null) {
      _breathingType = _determineBreathingType(widget.selectedSong!);
    }
    _setupAnimations();
  }

  String _determineBreathingType(MusicNFT song) {
    // Analyze mood categories to determine breathing type
    final energeticMoods = [1, 4, 6, 10]; // Energetic, Focused, Uplifting, Motivational
    final calmMoods = [0, 3, 7, 8]; // Calm, Sad, Meditative, Peaceful
    
    int energeticCount = song.moodCategories.where((mood) => energeticMoods.contains(mood)).length;
    int calmCount = song.moodCategories.where((mood) => calmMoods.contains(mood)).length;
    
    return energeticCount > calmCount ? 'yang' : 'yin';
  }

  void _setupAnimations() {
    _breathingController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(seconds: 4),
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
        setState(() {
          _cycleCount++;
        });
        if (_cycleCount >= _targetCycles) {
          _stopBreathing();
        } else {
          _breathingController.reset();
          _breathingController.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isActive = true;
      _cycleCount = 0;
    });
    _waveController.repeat();
    _breathingController.forward();
  }

  void _stopBreathing() {
    setState(() {
      _isActive = false;
      _currentPhase = 'inhale';
    });
    _waveController.stop();
    _breathingController.reset();
  }

  @override
  Widget build(BuildContext context) {
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
                _buildHeader(),
                const SizedBox(height: 40),
                if (widget.selectedSong != null) _buildSongInfo(),
                const SizedBox(height: 40),
                Expanded(child: _buildBreathingVisual()),
                _buildControls(),
                const SizedBox(height: 20),
                _buildStats(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const Expanded(
              child: Text(
                'Breathing Session',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _breathingType == 'yang' ? 'Energizing Breath' : 'Calming Breath',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSongInfo() {
    final song = widget.selectedSong!;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: song.primaryMoodColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.music_note, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'by ${song.artistName}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingVisual() {
    return Center(
      child: BreathingVisualizer(
        animation: _breathingAnimation,
        breathingType: _breathingType,
        currentPhase: _currentPhase,
        isActive: _isActive,
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: _isActive ? Icons.stop : Icons.play_arrow,
          label: _isActive ? 'Stop' : 'Start',
          onPressed: _isActive ? _stopBreathing : _startBreathing,
        ),
        _buildControlButton(
          icon: Icons.refresh,
          label: 'Reset',
          onPressed: () {
            _stopBreathing();
            setState(() {
              _cycleCount = 0;
            });
          },
        ),
        _buildControlButton(
          icon: Icons.settings,
          label: 'Settings',
          onPressed: _showSettingsDialog,
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Cycles', '$_cycleCount/$_targetCycles'),
          _buildStatItem('Type', _breathingType.toUpperCase()),
          _buildStatItem('Phase', _currentPhase.toUpperCase()),
          _buildStatItem('Progress', '${((_cycleCount / _targetCycles) * 100).toInt()}%'),
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
            fontSize: 16,
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Breathing Settings', style: TextStyle(color: AppTheme.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Target Cycles', style: TextStyle(color: AppTheme.textPrimary)),
              trailing: DropdownButton<int>(
                value: _targetCycles,
                items: [5, 10, 15, 20].map((cycles) => 
                  DropdownMenuItem(
                    value: cycles,
                    child: Text('$cycles', style: const TextStyle(color: AppTheme.textPrimary)),
                  ),
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _targetCycles = value ?? 10;
                  });
                  Navigator.pop(context);
                },
                dropdownColor: AppTheme.surface,
              ),
            ),
            ListTile(
              title: const Text('Breathing Type', style: TextStyle(color: AppTheme.textPrimary)),
              trailing: DropdownButton<String>(
                value: _breathingType,
                items: ['yin', 'yang'].map((type) => 
                  DropdownMenuItem(
                    value: type,
                    child: Text(type.toUpperCase(), style: const TextStyle(color: AppTheme.textPrimary)),
                  ),
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _breathingType = value ?? 'yang';
                  });
                  Navigator.pop(context);
                },
                dropdownColor: AppTheme.surface,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
    );
  }
}

class BreathingVisualizer extends StatelessWidget {
  final Animation<double> animation;
  final String breathingType;
  final String currentPhase;
  final bool isActive;

  const BreathingVisualizer({
    super.key,
    required this.animation,
    required this.breathingType,
    required this.currentPhase,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        double scale = 1.0 + (animation.value * 0.5);
        if (currentPhase == 'exhale') {
          scale = 1.5 - (animation.value * 0.5);
        }
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: breathingType == 'yang'
                ? AppTheme.yangGradient
                : AppTheme.yinGradient,
              boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 20 * animation.value,
                      spreadRadius: 5 * animation.value,
                    ),
                  ]
                : [],
            ),
            child: Center(
              child: Icon(
                isActive 
                  ? (currentPhase == 'inhale' ? Icons.arrow_upward : Icons.arrow_downward)
                  : Icons.pause,
                color: Colors.white.withOpacity(0.8),
                size: 48,
              ),
            ),
          ),
        );
      },
    );
  }
}