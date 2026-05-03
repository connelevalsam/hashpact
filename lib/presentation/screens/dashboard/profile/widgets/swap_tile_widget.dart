/*
* Created by Connel Asikong on 02/05/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/util/hashpact_theme.dart';
import '../history_screen.dart';

class SwapTileWidget extends StatelessWidget {
  const SwapTileWidget({super.key, required this.swap});

  final DummySwap swap;

  Color get _statusColor => switch (swap.status) {
    swapStatus.completed => AppColors.success,
    swapStatus.failed => AppColors.danger,
    swapStatus.refunded => AppColors.warning,
  };

  String get _statusLabel => switch (swap.status) {
    swapStatus.completed => 'Completed',
    swapStatus.failed => 'Failed',
    swapStatus.refunded => 'Refunded',
  };

  List<List> get _statusIcon => switch (swap.status) {
    swapStatus.completed => HugeIcons.strokeRoundedCheckmarkCircle01,
    swapStatus.failed => HugeIcons.strokeRoundedCancelCircle,
    swapStatus.refunded => HugeIcons.strokeRoundedPayment01,
  };

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.md,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Token pair display
                _tokenPair(
                  sendEmoji: swap.sendEmoji,
                  receiveEmoji: swap.receiveEmoji,
                  sendToken: swap.sendToken,
                  receiveToken: swap.receiveToken,
                ),

                const Spacer(),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: AppRadius.full,
                    border: Border.all(
                      color: _statusColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HugeIcon(
                        icon: _statusIcon,
                        color: _statusColor,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _statusLabel,
                        style: AppTextStyles.label.copyWith(
                          color: _statusColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: AppSpacing.sm),

            // Amounts row
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sent',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      '${swap.sendAmount} ${swap.sendToken}',
                      style: AppTextStyles.mono.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                  color: AppColors.textMuted,
                  size: 16,
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Received',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      '${swap.receiveAmount} ${swap.receiveToken}',
                      style: AppTextStyles.mono.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Footer row: peer + date + walrus
            Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedUser,
                  color: AppColors.textMuted,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(swap.peer, style: AppTextStyles.bodySmall),
                const Spacer(),
                if (swap.walrusBlobId != null) ...[
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedFile01,
                    color: AppColors.primary,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Receipt',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.primary,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  _formatDate(swap.completedAt),
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tokenPair({
    required String sendEmoji,
    required String receiveEmoji,
    required String sendToken,
    required String receiveToken,
  }) {
    return Row(
      children: [
        // Overlapping emoji circles
        SizedBox(
          width: 56,
          height: 32,
          child: Stack(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceHigh,
                  border: Border.all(color: AppColors.border),
                ),
                child: Center(
                  child: Text(sendEmoji, style: const TextStyle(fontSize: 16)),
                ),
              ),
              Positioned(
                left: 20,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceHigh,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Center(
                    child: Text(
                      receiveEmoji,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        Text(
          '$sendToken → $receiveToken',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
