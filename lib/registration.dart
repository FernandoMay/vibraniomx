
// ## lib/screens/registration_screen.dart
// ```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibraniomx/chainservice.dart';
import 'package:vibraniomx/home.dart';
import 'package:vibraniomx/loading.dart';
import 'package:vibraniomx/providers.dart';
import 'package:vibraniomx/theme.dart';
import 'package:vibraniomx/yinyang.dart';
// import '../core/theme/app_theme.dart';
// import '../core/providers/app_providers.dart';
// import '../core/services/blockchain_service.dart';
// import '../widgets/yin_yang_widget.dart';
// import '../widgets/loading_button.dart';
// import 'home_screen.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  String _selectedType = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildYinYangSelector(),
                  const SizedBox(height: 24),
                  _buildInstructions(),
                  const SizedBox(height: 24),
                  if (_selectedType.isNotEmpty) _buildSelectedInfo(),
                  const SizedBox(height: 32),
                  _buildActions(),
                ],
              ),
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
              icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            ),
            const Expanded(
              child: Text(
                'Choose Your Path',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Select whether you want to join as a Listener or an Artist. Each path offers unique benefits and features.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14, 
            height: 1.5, 
            color: AppTheme.textSecondary
          ),
        ),
      ],
    );
  }

  Widget _buildYinYangSelector() {
    return GestureDetector(
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final localPosition = box.globalToLocal(details.globalPosition);
          final center = Offset(box.size.width / 2, box.size.height / 2);
          final isYin = localPosition.dx < center.dx;
          _handleYinYangTap(isYin);
        }
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _selectedType == 'listener'
                  ? AppTheme.yinAccent.withOpacity(0.5)
                  : _selectedType == 'artist'
                    ? AppTheme.yangAccent.withOpacity(0.5)
                    : AppTheme.primary.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: YinYangButton()
        // YinYangWidget(
        //   size: 200,
        //   interactive: true,
        //   onTap: _handleYinYangTap,
        //   // selectedSide: _selectedType == 'listener' ? 'yin' : _selectedType == 'artist' ? 'yang' : '',
        // ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Text(
      'Tap the ${_selectedType.isEmpty ? 'Yin (left) for Listener or Yang (right) for Artist' : _selectedType == 'listener' ? 'Yin (left) - Listener selected' : 'Yang (right) - Artist selected'}',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
    );
  }

  Widget _buildSelectedInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _selectedType == 'listener' 
            ? AppTheme.yinAccent.withOpacity(0.5)
            : AppTheme.yangAccent.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Selected: ${_selectedType == 'listener' ? 'Listener' : 'Artist'}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _selectedType == 'listener' ? AppTheme.yinAccent : AppTheme.yangAccent,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _selectedType == 'listener'
              ? '• Pay 1 MON registration fee\n• Get 10 TOURS tokens\n• Access music recommendations\n• Stream and rate music\n• Earn rewards for engagement'
              : '• Register for free\n• Upload music for 1 MON per track\n• Earn from music sales\n• Get streaming rewards\n• Build your fanbase',
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: AppTheme.textPrimary,
            ),
          ),
          if (_selectedType == 'listener') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.yinAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Registration Fee: 1 MON\nReward: 10 TOURS tokens',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        if (_selectedType.isNotEmpty)
          LoadingButton(
            text: _selectedType == 'listener' ? 'Connect & Register as Listener' : 'Connect & Register as Artist',
            onPressed: () => _handleRegistration(_selectedType == 'listener'),
            isLoading: _isLoading,
            gradient: _selectedType == 'listener' ? AppTheme.yinGradient : AppTheme.yangGradient,
          ),
        const SizedBox(height: 16),
        // OutlinedButton(
        //   onPressed: () => Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (context) => HomeScreen()),
        //   ),
        //   style: OutlinedButton.styleFrom(
        //     side: const BorderSide(color: AppTheme.primary),
        //     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        //   ),
        //   child: const Text(
        //     'Skip Registration',
        //     style: TextStyle(color: AppTheme.primary),
        //   ),
        // ),
      ],
    );
  }

  void _handleYinYangTap(bool isYin) {
    setState(() {
      _selectedType = isYin ? 'listener' : 'artist';
    });
  }

  Future<void> _handleRegistration(bool isListener) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final blockchainService = BlockchainService();
      final appStateNotifier = ref.read(appStateProvider.notifier);

      // Connect wallet if not connected
      if (!blockchainService.isConnected) {
        final connected = await blockchainService.connectWallet();
        if (!connected) {
          throw Exception('Failed to connect wallet');
        }
        appStateNotifier.setConnected(true, blockchainService.userAddress);
      }

      // Register user
      bool success;
      if (isListener) {
        success = await blockchainService.registerAsListener();
      } else {
        success = await blockchainService.registerAsArtist();
      }

      if (success) {
        _showSuccessDialog(isListener);
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(bool isListener) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.success),
            SizedBox(width: 8),
            Text('Welcome to VibraniOm!', style: TextStyle(color: AppTheme.textPrimary)),
          ],
        ),
        content: Text(
          isListener
            ? 'You are now part of the community. Click and reduce your stress.'
            : 'Upload your first song, help reduce stress, and give visibility to your music.',
          style: const TextStyle(fontSize: 14, height: 1.4, color: AppTheme.textPrimary),
        ),
        actions: [
          LoadingButton(
            text: 'Continue',
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            isLoading: false,
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error, color: AppTheme.error),
            SizedBox(width: 8),
            Text('Registration Failed', style: TextStyle(color: AppTheme.textPrimary)),
          ],
        ),
        content: Text(
          'Error: $error',
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK', style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
    );
  }
}