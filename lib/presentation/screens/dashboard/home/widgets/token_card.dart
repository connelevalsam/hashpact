/*
* Created by Connel Asikong on 01/05/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../../core/models/token_info.dart';
import '../../../../../core/util/hashpact_theme.dart';

class TokenCard extends StatelessWidget {
  const TokenCard({
    super.key,
    required this.token,
    required this.balance,
    required this.privacyMode,
  });

  final TokenInfo token;
  final BigInt balance;
  final bool privacyMode;

  String get _formatted {
    if (privacyMode) return '••••••';
    final divisor = BigInt.from(10).pow(token.decimals);
    final whole = balance ~/ divisor;
    final frac = (balance % divisor)
        .toString()
        .padLeft(token.decimals, '0')
        .substring(0, 4);
    return '$whole.$frac ${token.symbol}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.md,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: token.bgColor,
              border: Border.all(color: token.color.withValues(alpha: 0.3)),
            ),
            child: Center(
              child: Text(token.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  token.isSui ? 'SUI Testnet' : 'Bitcoin Testnet',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatted,
                style: AppTextStyles.mono.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              Text(
                '\$0.00',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
