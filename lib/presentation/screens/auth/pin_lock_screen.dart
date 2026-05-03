/*
* Created by Connel Asikong on 02/05/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hashpact/presentation/screens/auth/widgets/pin_dots_widget.dart';
import 'package:hashpact/presentation/widgets/num_pad_widget.dart';

import '../../../app.dart';
import '../../../core/util/hashpact_theme.dart';

class PinLockScreen extends ConsumerStatefulWidget {
  const PinLockScreen({super.key});

  @override
  ConsumerState createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<PinLockScreen> {
  List<int> _pin = [];
  bool _loading = false;
  bool _hasError = false;
  int _attempts = 0;

  static const _pinLength = 6;
  static const _maxAttempts = 5;

  void _onKeyTap(int digit) {
    if (_pin.length >= _pinLength || _loading) return;
    setState(() {
      _pin.add(digit);
      _hasError = false;
    });

    if (_pin.length == _pinLength) {
      Future.delayed(const Duration(milliseconds: 200), _verify);
    }
  }

  void _onDelete() {
    if (_pin.isEmpty || _loading) return;
    setState(() {
      _pin.removeLast();
      _hasError = false;
    });
  }

  Future<void> _verify() async {
    setState(() => _loading = true);

    // TODO: verify via identity provider
    // Simulating check — always passes for now
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    // Dummy: treat '000000' as wrong for demo purposes
    final isCorrect = _pin.join() != '000000';

    if (isCorrect) {
      context.go(AppRoutes.home);
    } else {
      _attempts++;
      setState(() {
        _loading = false;
        _hasError = true;
        _pin = [];
      });
    }
  }

  void _onForgotPin() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.md,
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text('Forgot PIN?', style: AppTextStyles.heading3),
        content: Text(
          'To recover access you\'ll need to restore from '
          'your seed phrase. This will wipe the current '
          'device data.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.seedGenerate);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Restore from seed'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attemptsLeft = _maxAttempts - _attempts;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxl),

              // ── Logo ───────────────────────────────────────
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.md,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.accent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'H',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: AppSpacing.lg),

              // ── Title ──────────────────────────────────────
              Text(
                'Welcome back',
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Enter your PIN to unlock',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.xxl),

              // ── PIN dots ───────────────────────────────────
              PinDotsWidget(
                filled: _pin.length,
                total: _pinLength,
                hasError: _hasError,
                loading: _loading,
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.md),

              // ── Error / attempts left ──────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _hasError
                    ? Column(
                        key: const ValueKey('error'),
                        children: [
                          Text(
                            'Incorrect PIN',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.danger,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (attemptsLeft <= 3)
                            Text(
                              '$attemptsLeft attempt${attemptsLeft == 1 ? '' : 's'} remaining',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.warning,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ).animate().fadeIn(duration: 200.ms).shakeX(duration: 400.ms)
                    : const SizedBox.shrink(key: ValueKey('ok')),
              ),

              const Spacer(),

              // ── Number pad ─────────────────────────────────
              NumPadWidget(
                onDigit: _onKeyTap,
                onDelete: _onDelete,
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.lg),

              // ── Forgot PIN ─────────────────────────────────
              TextButton(
                onPressed: _onForgotPin,
                child: Text(
                  'Forgot PIN?',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
