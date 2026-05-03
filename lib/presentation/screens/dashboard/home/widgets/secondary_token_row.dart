/*
* Created by Connel Asikong on 01/05/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../../core/models/token_info.dart';
import '../../../../../core/util/hashpact_theme.dart';

class SecondaryTokenRow extends StatelessWidget {
  const SecondaryTokenRow({
    super.key,
    required this.balances,
    required this.privacyMode,
  });

  final Map<String, BigInt> balances;
  final bool privacyMode;

  @override
  Widget build(BuildContext context) {
    final tokens = [TokenRegistry.usdc, TokenRegistry.usdt];
    return Row(
      children: tokens.asMap().entries.map((e) {
        final i = e.key;
        final token = e.value;
        final balance = balances[token.id] ?? BigInt.zero;
        final divisor = BigInt.from(10).pow(token.decimals);
        final formatted = privacyMode
            ? '••••'
            : '${balance ~/ divisor} ${token.symbol}';

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i == 0 ? AppSpacing.sm : 0),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.md,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Text(token.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        token.symbol,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        formatted,
                        style: AppTextStyles.mono.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
