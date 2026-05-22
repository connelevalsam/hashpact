/*
* Created by Connel Asikong on 02/05/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../../core/models/chat_message.dart';
import '../../../../../core/util/hashpact_theme.dart';

class BubbleWidget extends StatelessWidget {
  const BubbleWidget({super.key, required this.msg, required this.isMe});

  final ChatMessage msg;
  final bool isMe;

  String get _time {
    final h = msg.createdAt.hour.toString().padLeft(2, '0');
    final m = msg.createdAt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.72,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryDim : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          border: Border.all(
            color: isMe
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(msg.content, style: AppTextStyles.body),
            const SizedBox(height: 4),
            Text(
              _time,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
