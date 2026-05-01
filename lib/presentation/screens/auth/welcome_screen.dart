/*
* Created by Connel Asikong on 29/04/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../app.dart';
import '../../../core/util/hashpact_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Logo
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.lg,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.accent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'H',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              'Get started',
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              'Choose how you want to secure your account.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            FilledButton(
                  onPressed: () => context.push(AppRoutes.seedGenerate),
                  child: const Text('Create with seed phrase'),
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .slideY(
                  begin: 0.2,
                  end: 0,
                  delay: 200.ms,
                  duration: 400.ms,
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: AppSpacing.sm),

            OutlinedButton(
                  onPressed: () => context.push(AppRoutes.zkLogin),
                  child: const Text('Continue with Google / Apple'),
                )
                .animate()
                .fadeIn(delay: 350.ms, duration: 400.ms)
                .slideY(
                  begin: 0.2,
                  end: 0,
                  delay: 350.ms,
                  duration: 400.ms,
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
