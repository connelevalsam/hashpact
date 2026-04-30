/*
* Created by Connel Asikong on 29/04/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../core/util/hashpact_theme.dart';

class WordPoolWidget extends StatelessWidget {
  final List<String> words;
  final Set<String> usedWords;
  final ValueChanged<String> onTap;

  const WordPoolWidget({
    super.key,
    required this.words,
    required this.usedWords,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: words.map((word) {
        final used = usedWords.contains(word);
        return GestureDetector(
          onTap: used ? null : () => onTap(word),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: used ? AppColors.surface : AppColors.surfaceHigh,
              borderRadius: AppRadius.full,
              border: Border.all(
                color: used ? AppColors.border : AppColors.primary,
              ),
            ),
            child: Text(
              word,
              style: AppTextStyles.mono.copyWith(
                fontSize: 12,
                color: used ? AppColors.textMuted : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
