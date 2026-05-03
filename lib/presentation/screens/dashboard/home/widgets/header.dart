/*
* Created by Connel Asikong on 01/05/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/util/hashpact_theme.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.npub,
    required this.privacyMode,
    required this.onPrivacyToggle,
    required this.onProfileTap,
  });

  final String npub;
  final bool privacyMode;
  final VoidCallback onPrivacyToggle;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PORTFOLIO',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textMuted,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 2),
              Text('Hashpact', style: AppTextStyles.heading2),
            ],
          ),
        ),
        IconButton(
          onPressed: onPrivacyToggle,
          icon: HugeIcon(
            icon: privacyMode
                ? HugeIcons.strokeRoundedScanEye
                : HugeIcons.strokeRoundedEye,
            color: AppColors.textSecondary,
            size: 22,
          ),
        ),
        GestureDetector(
          onTap: onProfileTap,
          child: Container(
            width: 40,
            height: 40,
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
                style: AppTextStyles.buttonText.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
