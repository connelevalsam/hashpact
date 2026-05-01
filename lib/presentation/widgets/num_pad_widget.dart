/*
* Created by Connel Asikong on 30/04/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/util/hashpact_theme.dart';

class NumPadWidget extends StatelessWidget {
  final ValueChanged<int> onDigit;
  final VoidCallback onDelete;

  const NumPadWidget({
    super.key,
    required this.onDigit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow([1, 2, 3]),
        const SizedBox(height: AppSpacing.sm),
        _buildRow([4, 5, 6]),
        const SizedBox(height: AppSpacing.sm),
        _buildRow([7, 8, 9]),
        const SizedBox(height: AppSpacing.sm),
        // Bottom row: empty, 0, delete
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80, height: 80), // spacer
            _DigitKey(digit: 0, onTap: onDigit),
            SizedBox(
              width: 80,
              height: 80,
              child: TextButton(
                onPressed: onDelete,
                style: TextButton.styleFrom(shape: const CircleBorder()),
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedDelete01,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<int> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) => _DigitKey(digit: d, onTap: onDigit)).toList(),
    );
  }
}

class _DigitKey extends StatelessWidget {
  const _DigitKey({required this.digit, required this.onTap});

  final int digit;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: TextButton(
        onPressed: () => onTap(digit),
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
        ),
        child: Text(
          '$digit',
          style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
