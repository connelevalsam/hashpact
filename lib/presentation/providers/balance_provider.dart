/*
* Created by Connel Asikong on 31/03/2026
*
*/

// balance_provider

// lib/core/providers/balance_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/token_info.dart';
import '../../core/services/sui_service.dart';
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
    if (identity == null ||
        identity.suiAddress == 'pending' ||
        identity.suiAddress == '')
      return {};

    final sui = SuiService(useTestnet: true);
    final results = <String, BigInt>{};

    results['SUI'] = await sui.getSuiBalance(identity.suiAddress);

    for (final token in TokenRegistry.suiTokens) {
      if (token.id == 'SUI') continue;
      if (token.testnetCoinType == null) continue;
      results[token.id] = await sui.getCoinBalance(
        identity.suiAddress,
        token.testnetCoinType!,
      );
    }

    results['BTC'] = BigInt.zero;

    return results;
  }
}
