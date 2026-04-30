/*
* Created by Connel Asikong on 29/04/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../core/util/hashpact_theme.dart';

class VerifyGridWidget extends StatelessWidget {
  final List<String> allWords;
  final List<int> testPositions;
  final Map<int, String> answers;
  final ValueChanged<int> onClearAnswer;

  const VerifyGridWidget({
    super.key,
    required this.allWords,
    required this.testPositions,
    required this.answers,
    required this.onClearAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 2.4,
      ),
      itemCount: allWords.length,
      itemBuilder: (_, i) {
        final isTest = testPositions.contains(i);
        final answer = answers[i];

        if (!isTest) {
          // Normal filled tile
          return _GridTile(
            index: i + 1,
            word: allWords[i],
            state: _TileState.filled,
          );
        }

        if (answer == null) {
          // Empty blank waiting for input
          return _GridTile(index: i + 1, word: '', state: _TileState.empty);
        }

        // Answered — show word, tap to clear
        final isCorrect = answer == allWords[i];
        return GestureDetector(
          onTap: () => onClearAnswer(i),
          child: _GridTile(
            index: i + 1,
            word: answer,
            state: isCorrect ? _TileState.correct : _TileState.wrong,
          ),
        );
      },
    );
  }
}

enum _TileState { filled, empty, correct, wrong }

class _GridTile extends StatelessWidget {
  const _GridTile({
    required this.index,
    required this.word,
    required this.state,
  });

  final int index;
  final String word;
  final _TileState state;

  @override
  Widget build(BuildContext context) {
    final borderColor = switch (state) {
      _TileState.correct => AppColors.success,
      _TileState.wrong => AppColors.danger,
      _TileState.empty => AppColors.primary.withValues(alpha: 0.5),
      _TileState.filled => AppColors.border,
    };

    final bgColor = switch (state) {
      _TileState.correct => AppColors.success.withValues(alpha: 0.1),
      _TileState.wrong => AppColors.danger.withValues(alpha: 0.1),
      _TileState.empty => AppColors.primaryDim,
      _TileState.filled => AppColors.surface,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.sm,
        border: Border.all(color: borderColor),
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
            child: state == _TileState.empty
                ? Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      borderRadius: AppRadius.full,
                    ),
                  )
                : Text(
                    word,
                    style: AppTextStyles.mono.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
    );
  }
}
