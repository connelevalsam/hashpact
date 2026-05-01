/*
* Created by Connel Asikong on 31/03/2026
*
*/

// local_storage

// ─────────────────────────────────────────────────────────────
// SECURE STORE
// Wraps flutter_secure_storage.
// Use for: private keys, PIN hash, zkLogin ephemeral key.
// Data here is encrypted by the OS keychain (iOS) or
// EncryptedSharedPreferences (Android).
// ─────────────────────────────────────────────────────────────

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/app_constant.dart';

class SecureStore {
  SecureStore._();
  static final instance = SecureStore._();

  final _store = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ── Write ───────────────────────────────────────────────────
  Future<void> write(String key, String value) =>
      _store.write(key: key, value: value);

  // ── Read ────────────────────────────────────────────────────
  Future<String?> read(String key) => _store.read(key: key);

  // ── Delete one ──────────────────────────────────────────────
  Future<void> delete(String key) => _store.delete(key: key);

  // ── Wipe everything — used on logout / restore from seed ────
  Future<void> deleteAll() => _store.deleteAll();

  // ── Typed convenience methods ────────────────────────────────

  Future<void> writeNostrPrivKey(String hex) =>
      write(AppConstants.keyNostrPriv, hex);
  Future<String?> readNostrPrivKey() => read(AppConstants.keyNostrPriv);

  Future<void> writeSuiPrivKey(String hex) =>
      write(AppConstants.keySuiPriv, hex);
  Future<String?> readSuiPrivKey() => read(AppConstants.keySuiPriv);

  Future<void> writePinHash(String hash) =>
      write(AppConstants.keyPinHash, hash);
  Future<String?> readPinHash() => read(AppConstants.keyPinHash);

  Future<void> writeAuthType(String type) =>
      write(AppConstants.keyAuthType, type);
  Future<String?> readAuthType() => read(AppConstants.keyAuthType);

  Future<void> writeZkEphemeralKey(String key) =>
      write(AppConstants.keyZkEphemeral, key);
  Future<String?> readZkEphemeralKey() => read(AppConstants.keyZkEphemeral);

  Future<void> writeZkSalt(String salt) => write(AppConstants.keyZkSalt, salt);
  Future<String?> readZkSalt() => read(AppConstants.keyZkSalt);
}

// ─────────────────────────────────────────────────────────────
// PREF STORE
// Wraps SharedPreferences.
// Use for: public identity data, contacts, chat, swap history.
// Not encrypted — don't store anything sensitive here.
// ─────────────────────────────────────────────────────────────

class PrefStore {
  PrefStore._();
  static final instance = PrefStore._();

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // ── Generic typed writes ─────────────────────────────────────
  Future<void> setString(String key, String value) async =>
      (await _prefs).setString(key, value);

  Future<String?> getString(String key) async => (await _prefs).getString(key);

  Future<void> setBool(String key, bool value) async =>
      (await _prefs).setBool(key, value);

  Future<bool?> getBool(String key) async => (await _prefs).getBool(key);

  Future<void> setInt(String key, int value) async =>
      (await _prefs).setInt(key, value);

  Future<int?> getInt(String key) async => (await _prefs).getInt(key);

  Future<void> remove(String key) async => (await _prefs).remove(key);

  Future<void> clear() async => (await _prefs).clear();

  // ── Typed convenience methods ─────────────────────────────────

  Future<void> writeNostrPubKey(String hex) =>
      setString(AppConstants.keyNostrPub, hex);
  Future<String?> readNostrPubKey() => getString(AppConstants.keyNostrPub);

  Future<void> writeSuiAddress(String address) =>
      setString(AppConstants.keySuiAddress, address);
  Future<String?> readSuiAddress() => getString(AppConstants.keySuiAddress);

  Future<void> writeNpub(String npub) => setString(AppConstants.keyNpub, npub);
  Future<String?> readNpub() => getString(AppConstants.keyNpub);

  Future<void> writeHasSeenOnboarding(bool value) =>
      setBool(AppConstants.keyHasSeenOnboarding, value);
  Future<bool> readHasSeenOnboarding() async =>
      (await getBool(AppConstants.keyHasSeenOnboarding)) ?? false;

  Future<void> writeZkMaxEpoch(int epoch) =>
      setInt(AppConstants.keyZkMaxEpoch, epoch);
  Future<int?> readZkMaxEpoch() => getInt(AppConstants.keyZkMaxEpoch);

  Future<void> writePrivacyMode(bool value) =>
      setBool(AppConstants.keyPrivacyMode, value);
  Future<bool> readPrivacyMode() async =>
      (await getBool(AppConstants.keyPrivacyMode)) ?? false;
}
