/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/util/hashpact_theme.dart';

class SwapRequestSheet extends ConsumerStatefulWidget {
  const SwapRequestSheet({super.key});

  @override
  ConsumerState createState() => _SwapRequestSheetState();
}

class _SwapRequestSheetState extends ConsumerState<SwapRequestSheet> {
  String _sendToken = 'SUI';
  String _receiveToken = 'BTC';
  final _sendController = TextEditingController();
  final _receiveController = TextEditingController();

  final _tokens = const ['SUI', 'BTC', 'USDC', 'USDT'];
  final _emojis = const {'SUI': '💧', 'BTC': '₿', 'USDC': '🔵', 'USDT': '🟢'};

  void _flip() {
    setState(() {
      final tmp = _sendToken;
      _sendToken = _receiveToken;
      _receiveToken = tmp;
    });
  }

  @override
  void dispose() {
    _sendController.dispose();
    _receiveController.dispose();
    super.dispose();
  }

  Widget _tokenAmountRow({
    required String label,
    required String selectedToken,
    required List<String> tokens,
    required Map<String, String> emojis,
    required TextEditingController controller,
    required void Function(String) onTokenChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: AppRadius.md,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              // Token picker
              DropdownButton<String>(
                value: selectedToken,
                dropdownColor: AppColors.surfaceHigh,
                underline: const SizedBox.shrink(),
                items: tokens.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          emojis[t] ?? '',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          t,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (v) => v != null ? onTokenChanged(v) : null,
              ),

              const SizedBox(width: AppSpacing.md),

              // Amount input
              Expanded(
                child: TextField(
                  controller: controller,
                  style: AppTextStyles.monoLarge.copyWith(fontSize: 20),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: AppRadius.full,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text('Propose a swap', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Set the terms. The other party can accept or decline.',
              style: AppTextStyles.bodySmall,
            ),

            const SizedBox(height: AppSpacing.lg),

            // Send row
            _tokenAmountRow(
              label: 'You send',
              selectedToken: _sendToken,
              tokens: _tokens,
              emojis: _emojis,
              controller: _sendController,
              onTokenChanged: (t) => setState(() => _sendToken = t),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Flip button
            Center(
              child: GestureDetector(
                onTap: _flip,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceHigh,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowUpDown,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Receive row
            _tokenAmountRow(
              label: 'You receive',
              selectedToken: _receiveToken,
              tokens: _tokens,
              emojis: _emojis,
              controller: _receiveController,
              onTokenChanged: (t) => setState(() => _receiveToken = t),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Expiry note
            Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedClock01,
                  color: AppColors.textMuted,
                  size: 14,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Offer expires in 24 hours',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            FilledButton(
              onPressed: () {
                // TODO: create swap offer via provider
                Navigator.pop(context);
              },
              child: const Text('Send offer'),
            ),
          ],
        ),
      ),
    );
  }
}
