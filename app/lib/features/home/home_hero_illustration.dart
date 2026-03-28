import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class HomeHeroIllustration extends StatefulWidget {
  const HomeHeroIllustration({super.key});

  @override
  State<HomeHeroIllustration> createState() => _HomeHeroIllustrationState();
}

class _HomeHeroIllustrationState extends State<HomeHeroIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.35,
      child: AnimatedBuilder(
        animation: _floatAnim,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: _MountainBookPainter(floatOffset: _floatAnim.value),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  bottom: 28 + _floatAnim.value,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.primaryDeep.withValues(alpha: 0.6),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MountainBookPainter extends CustomPainter {
  _MountainBookPainter({required this.floatOffset});

  final double floatOffset;

  @override
  void paint(Canvas canvas, Size size) {
    // Playful, brighter mountains
    final Paint leftColor = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          const Color(0xFF4AC29A),
          const Color(0xFF27AE60),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width * 0.6, size.height));

    final Paint rightColor = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          const Color(0xFF56CCF2),
          const Color(0xFF2F80ED),
        ],
      ).createShader(Rect.fromLTWH(size.width * 0.4, 0, size.width * 0.6, size.height));

    final Path leftPeak = Path()
      ..moveTo(0, size.height * 0.72)
      ..lineTo(size.width * 0.25, size.height * 0.25)
      ..lineTo(size.width * 0.55, size.height * 0.8)
      ..close();

    final Path rightPeak = Path()
      ..moveTo(size.width * 0.35, size.height * 0.85)
      ..lineTo(size.width * 0.65, size.height * 0.2)
      ..lineTo(size.width, size.height * 0.7)
      ..close();

    // Add a sun
    final Paint sunColor = Paint()
      ..color = const Color(0xFFFFD700)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 10);
      
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.25 + (floatOffset * 0.5)), 
      size.width * 0.12, 
      sunColor
    );

    canvas.drawPath(leftPeak, leftColor);
    canvas.drawPath(rightPeak, rightColor);

    // Fluffy clouds at the bottom
    final Paint cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.85), size.width * 0.15, cloudPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.9), size.width * 0.2, cloudPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.82), size.width * 0.18, cloudPaint);
  }

  @override
  bool shouldRepaint(covariant _MountainBookPainter oldDelegate) {
    return oldDelegate.floatOffset != floatOffset;
  }
}
