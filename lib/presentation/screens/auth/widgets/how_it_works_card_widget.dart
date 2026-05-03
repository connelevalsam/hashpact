/*
* Created by Connel Asikong on 01/05/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../core/util/hashpact_theme.dart';

class HowItWorksCardWidget extends StatelessWidget {
  const HowItWorksCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.md,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How zkLogin works',
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _step(number: '1', text: 'You sign in with Google or Apple.'),
          const SizedBox(height: AppSpacing.sm),
          _step(
            number: '2',
            text:
                'A zero-knowledge proof links your login to a SUI address — without revealing your identity on-chain.',
          ),
          const SizedBox(height: AppSpacing.sm),
          _step(
            number: '3',
            text:
                'That SUI address is yours. Only you can sign transactions with it.',
          ),
        ],
      ),
    );
  }

  Widget _step({required String number, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryDim,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
          ),
          child: Center(
            child: Text(
              number,
              style: AppTextStyles.label.copyWith(
                color: AppColors.primary,
                fontSize: 11,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
      ],
    );
  }
}
