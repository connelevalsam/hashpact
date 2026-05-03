/*
* Created by Connel Asikong on 01/05/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/util/hashpact_theme.dart';

class OAuthButtonWidget extends StatelessWidget {
  final String label;
  final List<List<dynamic>> icon;
  final bool loading;
  final VoidCallback onTap;

  const OAuthButtonWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: loading ? null : onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: AppColors.border),
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.md),
      ),
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HugeIcon(icon: icon, color: AppColors.textPrimary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(label, style: AppTextStyles.buttonText),
              ],
            ),
    );
  }
}
