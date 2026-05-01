/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hashpact/presentation/widgets/num_pad_widget.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../app.dart';
import '../../../core/providers/identity_provider.dart';
import '../../../core/util/hashpact_theme.dart';

class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  List<int> _pin = [];
  List<int> _confirmPin = [];
  bool _confirming = false;
  bool _loading = false;
  String? _errorMessage;

  static const _pinLength = 6;

  List<int> get _activePin => _confirming ? _confirmPin : _pin;

  void _onKeyTap(int digit) {
    if (_activePin.length >= _pinLength) return;
    setState(() {
      _confirming ? _confirmPin.add(digit) : _pin.add(digit);
      _errorMessage = null;
    });

    // Auto-advance when PIN is complete
    if (_activePin.length == _pinLength) {
      if (!_confirming) {
        // Move to confirm stage
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) setState(() => _confirming = true);
        });
      } else {
        // Both PINs entered — validate
        Future.delayed(const Duration(milliseconds: 200), _validate);
      }
    }
  }

  void _onDelete() {
    if (_activePin.isEmpty) return;
    setState(() {
      _confirming ? _confirmPin.removeLast() : _pin.removeLast();
      _errorMessage = null;
    });
  }

  void _onClear() {
    setState(() {
      _pin = [];
      _confirmPin = [];
      _confirming = false;
      _errorMessage = null;
    });
  }

  Future<void> _validate() async {
    if (_pin.join() != _confirmPin.join()) {
      setState(() {
        _errorMessage = 'PINs don\'t match. Try again.';
        _confirmPin = [];
      });
      return;
    }

    setState(() => _loading = true);

    try {
      final pinString = _pin.join();
      await ref.read(identityProvider.notifier).setupPin(pinString);
      if (!mounted) return;
      context.go(AppRoutes.dashboard);
    } catch (e) {
      debugPrint('PIN ERROR: $e');
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Something went wrong. Try again.';
        _loading = false;
        _pin = [];
        _confirmPin = [];
        _confirming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_confirming ? 'Confirm PIN' : 'Set a PIN'),
        leading: _confirming
            ? IconButton(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowLeft01,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
                onPressed: _onClear,
              )
            : null,
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : Padding(
                padding: AppSpacing.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.xl),

                    // ── Title + subtitle ───────────────────────
                    Text(
                      _confirming
                          ? 'Enter your PIN again'
                          : 'Choose a 6-digit PIN',
                      style: AppTextStyles.heading2,
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 300.ms),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      _confirming
                          ? 'Make sure it matches what you entered.'
                          : 'This protects your keys if someone gets\naccess to your device.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 100.ms, duration: 300.ms),

                    const SizedBox(height: AppSpacing.xxl),

                    // ── PIN dots ───────────────────────────────
                    _pinDots(
                          _activePin.length,
                          _pinLength,
                          _errorMessage != null,
                        )
                        .animate(key: ValueKey(_confirming))
                        .fadeIn(duration: 300.ms)
                        .slideX(
                          begin: _confirming ? 0.1 : 0,
                          end: 0,
                          duration: 300.ms,
                          curve: Curves.easeOut,
                        ),

                    const SizedBox(height: AppSpacing.md),

                    // ── Error message ──────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _errorMessage != null
                          ? Text(
                                  _errorMessage!,
                                  key: const ValueKey('error'),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.danger,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                                .animate()
                                .fadeIn(duration: 200.ms)
                                .shakeX(duration: 400.ms)
                          : const SizedBox.shrink(key: ValueKey('no-error')),
                    ),

                    const Spacer(),

                    // ── Number pad ─────────────────────────────
                    NumPadWidget(
                      onDigit: _onKeyTap,
                      onDelete: _onDelete,
                    ).animate().fadeIn(delay: 200.ms, duration: 300.ms),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _pinDots(int filled, int total, bool hasError) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isFilled = i < filled;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? hasError
                      ? AppColors.danger
                      : AppColors.primary
                : Colors.transparent,
            border: Border.all(
              color: isFilled
                  ? hasError
                        ? AppColors.danger
                        : AppColors.primary
                  : AppColors.border,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}
