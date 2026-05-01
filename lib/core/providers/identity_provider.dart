/*
* Created by Connel Asikong on 31/03/2026
*
*/

// identity_provider

// ── Providers ────────────────────────────────────────────────────────────────

import 'dart:convert';

import 'package:bip39/bip39.dart' as bip39;
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../crypto/key_manager.dart';
import '../models/identity.dart';
import '../storage/local_storage.dart';

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
    return _tryRestore();
  }

  Future<IdentityState?> _tryRestore() async {
    // Check if we have stored keys
    final authType = await SecureStore.instance.readAuthType();
    if (authType == null) return null; // first launch

    final nostrPriv = await SecureStore.instance.readNostrPrivKey();
    final nostrPub = await PrefStore.instance.readNostrPubKey();
    final suiAddress = await PrefStore.instance.readSuiAddress();
    final npub = await PrefStore.instance.readNpub();

    // If any critical field is missing, treat as logged out
    if (nostrPriv == null || nostrPub == null || suiAddress == null) {
      return null;
    }

    return IdentityState(
      authType: AuthType.values.byName(authType),
      suiAddress: suiAddress,
      nostrPrivKeyHex: nostrPriv,
      nostrPubKeyHex: nostrPub,
      npubDisplay: npub ?? '',
    );
  }

  Future<String> generateNewMnemonic() async {
    // bip39 generates 12 random words from the BIP39 word list
    // We import the package directly here in the provider
    // The actual derivation happens later — for now we just generate and return
    final mnemonic = bip39.generateMnemonic();
    _pendingMnemonic = mnemonic;

    return mnemonic;
  }

  String? get pendingMnemonic => _pendingMnemonic;

  void clearPendingMnemonic() {
    _pendingMnemonic = null;
  }

  Future<void> setupPin(String pin) async {
    final mnemonic = _pendingMnemonic;
    if (mnemonic == null) throw Exception('No pending mnemonic');

    // Derive real keys from mnemonic
    final keys = KeyManager.deriveFromMnemonic(mnemonic);

    // Hash the PIN — never store raw PIN
    final pinHash = _hashPin(pin);

    // Persist to secure storage
    await SecureStore.instance.writeNostrPrivKey(keys.nostrPrivKeyHex);
    await SecureStore.instance.writeSuiPrivKey(keys.suiPrivKeyHex);
    await SecureStore.instance.writePinHash(pinHash);
    await SecureStore.instance.writeAuthType(AuthType.seed.name);

    // Persist public data to prefs
    await PrefStore.instance.writeNostrPubKey(keys.nostrPubKeyHex);
    await PrefStore.instance.writeSuiAddress(keys.suiAddress);
    await PrefStore.instance.writeNpub(_toNpub(keys.nostrPubKeyHex));
    await PrefStore.instance.writeHasSeenOnboarding(true);

    // Clear pending mnemonic from memory
    _pendingMnemonic = null;

    // Emit real identity — router unblocks and sends to dashboard
    state = AsyncData(
      IdentityState(
        authType: AuthType.seed,
        suiAddress: keys.suiAddress,
        nostrPrivKeyHex: keys.nostrPrivKeyHex,
        nostrPubKeyHex: keys.nostrPubKeyHex,
        npubDisplay: _toNpub(keys.nostrPubKeyHex),
      ),
    );
  }

  Future<bool> verifyPin(String pin) async {
    final storedHash = await SecureStore.instance.readPinHash();
    if (storedHash == null) return false;
    return _hashPin(pin) == storedHash;
  }

  // ── Logout — clear memory, keep storage ────────────────────
  void lock() => state = const AsyncData(null);

  // ── Full wipe — for restore-from-seed flow ─────────────────
  Future<void> wipeAndReset() async {
    await SecureStore.instance.deleteAll();
    await PrefStore.instance.clear();
    _pendingMnemonic = null;
    state = const AsyncData(null);
  }

  // ── Helpers ─────────────────────────────────────────────────

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    return sha256.convert(bytes).toString();
  }

  String _toNpub(String pubKeyHex) {
    // Simplified display — full bech32 encoding comes later
    return 'npub1${pubKeyHex.substring(0, 12)}...';
  }
}

// shock lake salad wrist famous giraffe balance chef item bleak category system
