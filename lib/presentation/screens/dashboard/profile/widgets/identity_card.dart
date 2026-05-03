/*
* Created by Connel Asikong on 02/05/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/util/hashpact_theme.dart';

class IdentityCard extends StatelessWidget {
  const IdentityCard({
    super.key,
    required this.dummyNpub,
    required this.dummySuiAddress,
    required this.dummyAuthType,
  });

  final String dummyNpub;
  final String dummySuiAddress;
  final String dummyAuthType;

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
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: Center(
              child: Text(
                'H',
                style: AppTextStyles.heading2.copyWith(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Auth type badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryDim,
              borderRadius: AppRadius.full,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              dummyAuthType,
              style: AppTextStyles.label.copyWith(
                color: AppColors.primary,
                fontSize: 10,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.md),

          // Nostr key
          _keyRow(
            context: context,
            label: 'Nostr public key',
            value: dummyNpub,
            icon: HugeIcons.strokeRoundedKey01,
          ),

          const SizedBox(height: AppSpacing.md),

          // SUI address
          _keyRow(
            context: context,
            label: 'SUI address',
            value: dummySuiAddress,
            icon: HugeIcons.strokeRoundedWallet01,
          ),
        ],
      ),
    );
  }

  Widget _keyRow({
    required BuildContext context,
    required String label,
    required value,
    required icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HugeIcon(icon: icon, color: AppColors.textMuted, size: 16),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.mono.copyWith(fontSize: 12)),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Copied',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.surfaceHigh,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedCopy01,
            color: AppColors.textMuted,
            size: 16,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
