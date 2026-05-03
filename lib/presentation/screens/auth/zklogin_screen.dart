/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hashpact/presentation/screens/auth/widgets/how_it_works_card_widget.dart';
import 'package:hashpact/presentation/screens/auth/widgets/oauth_button_widget.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../app.dart';
import '../../../core/util/hashpact_theme.dart';

class ZkloginScreen extends ConsumerStatefulWidget {
  const ZkloginScreen({super.key});

  @override
  ConsumerState createState() => _ZkloginScreenState();
}

class _ZkloginScreenState extends ConsumerState<ZkloginScreen> {
  bool _googleLoading = false;
  bool _appleLoading = false;

  Future<void> _onGoogleTap() async {
    setState(() => _googleLoading = true);

    // TODO: wire ZkLoginService.authenticate(OAuthProvider.google)
    // For now simulate a delay then navigate to PIN setup
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _googleLoading = false);

    // zkLogin users also set a PIN to lock the app locally
    context.go(AppRoutes.pinSetup);
  }

  Future<void> _onAppleTap() async {
    setState(() => _appleLoading = true);

    // TODO: wire ZkLoginService.authenticate(OAuthProvider.apple)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _appleLoading = false);

    context.go(AppRoutes.pinSetup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sign in'),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // ── Icon ────────────────────────────────────────
              Center(
                child:
                    Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primaryDim,
                            borderRadius: AppRadius.lg,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Center(
                            child: HugeIcon(
                              icon: HugeIcons.strokeRoundedShieldKey,
                              color: AppColors.primary,
                              size: 40,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          duration: 400.ms,
                          curve: Curves.easeOutBack,
                        ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Title ────────────────────────────────────────
              Text(
                'Sign in with zkLogin',
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Use your Google or Apple account to create a '
                'SUI address. No seed phrase needed — your '
                'social login IS your key.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.xl),

              // ── How it works card ────────────────────────────
              HowItWorksCardWidget().animate().fadeIn(
                delay: 200.ms,
                duration: 400.ms,
              ),

              const Spacer(),

              // ── Google button ────────────────────────────────
              OAuthButtonWidget(
                    label: 'Continue with Google',
                    icon: HugeIcons.strokeRoundedGoogleDrive,
                    loading: _googleLoading,
                    onTap: _onGoogleTap,
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0, delay: 300.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.sm),

              // ── Apple button ─────────────────────────────────
              OAuthButtonWidget(
                    label: 'Continue with Apple',
                    icon: HugeIcons.strokeRoundedApple,
                    loading: _appleLoading,
                    onTap: _onAppleTap,
                  )
                  .animate()
                  .fadeIn(delay: 380.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0, delay: 380.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.md),

              // ── Disclaimer ───────────────────────────────────
              Text(
                'Your login provider never sees your funds or '
                'transactions. zkLogin uses zero-knowledge '
                'proofs to keep your identity private.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 450.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
