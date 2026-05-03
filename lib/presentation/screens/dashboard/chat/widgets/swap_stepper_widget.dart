/*
* Created by Connel Asikong on 02/05/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/util/hashpact_theme.dart';

class SwapStepperWidget extends StatelessWidget {
  const SwapStepperWidget({super.key});

  /*final _steps = const [
    'Offer sent',
    'Initiator locked',
    'Counter locked',
    'Claimed',
    'Completed',
  ];*/

  static const _steps = [
    _Step(label: 'Offer\nsent', icon: HugeIcons.strokeRoundedSent),
    _Step(label: 'Alice\nlocked', icon: HugeIcons.strokeRoundedLockPassword),
    _Step(label: 'Bob\nlocked', icon: HugeIcons.strokeRoundedLockPassword),
    _Step(label: 'Claimed', icon: HugeIcons.strokeRoundedKey01),
    _Step(label: 'Done', icon: HugeIcons.strokeRoundedCheckmarkCircle01),
  ];

  // Dummy: step 1 done
  final int _currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _steps.asMap().entries.map((e) {
        final i = e.key;
        final step = e.value;
        final done = i < _currentStep;
        final active = i == _currentStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done
                            ? AppColors.success
                            : active
                            ? AppColors.primary
                            : AppColors.surfaceHigh,
                        border: Border.all(
                          color: done
                              ? AppColors.success
                              : active
                              ? AppColors.primary
                              : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: done
                          ? const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            )
                          : active
                          ? HugeIcon(
                              icon: step.icon,
                              color: Colors.white,
                              size: 13,
                            )
                          : HugeIcon(
                              icon: step.icon,
                              color: AppColors.textMuted,
                              size: 13,
                            ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.label,
                      style: AppTextStyles.label.copyWith(
                        fontSize: 8,
                        color: done || active
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (i < _steps.length - 1)
                Expanded(
                  child: Container(
                    height: 1,
                    margin: const EdgeInsets.only(bottom: 20),
                    color: done ? AppColors.success : AppColors.border,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _Step {
  const _Step({required this.label, required this.icon});
  final String label;
  final List<List<dynamic>> icon;
}
