/*
* Created by Connel Asikong on 29/04/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/util/hashpact_theme.dart';

class StatusBannerWidget extends StatelessWidget {
  final bool correct;

  const StatusBannerWidget({super.key, required this.correct});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: correct
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.danger.withValues(alpha: 0.1),
        borderRadius: AppRadius.md,
        border: Border.all(
          color: correct
              ? AppColors.success.withValues(alpha: 0.4)
              : AppColors.danger.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          HugeIcon(
            icon: correct
                ? HugeIcons.strokeRoundedCheckmarkCircle01
                : HugeIcons.strokeRoundedAlert02,
            color: correct ? AppColors.success : AppColors.danger,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            correct
                ? 'Perfect. Your phrase is confirmed.'
                : 'Some words are wrong. Tap them to remove and try again.',
            style: AppTextStyles.bodySmall.copyWith(
              color: correct ? AppColors.success : AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }
}
