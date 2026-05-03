/*
* Created by Connel Asikong on 02/05/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../core/util/hashpact_theme.dart';

class PinDotsWidget extends StatelessWidget {
  const PinDotsWidget({
    super.key,
    required this.filled,
    required this.total,
    required this.hasError,
    required this.loading,
  });

  final int filled;
  final int total;
  final bool hasError;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isFilled = i < filled;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? hasError
                      ? AppColors.danger
                      : AppColors.primary
                : Colors.transparent,
            border: Border.all(
              color: isFilled
                  ? hasError
                        ? AppColors.danger
                        : AppColors.primary
                  : AppColors.border,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}
