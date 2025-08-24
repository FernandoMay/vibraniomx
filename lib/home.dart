// ```

// ## lib/screens/home_screen.dart
// ```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibraniomx/breathing.dart';
import 'package:vibraniomx/connectionstatus.dart';
import 'package:vibraniomx/controlbar.dart';
import 'package:vibraniomx/particle.dart';
import 'package:vibraniomx/profile.dart';
import 'package:vibraniomx/providers.dart';
import 'package:vibraniomx/registration.dart';
import 'package:vibraniomx/songselection.dart';
import 'package:vibraniomx/theme.dart';
import 'package:vibraniomx/yinyang.dart';
// import '../core/theme/app_theme.dart';
// import '../core/providers/app_providers.dart';
// import '../core/services/blockchain_service.dart';
// import '../widgets/yin_yang_widget.dart';
// import '../widgets/particle_background.dart';
// import '../widgets/control_bar.dart';
// import '../widgets/connection_status.dart';
// import 'registration_screen.dart';
// import 'breathing_screen.dart';
// import 'song_selection_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _yinYangController;
  late AnimationController _particleController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _yinYangController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_yinYangController);

    _yinYangController.repeat();
    _particleController.repeat();
  }

  @override
  void dispose() {
    _yinYangController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [
              ParticleBackground(animationController: _particleController),
              _buildMainContent(appState),
              Positioned(
                top: 20,
                right: 20,
                child: ConnectionStatus(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(AppState appState) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildHeader(),
          const SizedBox(height: 60),
          if (appState.userProfile != null) _buildUserInfo(appState.userProfile!),
          const SizedBox(height: 20),
          Expanded(child: _buildCentralYinYang()),
          ControlBar(
            onSongsPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SongSelectionScreen()),
            ),
            onBreathePressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BreathingScreen()),
            ),
            onProfilePressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationScreen()),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppTheme.primary, AppTheme.accent],
          ).createShader(bounds),
          child: const Text(
            'VibraniOm',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Find your balance through sound and breath',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUserInfo(UserProfile profile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildUserStat(
            'Type', 
            profile.userType == UserType.listener ? 'Listener' : 'Artist'
          ),
          _buildUserStat(
            'Subscription', 
            profile.hasActiveSubscription ? 'Active' : 'Expired'
          ),
          _buildUserStat('Moods', '${profile.recentMoods.length}'),
        ],
      ),
    );
  }

  Widget _buildUserStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCentralYinYang() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SongSelectionScreen()),
          );
        },
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: YinYangWidget(size: 250),
              ),
            );
          },
        ),
      ),
    );
  }
}

