/*
* Created by Connel Asikong on 29/04/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../core/util/hashpact_theme.dart';

// ─────────────────────────────────────────────────────────────
// WORD GRID
// ─────────────────────────────────────────────────────────────
// 12 words in a 3-column grid.
// When not revealed, the words are blurred — the user must
// consciously choose to see them. This prevents shoulder surfing.

class WordGridWidget extends StatelessWidget {
  final List<String> words;
  final bool revealed;

  const WordGridWidget({
    super.key,
    required this.words,
    required this.revealed,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 2.4,
      ),
      itemCount: words.length,
      itemBuilder: (_, index) =>
          WordTile(index: index + 1, word: words[index], revealed: revealed),
    );
  }
}

class WordTile extends StatelessWidget {
  final int index;
  final String word;
  final bool revealed;

  const WordTile({
    super.key,
    required this.index,
    required this.word,
    required this.revealed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.sm,
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Text(
            '$index.',
            style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                revealed ? word : '••••••',
                key: ValueKey(revealed),
                style: revealed
                    ? AppTextStyles.mono.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                      )
                    : AppTextStyles.mono.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
