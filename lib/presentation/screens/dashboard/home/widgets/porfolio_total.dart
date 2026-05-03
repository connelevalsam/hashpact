/*
* Created by Connel Asikong on 01/05/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/util/hashpact_theme.dart';

class PortfolioTotal extends StatelessWidget {
  const PortfolioTotal({
    super.key,
    required this.balanceAsync,
    required this.privacyMode,
  });

  final AsyncValue<Map<String, BigInt>> balanceAsync;
  final bool privacyMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TOTAL BALANCE',
          style: AppTextStyles.label.copyWith(
            color: AppColors.textMuted,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        balanceAsync.when(
          loading: () => Container(
            width: 160,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: AppRadius.sm,
            ),
          ),
          error: (_, __) => Text(
            '—',
            style: AppTextStyles.monoLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          data: (_) => Text(
            privacyMode ? '••••••' : '\$0.00',
            style: AppTextStyles.monoLarge.copyWith(fontSize: 36),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Testnet • prices not live',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
