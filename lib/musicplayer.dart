// ## lib/widgets/music_player.dart
// ```dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibraniomx/theme.dart';
// import 'package:vibrani0m/theme.dart';

class MusicPlayer extends StatefulWidget {
  final Map<String, dynamic> song;
  final VoidCallback onLikeToggle;

  const MusicPlayer({
    super.key,
    required this.song,
    required this.onLikeToggle,
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state == PlayerState.playing);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(widget.song['url']));
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        // blur: 10,
        borderRadius: BorderRadius.circular(16),
        // backdropFilter: const BackdropFilter.blur(10),
      ),
      child: Column(
        children: [
          // Song Info
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.song['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.song['artist'],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: widget.onLikeToggle,
                child: Icon(
                  widget.song['liked'] ? Icons.favorite : Icons.favorite_border,
                  color: widget.song['liked'] ? Colors.red : Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          Column(
            children: [
              Slider(
                value: _duration.inSeconds > 0 
                    ? _position.inSeconds / _duration.inSeconds 
                    : 0,
                onChanged: (value) async {
                  final position = Duration(
                    seconds: (value * _duration.inSeconds).round(),
                  );
                  await _audioPlayer.seek(position);
                },
                activeColor: Colors.white,
                inactiveColor: Colors.white.withOpacity(0.3),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _formatDuration(_duration),
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
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  final newPosition = _position - const Duration(seconds: 10);
                  await _audioPlayer.seek(
                    newPosition > Duration.zero ? newPosition : Duration.zero,
                  );
                },
                icon: const Icon(
                  Icons.replay_10,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: _playPause,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                onPressed: () async {
                  final newPosition = _position + const Duration(seconds: 10);
                  await _audioPlayer.seek(
                    newPosition < _duration ? newPosition : _duration,
                  );
                },
                icon: const Icon(
                  Icons.forward_10,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}