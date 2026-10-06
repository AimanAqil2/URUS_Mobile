import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/router/route_names.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_radius.dart';
import '../../../../design_system/tokens/app_spacing.dart';

/// Visual-only application entry point.
/// Startup verification will be added later with authentication infrastructure.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _entranceDuration = Duration(seconds: 5);

  late final AnimationController _controller;
  Timer? _temporaryLoginTimer;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotation;
  late final Animation<double> _wordmarkScale;

  late final Animation<double> _symbolDraw;
  late final Animation<double> _containerReveal;
  late final Animation<double> _assetReveal;
  late final Animation<double> _wordmarkReveal;
  late final Animation<double> _planReveal;
  late final Animation<double> _actReveal;
  late final Animation<double> _achieveReveal;
  late final Animation<double> _periodEmphasis;
  late final Animation<double> _statusReveal;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _entranceDuration)
      ..forward();

    // Temporary development flow. Replace with token/session resolution when
    // authentication infrastructure is introduced.
    _temporaryLoginTimer = Timer(
      const Duration(seconds: 5),
      _openLoginForDevelopment,
    );

    // Logo entrance
    _logoScale = _interval(0.0, 0.25, Curves.elasticOut);

    _logoRotation = Tween<double>(
      begin: -2.0,
      end: 0.0,
    ).animate(_interval(0.0, 0.25, Curves.easeOutBack));

    _containerReveal = _interval(0.05, 0.20, Curves.easeOut);

    _symbolDraw = _interval(0.15, 0.35, Curves.easeInOutCubic);

    _assetReveal = _interval(0.30, 0.40, Curves.easeOut);

    // URUS wordmark entrance
    _wordmarkReveal = _interval(0.35, 0.45, Curves.easeOut);

    _wordmarkScale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(_interval(0.35, 0.50, Curves.elasticOut));

    // PLAN → ACT → ACHIEVE
    _planReveal = _interval(0.45, 0.52, Curves.easeOutBack);

    _actReveal = _interval(0.52, 0.59, Curves.easeOutBack);

    _achieveReveal = _interval(0.59, 0.66, Curves.easeOutBack);

    // Green final-period emphasis
    _periodEmphasis = Tween<double>(
      begin: 1.0,
      end: 1.8,
    ).animate(_interval(0.66, 0.75, Curves.elasticOut));

    // Loader appears after branding
    _statusReveal = _interval(0.72, 0.88, Curves.easeOutCubic);
  }

  Animation<double> _interval(double begin, double end, Curve curve) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end, curve: curve),
    );
  }

  void _openLoginForDevelopment() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement<void, void>(
      PageRouteBuilder<void>(
        settings: const RouteSettings(name: RouteNames.login),
        transitionDuration: const Duration(milliseconds: 360),
        reverseTransitionDuration: const Duration(milliseconds: 360),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curve,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, .025),
                end: Offset.zero,
              ).animate(curve),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _temporaryLoginTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final logoSize = (size.width * 0.30).clamp(100.0, 120.0).toDouble();

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.18),
            radius: 1.2,
            colors: [Color(0x33D9F99D), AppColors.canvas],
            stops: [0.02, 1],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                const Spacer(flex: 6),

                _BrandLockup(
                  logoSize: logoSize,
                  logoScale: _logoScale,
                  logoRotation: _logoRotation,
                  wordmarkScale: _wordmarkScale,
                  symbolDraw: _symbolDraw,
                  containerReveal: _containerReveal,
                  assetReveal: _assetReveal,
                  wordmarkReveal: _wordmarkReveal,
                  planReveal: _planReveal,
                  actReveal: _actReveal,
                  achieveReveal: _achieveReveal,
                  periodEmphasis: _periodEmphasis,
                ),

                const Spacer(flex: 4),

                FadeTransition(
                  opacity: _statusReveal,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.25),
                      end: Offset.zero,
                    ).animate(_statusReveal),
                    child: const _StartupStatus(),
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup({
    required this.logoSize,
    required this.logoScale,
    required this.logoRotation,
    required this.wordmarkScale,
    required this.symbolDraw,
    required this.containerReveal,
    required this.assetReveal,
    required this.wordmarkReveal,
    required this.planReveal,
    required this.actReveal,
    required this.achieveReveal,
    required this.periodEmphasis,
  });

  final double logoSize;

  final Animation<double> logoScale;
  final Animation<double> logoRotation;
  final Animation<double> wordmarkScale;

  final Animation<double> symbolDraw;
  final Animation<double> containerReveal;
  final Animation<double> assetReveal;
  final Animation<double> wordmarkReveal;

  final Animation<double> planReveal;
  final Animation<double> actReveal;
  final Animation<double> achieveReveal;
  final Animation<double> periodEmphasis;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _UrusLogo(
          size: logoSize,
          scaleReveal: logoScale,
          rotationReveal: logoRotation,
          symbolDraw: symbolDraw,
          containerReveal: containerReveal,
          assetReveal: assetReveal,
        ),

        const SizedBox(height: AppSpacing.xl),

        FadeTransition(
          opacity: wordmarkReveal,
          child: ScaleTransition(
            scale: wordmarkScale,
            child: Text(
              'URUS',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: AppColors.primary,
                shadows: [
                  Shadow(
                    color: AppColors.primary.withValues(alpha: 0.30),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        _Tagline(
          planReveal: planReveal,
          actReveal: actReveal,
          achieveReveal: achieveReveal,
          periodEmphasis: periodEmphasis,
        ),

        const SizedBox(height: AppSpacing.md),

        FadeTransition(
          opacity: achieveReveal,
          child: ScaleTransition(
            scale: achieveReveal,
            child: Container(
              width: 48,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: AppRadius.chip,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.50),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Tagline extends StatelessWidget {
  const _Tagline({
    required this.planReveal,
    required this.actReveal,
    required this.achieveReveal,
    required this.periodEmphasis,
  });

  final Animation<double> planReveal;
  final Animation<double> actReveal;
  final Animation<double> achieveReveal;
  final Animation<double> periodEmphasis;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: const Color(0xFF3D6900),
      fontWeight: FontWeight.w800,
      letterSpacing: 2,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TaglineWord(text: 'PLAN.', opacity: planReveal, style: style),

        const SizedBox(width: 12),

        _TaglineWord(text: 'ACT.', opacity: actReveal, style: style),

        const SizedBox(width: 12),

        FadeTransition(
          opacity: achieveReveal,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-0.2, 0),
              end: Offset.zero,
            ).animate(achieveReveal),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ACHIEVE', style: style),
                ScaleTransition(
                  scale: periodEmphasis,
                  child: Text(
                    '.',
                    style: style?.copyWith(
                      color: AppColors.primary,
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TaglineWord extends StatelessWidget {
  const _TaglineWord({
    required this.text,
    required this.opacity,
    required this.style,
  });

  final String text;
  final Animation<double> opacity;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacity,
      child: ScaleTransition(
        scale: opacity,
        child: Text(text, style: style),
      ),
    );
  }
}

class _UrusLogo extends StatelessWidget {
  const _UrusLogo({
    required this.size,
    required this.scaleReveal,
    required this.rotationReveal,
    required this.symbolDraw,
    required this.containerReveal,
    required this.assetReveal,
  });

  final double size;

  final Animation<double> scaleReveal;
  final Animation<double> rotationReveal;
  final Animation<double> symbolDraw;
  final Animation<double> containerReveal;
  final Animation<double> assetReveal;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.30);

    return AnimatedBuilder(
      animation: Listenable.merge([
        containerReveal,
        assetReveal,
        symbolDraw,
        scaleReveal,
        rotationReveal,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: scaleReveal.value,
          child: Transform.rotate(
            angle: rotationReveal.value * math.pi,
            child: Opacity(
              opacity: containerReveal.value.clamp(0.0, 1.0),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: radius,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.40),
                      blurRadius: 20 * scaleReveal.value,
                      spreadRadius: 5 * scaleReveal.value,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: radius,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Opacity(
                        opacity: assetReveal.value,
                        child: Image.asset(
                          'assets/images/urus_icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      Opacity(
                        opacity: 1 - assetReveal.value.clamp(0.0, 1.0),
                        child: CustomPaint(
                          painter: _CompletionMarkPainter(symbolDraw.value),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CompletionMarkPainter extends CustomPainter {
  const _CompletionMarkPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final mark = Path()
      ..moveTo(size.width * 0.24, size.height * 0.21)
      ..lineTo(size.width * 0.24, size.height * 0.57)
      ..cubicTo(
        size.width * 0.24,
        size.height * 0.91,
        size.width * 0.76,
        size.height * 0.91,
        size.width * 0.76,
        size.height * 0.57,
      )
      ..lineTo(size.width * 0.76, size.height * 0.21)
      ..moveTo(size.width * 0.39, size.height * 0.56)
      ..lineTo(size.width * 0.50, size.height * 0.67)
      ..lineTo(size.width * 0.67, size.height * 0.47);

    final metrics = mark.computeMetrics().toList();

    final totalLength = metrics.fold<double>(
      0,
      (sum, metric) => sum + metric.length,
    );

    var remainingLength = totalLength * progress;

    final revealedPath = Path();

    for (final metric in metrics) {
      final length = remainingLength.clamp(0.0, metric.length).toDouble();

      if (length > 0) {
        revealedPath.addPath(metric.extractPath(0, length), Offset.zero);
      }

      remainingLength -= metric.length;
    }

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(revealedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _CompletionMarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Animated three-dot loader.
///
/// This keeps the existing URUS green loading animation while removing
/// all startup/status copy from the Splash Screen.
class _StartupStatus extends StatefulWidget {
  const _StartupStatus();

  @override
  State<_StartupStatus> createState() => _StartupStatusState();
}

class _StartupStatusState extends State<_StartupStatus>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loadingController;

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _loadingController,
            builder: (context, child) {
              final double t =
                  (_loadingController.value + (index * 0.20)) % 1.0;

              final double bounce = math.sin(t * math.pi);

              final double dy = -20 * bounce;

              final double scaleY = 1.0 + (bounce * 0.35);

              final double scaleX = 1.0 - (bounce * 0.12);

              return Transform.translate(
                offset: Offset(0, dy),
                child: Transform.scale(
                  scaleX: scaleX,
                  scaleY: scaleY,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(
                            alpha: 0.55 * bounce,
                          ),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
