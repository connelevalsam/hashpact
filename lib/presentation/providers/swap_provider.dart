/*
* Created by Connel Asikong on 31/03/2026
*
*/

// swap_provider

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/swap_offer.dart';
import '../../core/storage/local_storage.dart';
import '../../core/util/app_constant.dart';

final swapProvider = AsyncNotifierProvider<SwapNotifier, List<SwapOffer>>(
  SwapNotifier.new,
);

class SwapNotifier extends AsyncNotifier<List<SwapOffer>> {
  @override
  FutureOr<List<SwapOffer>> build() {
    return _load();
  }

  // ========= LOAD =========
  Future<List<SwapOffer>> _load() async {
    final raw = await PrefStore.instance.getString(AppConstants.keySwapHistory);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => SwapOffer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ========= UPSERT =========
  Future<void> upsertSwap(SwapOffer swap) async {
    final current = state.value ?? [];

    // Replace if exists, add if new
    final exists = current.any((s) => s.id == swap.id);
    final updated = exists
        ? current.map((s) => s.id == swap.id ? swap : s).toList()
        : [...current, swap];

    state = AsyncData(updated);
    await _persist(updated);
  }

  // ========= FIND BY ID =========
  SwapOffer? findById(String id) {
    return state.value?.where((s) => s.id == id).firstOrNull;
  }

  // ========= SWAPS WITH PEER =========
  List<SwapOffer> swapsWithPeer(String peerPubKey) {
    return (state.value ?? [])
        .where(
          (s) =>
              s.initiatorPubKey == peerPubKey || s.counterPubKey == peerPubKey,
        )
        .toList();
  }

  // ========= COMPLETED SWAPS =========
  List<SwapOffer> get completedSwaps {
    return (state.value ?? []).where((s) => s.isTerminal).toList()
      ..sort((a, b) => b.expiresAt.compareTo(a.expiresAt));
  }

  // ========= PERSIST =========
  Future<void> _persist(List<SwapOffer> swaps) => PrefStore.instance.setString(
    AppConstants.keySwapHistory,
    jsonEncode(swaps.map((s) => s.toJson()).toList()),
  );
}
