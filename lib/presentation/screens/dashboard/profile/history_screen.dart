/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hashpact/presentation/screens/dashboard/profile/widgets/empty_state_widget.dart';
import 'package:hashpact/presentation/screens/dashboard/profile/widgets/swap_tile_widget.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/util/hashpact_theme.dart';

enum swapStatus { completed, failed, refunded }

class DummySwap {
  const DummySwap({
    required this.id,
    required this.sendToken,
    required this.receiveToken,
    required this.sendAmount,
    required this.receiveAmount,
    required this.sendEmoji,
    required this.receiveEmoji,
    required this.peer,
    required this.status,
    required this.completedAt,
    this.walrusBlobId,
  });

  final String id;
  final String sendToken;
  final String receiveToken;
  final String sendAmount;
  final String receiveAmount;
  final String sendEmoji;
  final String receiveEmoji;
  final String peer;
  final swapStatus status;
  final DateTime completedAt;
  final String? walrusBlobId;
}

final _dummySwaps = [
  DummySwap(
    id: 'swap_001',
    sendToken: 'SUI',
    receiveToken: 'BTC',
    sendAmount: '1.0',
    receiveAmount: '0.001',
    sendEmoji: '💧',
    receiveEmoji: '₿',
    peer: 'Alice',
    status: swapStatus.completed,
    completedAt: DateTime.now().subtract(const Duration(hours: 2)),
    walrusBlobId: 'blobABC123',
  ),
  DummySwap(
    id: 'swap_002',
    sendToken: 'BTC',
    receiveToken: 'USDC',
    sendAmount: '0.002',
    receiveAmount: '120.0',
    sendEmoji: '₿',
    receiveEmoji: '🔵',
    peer: 'Bob',
    status: swapStatus.failed,
    completedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  DummySwap(
    id: 'swap_003',
    sendToken: 'USDT',
    receiveToken: 'SUI',
    sendAmount: '50.0',
    receiveAmount: '20.5',
    sendEmoji: '🟢',
    receiveEmoji: '💧',
    peer: 'Charlie',
    status: swapStatus.completed,
    completedAt: DateTime.now().subtract(const Duration(days: 3)),
    walrusBlobId: 'blobXYZ789',
  ),
  DummySwap(
    id: 'swap_004',
    sendToken: 'SUI',
    receiveToken: 'USDT',
    sendAmount: '5.0',
    receiveAmount: '12.0',
    sendEmoji: '💧',
    receiveEmoji: '🟢',
    peer: 'Alice',
    status: swapStatus.refunded,
    completedAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
];

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Swap history'),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: _dummySwaps.isEmpty
          ? EmptyStateWidget()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: _dummySwaps.length,
              itemBuilder: (_, i) {
                return SwapTileWidget(swap: _dummySwaps[i])
                    .animate()
                    .fadeIn(
                      delay: Duration(milliseconds: 60 * i),
                      duration: 300.ms,
                    )
                    .slideY(
                      begin: 0.05,
                      end: 0,
                      delay: Duration(milliseconds: 60 * i),
                      duration: 300.ms,
                    );
              },
            ),
    );
  }
}
