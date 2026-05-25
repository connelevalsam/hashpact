/*
* Created by Connel Asikong on 23/05/2026
*
*/

// lib/core/providers/swap_engine_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/swap_engine.dart';
import 'identity_provider.dart';
import 'swap_provider.dart';

final swapEngineProvider = Provider<SwapEngine?>((ref) {
  final identity = ref.watch(identityProvider).value;
  final nostr = ref.watch(nostr);

  if (identity == null || nostr == null) return null;

  final engine = SwapEngine(
    myPubKeyHex: identity.nostrPubKeyHex,
    nostrService: nostr,
    onSwapUpdate: (swap) {
      // Whenever the engine updates a swap, persist it
      ref.read(swapProvider.notifier).upsertSwap(swap);
    },
  );

  // Restore persisted swaps into engine memory
  final swaps = ref.read(swapProvider).value ?? [];
  for (final swap in swaps) {
    engine.restore(swap);
  }

  return engine;
});
