/*
* Created by Connel Asikong on 31/03/2026
*
*/

// identity_provider

// ── Providers ────────────────────────────────────────────────────────────────

import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/identity.dart';

/// The root identity provider. AsyncValue<IdentityState?>.
/// null  = no account exists yet (show onboarding)
/// data  = authenticated identity
final identityProvider =
    AsyncNotifierProvider<IdentityNotifier, IdentityState?>(
      IdentityNotifier.new,
    );

// ── Notifier ─────────────────────────────────────────────────────────────────

class IdentityNotifier extends AsyncNotifier<IdentityState?> {
  String? _pendingMnemonic;

  @override
  Future<IdentityState?> build() async {
    // On cold start: check if we already have keys stored
    return null;
  }

  Future<String> generateNewMnemonic() async {
    // bip39 generates 12 random words from the BIP39 word list
    // We import the package directly here in the provider
    // The actual derivation happens later — for now we just generate and return
    final mnemonic = bip39.generateMnemonic();
    return mnemonic;
  }

  String? get pendingMnemonic => _pendingMnemonic;

  void clearPendingMnemonic() {
    _pendingMnemonic = null;
  }
}
