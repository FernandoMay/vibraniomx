import 'package:flutter/material.dart';
import 'package:vibraniomx/theme.dart';

class ControlBar extends StatelessWidget {
  final VoidCallback onSongsPressed;
  final VoidCallback onBreathePressed;
  final VoidCallback onProfilePressed;

  const ControlBar({
    super.key,
    required this.onSongsPressed,
    required this.onBreathePressed,
    required this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlItem(
            icon: Icons.music_note,
            label: 'Songs',
            onTap: onSongsPressed,
          ),
          _buildControlItem(
            icon: Icons.air,
            label: 'Breathe',
            onTap: onBreathePressed,
          ),
          _buildControlItem(
            icon: Icons.person,
            label: 'Profile',
            onTap: onProfilePressed,
          ),
        ],
      ),
    );
  }

  Widget _buildControlItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
