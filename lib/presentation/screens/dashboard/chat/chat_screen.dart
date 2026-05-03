/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashpact/presentation/screens/dashboard/chat/widgets/appbar_widget.dart';
import 'package:hashpact/presentation/screens/dashboard/chat/widgets/bubble_widget.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/models/chat_message.dart';
import '../../../../core/util/hashpact_theme.dart';
import 'widgets/swap_bubble.dart';
import 'widgets/swap_request_sheet.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.peerPubKey});

  final String peerPubKey;

  @override
  ConsumerState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  final List<Msg> _messages = List.from(dummyMessages);

  String get _displayName {
    // In real app this comes from contacts provider
    // For now derive a name from the pubkey
    return 'Peer ${widget.peerPubKey.substring(0, 4)}';
  }

  String get _truncatedKey {
    final k = widget.peerPubKey;
    if (k.length <= 16) return k;
    return '${k.substring(0, 8)}...${k.substring(k.length - 8)}';
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(Msg(text: text, isMe: true, time: DateTime.now()));
      _controller.clear();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _dateDivider(DateTime date) {
    String _label = '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) _label = 'Today';
    if (d == today.subtract(const Duration(days: 1))) _label = 'Yesterday';
    _label = '${date.day}/${date.month}/${date.year}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.border)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              _label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ),
          const Expanded(child: Divider(color: AppColors.border)),
        ],
      ),
    );
  }

  Widget _inputBar(
    TextEditingController controller,
    FocusNode focusNode,
    VoidCallback onSend,
    VoidCallback onSwapTap,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        MediaQuery.viewPaddingOf(context).bottom + 8,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onSwapTap,
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedCoinsSwap,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: AppTextStyles.body,
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Message...',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.xl,
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.xl,
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.xl,
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (_, value, __) {
              final hasText = value.text.trim().isNotEmpty;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hasText ? AppColors.primary : AppColors.surfaceHigh,
                ),
                child: IconButton(
                  onPressed: hasText ? onSend : null,
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedSent,
                    color: hasText ? Colors.white : AppColors.textMuted,
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSwapSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SwapRequestSheet(),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget(
        displayName: _displayName,
        truncatedKey: _truncatedKey,
        fullKey: widget.peerPubKey,
        onSwapTap: () {
          // TODO: open swap request sheet
        },
      ),
      body: Column(
        children: [
          // ── Messages ────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                final showDate =
                    i == 0 || !_sameDay(_messages[i - 1].time, msg.time);
                return Column(
                  children: [
                    if (showDate) _dateDivider(msg.time),
                    if (msg.isSwap)
                      SwapBubble(
                        isMe: msg.isMe,
                        time: msg.time,
                      ).animate().fadeIn(duration: 200.ms)
                    else
                      BubbleWidget(msg: msg)
                          .animate()
                          .fadeIn(duration: 200.ms)
                          .slideY(begin: 0.04, end: 0, duration: 200.ms),
                  ],
                );
              },
            ),
          ),

          // ── Input bar ───────────────────────────────────────
          _inputBar(_controller, _focusNode, _send, () {
            // TODO: open swap request sheet
            _showSwapSheet(context);
          }),
        ],
      ),
    );
  }
}
