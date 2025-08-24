import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String text;
  final ButtonStyle? style;
final LinearGradient? gradient;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.text,
    this.style, this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
            ? Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
              ),
              child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onPrimary,
              ),
              ),
            )
          : Text(text),
    );
  }
}