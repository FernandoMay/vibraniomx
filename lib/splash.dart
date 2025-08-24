// ```

// ## lib/screens/splash_screen.dart
// ```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibraniomx/chainservice.dart';
import 'package:vibraniomx/home.dart';
import 'package:vibraniomx/theme.dart';
import 'package:vibraniomx/yinyang.dart';
// import '../core/theme/app_theme.dart';
// import '../core/services/blockchain_service.dart';
// import '../widgets/yin_yang_widget.dart';
// import 'home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await BlockchainService().initialize();
      // await Future.delayed(const Duration(seconds: 3));
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print('Initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // YinYangWidget(size: 150)
              YinYangButton()
                .animate(onPlay: (controller) => controller.repeat())
                .rotate(duration: 4000.ms),
              
              const SizedBox(height: 40),
              
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.accent],
                ).createShader(bounds),
                child: const Text(
                  'VibraniOm',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 1000.ms),
              
              const SizedBox(height: 20),
              
              const Text(
                'Blockchain Music Sessions',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
              ).animate().fadeIn(delay: 1000.ms, duration: 1000.ms),
              
              const SizedBox(height: 60),
              
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
              ).animate().fadeIn(delay: 1500.ms),
            ],
          ),
        ),
      ),
    );
  }
}