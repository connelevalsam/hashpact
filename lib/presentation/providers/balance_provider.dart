/*
* Created by Connel Asikong on 31/03/2026
*
*/

// balance_provider

// lib/core/providers/balance_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'identity_provider.dart';

// ── Privacy mode ──────────────────────────────────────────────

final privacyModeProvider = NotifierProvider<PrivacyModeNotifier, bool>(
  PrivacyModeNotifier.new,
);

class PrivacyModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

// ── Balances ──────────────────────────────────────────────────

final balanceProvider =
    AsyncNotifierProvider<BalanceNotifier, Map<String, BigInt>>(
      BalanceNotifier.new,
    );

class BalanceNotifier extends AsyncNotifier<Map<String, BigInt>> {
  @override
  Future<Map<String, BigInt>> build() => _fetchAll();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchAll);
  }

  Future<Map<String, BigInt>> _fetchAll() async {
    final identity = ref.read(identityProvider).value;
    if (identity == null) return {};

    final results = <String, BigInt>{};

    /*try {
      final suiService = SuiService(useTestnet: true);
      final suiBalances = await suiService.getAllBalances(identity.suiAddress);
      results.addAll(suiBalances);
    } catch (_) {
      for (final t in TokenRegistry.suiTokens) {
        results[t.id] = BigInt.zero;
      }
    }

    try {
      final btcService = BtcService(useTestnet: true);
      final btcBalance = await btcService.getBalance(_btcAddress(identity));
      results['BTC'] = btcBalance.confirmedSats;
    } catch (_) {
      results['BTC'] = BigInt.zero;
    }*/

    return results;
  }

  String _btcAddress(identity) {
    // Placeholder until BIP84 derivation is wired
    return 'tb1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx';
  }
}
