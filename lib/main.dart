// // main.dart
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// void main() {
//   runApp(const ProviderScope(child: VibraniOmApp()));
// }

// class VibraniOmApp extends StatelessWidget {
//   const VibraniOmApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'VibraniOm',
//       theme: AppTheme.darkTheme,
//       home: const HomeScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// // theme.dart
// class AppTheme {
//   static const Color background = Color(0xFF0F0B1A);
//   static const Color surface = Color(0xFF1A1625);
//   static const Color primary = Color(0xFF8B5FFF);
//   static const Color primaryGlow = Color(0xFFB994FF);
//   static const Color secondary = Color(0xFF4FC3F7);
//   static const Color accent = Color(0xFF00E5FF);
//   static const Color textPrimary = Color(0xFFF5F3FF);
//   static const Color textSecondary = Color(0xFFB3B3B3);
//   static const Color yinAccent = Color(0xFF6366F1);
//   static const Color yangAccent = Color(0xFFFF6B6B);

//   static const LinearGradient yangGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFF6B9D)],
//   );

//   static const LinearGradient yinGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFF6B73FF)],
//   );

//   static const LinearGradient backgroundGradient = LinearGradient(
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//     colors: [Color(0xFF0F0B1A), Color(0xFF1A1625), Color(0xFF0F0B1A)],
//   );

//   static ThemeData get darkTheme {
//     return ThemeData(
//       brightness: Brightness.dark,
//       primaryColor: primary,
//       scaffoldBackgroundColor: background,
//       textTheme: const TextTheme(
//         headlineLarge: TextStyle(color: textPrimary, fontSize: 32, fontWeight: FontWeight.bold),
//         headlineMedium: TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
//         bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
//         bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
//       ),
//     );
//   }
// }

// // providers.dart
// final breathingStateProvider = StateNotifierProvider<BreathingStateNotifier, BreathingState>((ref) {
//   return BreathingStateNotifier();
// });

// class BreathingState {
//   final bool isActive;
//   final String currentType;
//   final int totalSessions;
//   final Map<String, dynamic> sessionData;

//   const BreathingState({
//     this.isActive = false,
//     this.currentType = 'yang',
//     this.totalSessions = 0,
//     this.sessionData = const {},
//   });

//   BreathingState copyWith({
//     bool? isActive,
//     String? currentType,
//     int? totalSessions,
//     Map<String, dynamic>? sessionData,
//   }) {
//     return BreathingState(
//       isActive: isActive ?? this.isActive,
//       currentType: currentType ?? this.currentType,
//       totalSessions: totalSessions ?? this.totalSessions,
//       sessionData: sessionData ?? this.sessionData,
//     );
//   }
// }

// class BreathingStateNotifier extends StateNotifier<BreathingState> {
//   BreathingStateNotifier() : super(const BreathingState());

//   void startSession(String type) {
//     state = state.copyWith(isActive: true, currentType: type);
//   }

//   void endSession() {
//     state = state.copyWith(
//       isActive: false,
//       totalSessions: state.totalSessions + 1,
//     );
//   }

//   void saveSessionData(Map<String, dynamic> data) {
//     state = state.copyWith(sessionData: data);
//   }
// }

// // home_screen.dart
// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _yinYangController;
//   late AnimationController _particleController;
//   late Animation<double> _rotationAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//   }

//   void _setupAnimations() {
//     _yinYangController = AnimationController(
//       duration: const Duration(seconds: 20),
//       vsync: this,
//     );

//     _particleController = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     );

//     _rotationAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(_yinYangController);

//     _yinYangController.repeat();
//     _particleController.repeat();
//   }

//   @override
//   void dispose() {
//     _yinYangController.dispose();
//     _particleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               _buildParticleBackground(),
//               _buildMainContent(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildParticleBackground() {
//     return AnimatedBuilder(
//       animation: _particleController,
//       builder: (context, child) {
//         return CustomPaint(
//           size: Size.infinite,
//           painter: ParticleBackgroundPainter(_particleController.value),
//         );
//       },
//     );
//   }

//   Widget _buildMainContent() {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           const SizedBox(height: 40),
//           _buildHeader(),
//           const SizedBox(height: 60),
//           Expanded(
//             child: _buildCentralYinYang(),
//           ),
//           _buildControlBar(),
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       children: [
//         ShaderMask(
//           shaderCallback: (bounds) => const LinearGradient(
//             colors: [AppTheme.primary, AppTheme.accent],
//           ).createShader(bounds),
//           child: const Text(
//             'VibraniOm',
//             style: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         const Text(
//           'Find your balance through sound and breath',
//           style: TextStyle(
//             color: AppTheme.textSecondary,
//             fontSize: 16,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildCentralYinYang() {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const SongSelectionScreen()),
//           );
//         },
//         child: AnimatedBuilder(
//           animation: _rotationAnimation,
//           builder: (context, child) {
//             return Transform.rotate(
//               angle: _rotationAnimation.value * 2 * 3.14159,
//               child: Container(
//                 width: 250,
//                 height: 250,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppTheme.primary.withOpacity(0.3),
//                       blurRadius: 30,
//                       spreadRadius: 10,
//                     ),
//                   ],
//                 ),
//                 child: CustomPaint(
//                   painter: YinYangPainter(),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildControlBar() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppTheme.surface.withOpacity(0.8),
//         borderRadius: BorderRadius.circular(25),
//         border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildControlItem(
//             icon: Icons.music_note,
//             label: 'Songs',
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const SongSelectionScreen()),
//             ),
//           ),
//           _buildControlItem(
//             icon: Icons.air,
//             label: 'Breathe',
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const BreathingScreen()),
//             ),
//           ),
//           _buildControlItem(
//             icon: Icons.person,
//             label: 'Profile',
//             onTap: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const RegistrationScreen()),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildControlItem({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: AppTheme.primary.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: AppTheme.primary, size: 24),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: const TextStyle(
//               color: AppTheme.textPrimary,
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // song_selection_screen.dart
// class SongSelectionScreen extends StatefulWidget {
//   const SongSelectionScreen({super.key});

//   @override
//   State<SongSelectionScreen> createState() => _SongSelectionScreenState();
// }

// class _SongSelectionScreenState extends State<SongSelectionScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _waveController;
//   String selectedSide = '';
  
//   final List<Song> yinSongs = [
//     Song('Calm Waters', 60, 'Relaxing', Colors.blue),
//     Song('Forest Whispers', 55, 'Nature', Colors.green),
//     Song('Deep Sleep', 45, 'Meditation', Colors.purple),
//   ];
  
//   final List<Song> yangSongs = [
//     Song('Energy Burst', 140, 'Energizing', Colors.orange),
//     Song('Power Flow', 130, 'Workout', Colors.red),
//     Song('Morning Rush', 125, 'Motivation', Colors.yellow),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _waveController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//     _waveController.repeat();
//   }

//   @override
//   void dispose() {
//     _waveController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildHeader(),
//               Expanded(
//                 child: _buildYinYangSelector(),
//               ),
//               if (selectedSide.isNotEmpty) _buildSongList(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
//           ),
//           const Expanded(
//             child: Text(
//               'Choose Your Vibe',
//               style: TextStyle(
//                 color: AppTheme.textPrimary,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(width: 48),
//         ],
//       ),
//     );
//   }

//   Widget _buildYinYangSelector() {
//     return Center(
//       child: GestureDetector(
//         onTapDown: (details) {
//           final box = context.findRenderObject() as RenderBox?;
//           if (box != null) {
//             final localPosition = box.globalToLocal(details.globalPosition);
//             final center = Offset(box.size.width / 2, box.size.height / 2);
//             setState(() {
//               selectedSide = localPosition.dx < center.dx ? 'yin' : 'yang';
//             });
//           }
//         },
//         child: Container(
//           width: 300,
//           height: 300,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: selectedSide == 'yin' 
//                   ? AppTheme.yinAccent.withOpacity(0.5)
//                   : selectedSide == 'yang'
//                     ? AppTheme.yangAccent.withOpacity(0.5)
//                     : AppTheme.primary.withOpacity(0.3),
//                 blurRadius: 30,
//                 spreadRadius: 10,
//               ),
//             ],
//           ),
//           child: CustomPaint(
//             painter: InteractiveYinYangPainter(selectedSide),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSongList() {
//     final songs = selectedSide == 'yin' ? yinSongs : yangSongs;
    
//     return Container(
//       height: 300,
//       margin: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppTheme.surface.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Text(
//               selectedSide == 'yin' ? 'Calming Songs' : 'Energizing Songs',
//               style: const TextStyle(
//                 color: AppTheme.textPrimary,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: songs.length,
//               itemBuilder: (context, index) {
//                 final song = songs[index];
//                 return _buildSongItem(song);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSongItem(Song song) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: AppTheme.background.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: song.color.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: song.color.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: AnimatedBuilder(
//               animation: _waveController,
//               builder: (context, child) {
//                 return CustomPaint(
//                   painter: WaveformPainter(
//                     _waveController.value,
//                     song.bpm,
//                     song.color,
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   song.name,
//                   style: const TextStyle(
//                     color: AppTheme.textPrimary,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${song.bpm} BPM • ${song.genre}',
//                   style: const TextStyle(
//                     color: AppTheme.textSecondary,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             onPressed: () => _playSong(song),
//             icon: Icon(
//               Icons.play_arrow,
//               color: song.color,
//               size: 28,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _playSong(Song song) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => BreathingScreen(selectedSong: song),
//       ),
//     );
//   }
// }

// // breathing_screen.dart
// class BreathingScreen extends ConsumerStatefulWidget {
//   final Song? selectedSong;
  
//   const BreathingScreen({super.key, this.selectedSong});

//   @override
//   ConsumerState<BreathingScreen> createState() => _BreathingScreenState();
// }

// class _BreathingScreenState extends ConsumerState<BreathingScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _waveController;
//   late AnimationController _breathingController;
//   late Animation<double> _breathingAnimation;
  
//   bool _isActive = false;
//   String _currentPhase = 'inhale';
//   String _breathingType = 'yang';
//   int _cycleCount = 0;
//   final int _targetCycles = 10;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.selectedSong != null) {
//       _breathingType = widget.selectedSong!.bpm < 100 ? 'yin' : 'yang';
//     }
//     _setupAnimations();
//   }

//   void _setupAnimations() {
//     _waveController = AnimationController(
//       duration: const Duration(seconds: 4),
//       vsync: this,
//     );

//     _breathingController = AnimationController(
//       duration: const Duration(seconds: 8),
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
//     super.dispose();
//   }

//   void _startBreathing() {
//     setState(() {
//       _isActive = true;
//       _cycleCount = 0;
//     });
//     _waveController.repeat();
//     _breathingController.forward();
//     ref.read(breathingStateProvider.notifier).startSession(_breathingType);
//   }

//   void _stopBreathing() {
//     setState(() {
//       _isActive = false;
//       _currentPhase = 'inhale';
//     });
//     _waveController.stop();
//     _breathingController.reset();
//     ref.read(breathingStateProvider.notifier).endSession();
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
//                 _buildHeader(),
//                 const SizedBox(height: 40),
//                 if (widget.selectedSong != null) _buildSongInfo(),
//                 const SizedBox(height: 40),
//                 Expanded(
//                   child: _buildBreathingVisual(),
//                 ),
//                 _buildControls(),
//                 const SizedBox(height: 40),
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
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: song.color.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(Icons.music_note, color: Colors.white),
//           ),
//           const SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   song.name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Text(
//                   '${song.bpm} BPM • ${song.genre}',
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
//       child: AnimatedBuilder(
//         animation: _breathingAnimation,
//         builder: (context, child) {
//           return Container(
//             width: 200 + (100 * _breathingAnimation.value),
//             height: 200 + (100 * _breathingAnimation.value),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: RadialGradient(
//                 colors: _breathingType == 'yang'
//                   ? [Colors.orange.withOpacity(0.8), Colors.red.withOpacity(0.3)]
//                   : [Colors.blue.withOpacity(0.8), Colors.purple.withOpacity(0.3)],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: (_breathingType == 'yang' ? Colors.orange : Colors.blue)
//                       .withOpacity(0.3 + (0.4 * _breathingAnimation.value)),
//                   blurRadius: 30 + (20 * _breathingAnimation.value),
//                   spreadRadius: 10 + (10 * _breathingAnimation.value),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Text(
//                 _currentPhase.toUpperCase(),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24 + (8 * _breathingAnimation.value),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           );
//         },
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
//           onPressed: () {},
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
// }

// // registration_screen.dart
// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({super.key});

//   @override
//   State<RegistrationScreen> createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnimation;
  
//   String _selectedType = '';

//   @override
//   void initState() {
//     super.initState();
    
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
    
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
//     );
    
//     _fadeController.forward();
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
//                       ),
//                       const Expanded(
//                         child: Text(
//                           'Choose Your Path',
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: AppTheme.textPrimary,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       const SizedBox(width: 48),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Select whether you want to join as a Listener or an Artist. Each path offers unique benefits and features tailored to your experience.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 14, height: 1.5, color: AppTheme.textSecondary),
//                   ),
//                   const SizedBox(height: 32),
                  
//                   GestureDetector(
//                     onTapDown: (details) {
//                       final box = context.findRenderObject() as RenderBox?;
//                       if (box != null) {
//                         final localPosition = box.globalToLocal(details.globalPosition);
//                         final center = Offset(box.size.width / 2, box.size.height / 2);
//                         final isYin = localPosition.dx < center.dx;
//                         _handleYinYangTap(isYin);
//                       }
//                     },
//                     child: Container(
//                       width: 200,
//                       height: 200,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppTheme.primary.withOpacity(0.3),
//                             blurRadius: 30,
//                             spreadRadius: 10,
//                           ),
//                         ],
//                       ),
//                       child: CustomPaint(
//                         painter: YinYangPainter(),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Text(
//                     'Tap the ${_selectedType.isEmpty ? 'Yin (left)' : _selectedType == 'listener' ? 'Yin (left) - Listener' : 'Yang (right) - Artist'} to select your role',
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
//                   ),
//                   const SizedBox(height: 24),
                  
//                   if (_selectedType.isNotEmpty)
//                     Text(
//                       'Selected: ${_selectedType == 'listener' ? 'Listener' : 'Artist'}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppTheme.primary,
//                       ),
//                     ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(builder: (context) => const HomeScreen()),
//                     ), 
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppTheme.primary,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
//                     ),
//                     child: const Text('Skip Registration'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleYinYangTap(bool isYin) {
//     setState(() {
//       _selectedType = isYin ? 'listener' : 'artist';
//     });
//   }
// }

// // Models
// class Song {
//   final String name;
//   final int bpm;
//   final String genre;
//   final Color color;

//   Song(this.name, this.bpm, this.genre, this.color);
// }

// // Custom Painters
// class YinYangPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;

//     // White half
//     final whitePaint = Paint()..color = Colors.white;
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       -3.14159 / 2,
//       3.14159,
//       false,
//       whitePaint,
//     );

//     // Black half
//     final blackPaint = Paint()..color = Colors.black;
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       3.14159 / 2,
//       3.14159,
//       false,
//       blackPaint,
//     );

//     // Small circles
//     canvas.drawCircle(
//       Offset(center.dx, center.dy - radius / 2),
//       radius / 4,
//       blackPaint,
//     );
//     canvas.drawCircle(
//       Offset(center.dx, center.dy + radius / 2),
//       radius / 4,
//       whitePaint,
//     );

//     // Small dots
//     canvas.drawCircle(
//       Offset(center.dx, center.dy - radius / 2),
//       radius / 8,
//       whitePaint,
//     );
//     canvas.drawCircle(
//       Offset(center.dx, center.dy + radius / 2),
//       radius / 8,
//       blackPaint,
//     );

//     // Border
//     final borderPaint = Paint()
//       ..color = AppTheme.primary
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3;
//     canvas.drawCircle(center, radius, borderPaint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

// class InteractiveYinYangPainter extends CustomPainter {
//   final String selectedSide;

//   InteractiveYinYangPainter(this.selectedSide);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width / 2;

//     // Base colors with selection highlighting
//     final yinColor = selectedSide == 'yin' ? AppTheme.yinAccent : Colors.white;
//     final yangColor = selectedSide == 'yang' ? AppTheme.yangAccent : Colors.black;

//     // Yin half (left)
//     final yinPaint = Paint()..color = yinColor;
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       3.14159 / 2,
//       3.14159,
//       false,
//       yinPaint,
//     );

//     // Yang half (right)
//     final yangPaint = Paint()..color = yangColor;
//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       -3.14159 / 2,
//       3.14159,
//       false,
//       yangPaint,
//     );

//     // Small circles
//     canvas.drawCircle(
//       Offset(center.dx, center.dy - radius / 2),
//       radius / 4,
//       yangPaint,
//     );
//     canvas.drawCircle(
//       Offset(center.dx, center.dy + radius / 2),
//       radius / 4,
//       yinPaint,
//     );

//     // Small dots
//     canvas.drawCircle(
//       Offset(center.dx, center.dy - radius / 2),
//       radius / 8,
//       yinPaint,
//     );
//     canvas.drawCircle(
//       Offset(center.dx, center.dy + radius / 2),
//       radius / 8,
//       yangPaint,
//     );

//     // Glowing border
//     final borderPaint = Paint()
//       ..color = selectedSide == 'yin' 
//         ? AppTheme.yinAccent 
//         : selectedSide == 'yang' 
//           ? AppTheme.yangAccent
//           : AppTheme.primary
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4;
//     canvas.drawCircle(center, radius, borderPaint);

//     // Labels
//     final textPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//     );

//     // Yin label
//     textPainter.text = TextSpan(
//       text: 'YIN',
//       style: TextStyle(
//         color: selectedSide == 'yin' ? Colors.white : AppTheme.textSecondary,
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//     textPainter.layout();
//     textPainter.paint(
//       canvas,
//       Offset(center.dx - radius / 2 - textPainter.width / 2, center.dy + radius + 20),
//     );

//     // Yang label
//     textPainter.text = TextSpan(
//       text: 'YANG',
//       style: TextStyle(
//         color: selectedSide == 'yang' ? Colors.white : AppTheme.textSecondary,
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//     textPainter.layout();
//     textPainter.paint(
//       canvas,
//       Offset(center.dx + radius / 2 - textPainter.width / 2, center.dy + radius + 20),
//     );
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

// class WaveformPainter extends CustomPainter {
//   final double animationValue;
//   final int bpm;
//   final Color color;

//   WaveformPainter(this.animationValue, this.bpm, this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     final path = Path();
//     final width = size.width;
//     final height = size.height;
//     final frequency = bpm / 60.0; // Convert BPM to frequency

//     for (int x = 0; x < width.toInt(); x++) {
//       final normalizedX = x / width;
//       final wave = sin((normalizedX * frequency * 2 * 3.14159) + (animationValue * 2 * 3.14159));
//       final y = (height / 2) + (wave * height / 4);
      
//       if (x == 0) {
//         path.moveTo(x.toDouble(), y);
//       } else {
//         path.lineTo(x.toDouble(), y);
//       }
//     }

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

// class ParticleBackgroundPainter extends CustomPainter {
//   final double animationValue;

//   ParticleBackgroundPainter(this.animationValue);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..style = PaintingStyle.fill;

//     // Draw floating particles
//     for (int i = 0; i < 20; i++) {
//       final x = (i * 37.0) % size.width;
//       final y = (sin(animationValue * 2 + i) * 100 + size.height / 2) % size.height;
//       final opacity = (sin(animationValue + i) * 0.3 + 0.7).clamp(0.0, 1.0);
      
//       paint.color = AppTheme.primary.withOpacity(opacity * 0.1);
//       canvas.drawCircle(Offset(x, y), 2 + sin(animationValue + i), paint);
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }

// # VibraniOm Flutter App - Production Ready

// ## pubspec.yaml
// ```yaml
// name: vibraniom
// description: VibraniOm - Blockchain Music Therapy Platform
// publish_to: 'none'
// version: 1.0.0+1

// environment:
//   sdk: '>=3.0.0 <4.0.0'
//   flutter: ">=3.10.0"

// dependencies:
//   flutter:
//     sdk: flutter
//   cupertino_icons: ^1.0.6
  
//   # State Management
//   flutter_riverpod: ^2.4.9
  
//   # Blockchain & Payments
//   para: ^2.1.0
//   web3dart: ^2.7.3
//   http: ^1.1.0
  
//   # UI & Animations
//   flutter_animate: ^4.5.0
//   shimmer: ^3.0.0
//   lottie: ^2.7.0
  
//   # Storage & Data
//   shared_preferences: ^2.2.2
//   path_provider: ^2.1.1
//   sqflite: ^2.3.0
  
//   # Audio & Media
//   just_audio: ^0.9.36
//   audio_waveforms: ^1.0.5
  
//   # Utils
//   intl: ^0.18.1
//   crypto: ^3.0.3
//   flutter_dotenv: ^5.1.0

// dev_dependencies:
//   flutter_test:
//     sdk: flutter
//   flutter_lints: ^3.0.1

// flutter:
//   uses-material-design: true
//   assets:
//     - assets/
//     - .env
// ```

// ## .env
// ```
// MONAD_RPC_URL=https://testnet-rpc.monad.xyz
// VIBRANIOM_CONTRACT_ADDRESS=0x...
// TOURS_TOKEN_ADDRESS=0x...
// PARA_API_KEY=your_para_api_key
// IPFS_GATEWAY=https://gateway.pinata.cloud/ipfs/
// ```

// ## lib/main.dart
// ```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:para/para.dart';
import 'package:vibraniomx/splash.dart';
import 'package:vibraniomx/theme.dart';
// import 'screens/splash_screen.dart';
// import 'core/theme/app_theme.dart';
// import 'core/services/blockchain_service.dart';

// Para Configuration
final para = Para(
  apiKey: 'beta_d40c508f09afc22ea9294806cac821e2', // Get from: https://developer.getpara.com
  environment: Environment.beta, // Use Environment.prod for production
  // config: ParaConfig(
  //   enableLogging: true,
  //   defaultNetwork: ParaNetwork.solana,
  // ),
  // appScheme: 'yourapp', // Your app's scheme (without ://)
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize Para SDK
  // await Para.init(
  //   apiKey: dotenv.env['beta_d40c508f09afc22ea9294806cac821e2']!,
  //   environment: ParaEnvironment.testnet,
  // );
  
  runApp(
    ProviderScope(
      child: VibraniOmApp(),
    ),
  );
}

class VibraniOmApp extends StatelessWidget {
  const VibraniOmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VibraniOm',
      theme: AppTheme.darkTheme,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}