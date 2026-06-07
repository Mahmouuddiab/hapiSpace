import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:habiSpace/core/constant/secure_storage.dart';
import 'package:habiSpace/core/router/app_router.dart';
import 'package:habiSpace/core/utils/app_color.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _logoScale;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final storage = AuthStorage();
    final token = storage.token;

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      context.go(AppRoutes.onBoarding);
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = Tween<double>(begin: .85, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutExpo),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(begin: const Offset(0, .15), end: Offset.zero)
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutExpo,
      ),
    );

    _animationController.forward();

    _navigate();

  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      body: Stack(
        children: [
          /// Elegant Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF081417),
                  Color(0xFF0D1F23),
                  Color(0xFF122C31),
                ],
              ),
            ),
          ),

          /// Decorative Lines
          Positioned.fill(child: CustomPaint(painter: _BackgroundPainter())),

          /// Main Content
          Center(
            child: FadeTransition(
              opacity: _opacity,
              child: SlideTransition(
                position: _slide,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Logo Container
                    ScaleTransition(
                      scale: _logoScale,
                      child: Container(
                        width: 220,
                        height: 110,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white.withOpacity(.04),
                          border: Border.all(
                            color: Colors.white.withOpacity(.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.25),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          'assets/images/logo2.svg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    Text(
                      'Find your perfect space',
                      style: TextStyle(
                        color: Colors.white.withOpacity(.55),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Bottom Loading Indicator
          Positioned(
            bottom: 70,
            left: 40,
            right: 40,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    value: value,
                    backgroundColor: Colors.white.withOpacity(.06),
                    valueColor: const AlwaysStoppedAnimation(AppColors.blue),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.03)
      ..strokeWidth = 1;

    for (double i = -size.height; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}