import 'package:flutter/material.dart';
import 'package:vibraniomx/theme.dart';
class YinYangWidget extends StatefulWidget {
  final double size;
  final bool interactive;
  final Function(bool isYin)? onTap;

  const YinYangWidget({
    super.key,
    this.size = 200,
    this.interactive = true,
    this.onTap,
  });

  @override
  State<YinYangWidget> createState() => _YinYangWidgetState();
}

class _YinYangWidgetState extends State<YinYangWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  
  String _hoveredSide = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.interactive) {
      _rotationController = AnimationController(
        duration: const Duration(seconds: 20),
        vsync: this,
      );
      
      _rotationAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(_rotationController);
      
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    if (widget.interactive) {
      _rotationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.interactive) {
      return _buildStaticYinYang();
    }

    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2 * 3.141592653589793,
          child: _buildInteractiveYinYang(),
        );
      },
    );
  }

  Widget _buildStaticYinYang() {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: YinYangPainter(
        hoveredSide: '',
        interactive: false,
      ),
    );
  }

  Widget _buildInteractiveYinYang() {
    return GestureDetector(
      onTapUp: (details) {
        if (!widget.interactive || widget.onTap == null) return;
        
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        final center = Offset(widget.size / 2, widget.size / 2);
        final isLeftSide = localPosition.dx < center.dx;
        
        widget.onTap!(isLeftSide); // Left = Yin (Listener), Right = Yang (Artist)
      },
      child: MouseRegion(
        onHover: (event) {
          if (!widget.interactive) return;
          
          final RenderBox box = context.findRenderObject() as RenderBox;
          final localPosition = box.globalToLocal(event.position);
          final center = Offset(widget.size / 2, widget.size / 2);
          final newHoveredSide = localPosition.dx < center.dx ? 'yin' : 'yang';
          
          if (newHoveredSide != _hoveredSide) {
            setState(() {
              _hoveredSide = newHoveredSide;
            });
          }
        },
        onExit: (event) {
          if (_hoveredSide.isNotEmpty) {
            setState(() {
              _hoveredSide = '';
            });
          }
        },
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: YinYangPainter(
            hoveredSide: _hoveredSide,
            interactive: widget.interactive,
          ),
        ),
      ),
    );
  }
}

class YinYangPainter extends CustomPainter {
  final String hoveredSide;
  final bool interactive;

  YinYangPainter({
    required this.hoveredSide,
    required this.interactive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Main circle background
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, backgroundPaint);

    // Border
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, radius, borderPaint);

    // Yin (left, black) half
    final yinPaint = Paint()
      ..color = hoveredSide == 'yin' ? AppTheme.secondary : Colors.black
      ..style = PaintingStyle.fill;

    final yinPath = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        3.141592653589793 / 2,
        3.141592653589793,
      )
      ..addArc(
        Rect.fromCircle(
          center: Offset(center.dx, center.dy - radius / 2),
          radius: radius / 2,
        ),
        3.141592653589793 / 2,
        3.141592653589793,
      )
      ..addArc(
        Rect.fromCircle(
          center: Offset(center.dx, center.dy + radius / 2),
          radius: radius / 2,
        ),
        3.141592653589793 / 2,
        -3.141592653589793,
      );
    
    canvas.drawPath(yinPath, yinPaint);

    // Yang (right, white) dot
    final yangDotPaint = Paint()
      ..color = hoveredSide == 'yang' ? AppTheme.accent : Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(center.dx, center.dy - radius / 2),
      radius / 6,
      yangDotPaint,
    );

    // Yin (left, black) dot
    final yinDotPaint = Paint()
      ..color = hoveredSide == 'yin' ? AppTheme.secondary : Colors.black
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(center.dx, center.dy + radius / 2),
      radius / 6,
      yinDotPaint,
    );

    // Interactive glow effect
    if (interactive && hoveredSide.isNotEmpty) {
      final glowPaint = Paint()
        ..color = (hoveredSide == 'yin' ? AppTheme.secondary : AppTheme.accent)
            .withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);
      
      canvas.drawCircle(center, radius, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is YinYangPainter &&
        (oldDelegate.hoveredSide != hoveredSide ||
         oldDelegate.interactive != interactive);
  }
}