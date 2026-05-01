/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../../core/providers/identity_provider.dart';
import '../../core/storage/local_storage.dart';
import '../../core/util/hashpact_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) _navigate();
    });
  }

  Future<void> _beginSplashSequence() async {
    // Run both simultaneously — animation timer AND identity check
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 2500)), // minimum display
      ref.read(identityProvider.future), // wait for storage restore
    ]);

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) _navigate();
    });
  }

  /*Future<void> _navigate() async {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    final identity = ref.read(identityProvider).value;

    if (identity != null) {
      // Returning user — skip everything, go to dashboard
      // Later: go to PIN lock instead
      context.go(AppRoutes.dashboard);
      return;
    }

    // Check if they've seen onboarding before
    final hasSeenOnboarding = await PrefStore.instance.readHasSeenOnboarding();

    if (hasSeenOnboarding) {
      // They set up before but wiped — skip onboarding, go to welcome
      context.go(AppRoutes.welcome);
    } else {
      // Truly first launch
      context.go(AppRoutes.onboarding);
    }
  }*/

  void _navigate() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final identity = ref.read(identityProvider).value;

    if (identity != null) {
      context.go(AppRoutes.dashboard);
      return;
    }

    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final hasSeenOnboarding = await PrefStore.instance.readHasSeenOnboarding();
    if (!mounted) return;

    if (hasSeenOnboarding) {
      context.go(AppRoutes.welcome);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Wave background ──────────────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (_, __) => CustomPaint(
                painter: _WavePainter(progress: _waveController.value),
              ),
            ),
          ),

          // ── Radial glow behind logo ──────────────────────────
          Positioned(
            top: size.height * 0.28,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.18),
                      AppColors.primary.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ── Logo + wordmark ──────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: size.height * 0.04),

                // Logo mark — the H inside a rounded square
                Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.lg,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 32,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'H',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                    .scale(
                      begin: const Offset(0.7, 0.7),
                      end: const Offset(1.0, 1.0),
                      duration: 700.ms,
                      curve: Curves.easeOutBack,
                    ),

                const SizedBox(height: 20),

                // Wordmark
                Text(
                      'Hashpact',
                      style: AppTextStyles.heading1.copyWith(
                        fontSize: 34,
                        letterSpacing: -0.5,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 600.ms)
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      delay: 300.ms,
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 10),

                // Tagline
                Text(
                  'Trustless swaps. No middlemen.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    letterSpacing: 0.2,
                  ),
                ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
              ],
            ),
          ),

          // ── Loading indicator at bottom ──────────────────────
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
              ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WAVE PAINTER
// ─────────────────────────────────────────────────────────────
// Draws three layered sine waves from the bottom of the screen.
// progress (0.0 → 1.0) comes from the AnimationController loop
// and shifts the wave phase horizontally — creating motion.
//
// Each wave has:
//   - a different amplitude (height of the peaks)
//   - a different frequency (how many peaks across the screen)
//   - a different speed multiplier (so they don't move in sync)
//   - a different opacity (depth illusion)

class _WavePainter extends CustomPainter {
  const _WavePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    _drawWave(
      canvas,
      size,
      phaseShift: progress * 2 * math.pi,
      amplitude: 55,
      frequency: 1.4,
      yBase: size.height * 0.72,
      color: AppColors.primary.withValues(alpha: 0.07),
    );

    _drawWave(
      canvas,
      size,
      phaseShift: progress * 2 * math.pi * 1.3 + math.pi * 0.5,
      amplitude: 40,
      frequency: 1.8,
      yBase: size.height * 0.78,
      color: AppColors.primary.withValues(alpha: 0.09),
    );

    _drawWave(
      canvas,
      size,
      phaseShift: progress * 2 * math.pi * 0.8 + math.pi,
      amplitude: 28,
      frequency: 2.2,
      yBase: size.height * 0.84,
      color: AppColors.accent.withValues(alpha: 0.06),
    );
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required double phaseShift,
    required double amplitude,
    required double frequency,
    required double yBase,
    required Color color,
  }) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    // Walk across the width plotting sine points
    for (double x = 0; x <= size.width; x++) {
      final y =
          yBase +
          amplitude *
              math.sin((x / size.width) * frequency * 2 * math.pi + phaseShift);
      path.lineTo(x, y);
    }

    // Close the path down to the bottom corners
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.progress != progress;
}
