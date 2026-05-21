/*
* Created by Connel Asikong on 02/05/2026
*
*/

import 'package:flutter/material.dart';
import 'package:hashpact/presentation/screens/dashboard/chat/widgets/avatar_widget.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/models/contact.dart';
import '../../../../../core/util/hashpact_theme.dart';

class ContactTileWidget extends StatelessWidget {
  const ContactTileWidget({
    super.key,
    required this.contact,
    required this.onTap,
  });

  final Contact contact;
  // final DummyContact contact;
  final VoidCallback onTap;

  String get _truncatedKey {
    final k = contact.nostrPubKeyHex;
    return '${k.substring(0, 8)}...${k.substring(k.length - 8)}';
  }

  String _timeAgo(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.md,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              AvatarWidget(name: contact.displayName),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.displayName,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contact.lastMessage ?? _truncatedKey,
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (contact.lastMessageAt != null) ...[
                Text(
                  _timeAgo(contact.lastMessageAt!),
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              const HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: AppColors.textMuted,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
