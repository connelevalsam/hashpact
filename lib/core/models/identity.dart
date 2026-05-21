/*
* Created by Connel Asikong on 31/03/2026
*
*/

// Single source of truth for who the user is.
// Supports two auth paths: BIP39 seed phrase and SUI zkLogin.
// The rest of the app never needs to know which is active —
// it just reads suiAddress / nostrPubKeyHex from this model.

import 'package:equatable/equatable.dart';

/// Which onboarding path the user chose.
enum AuthType { seed, zkLogin }

/// Immutable snapshot of the user's identity.
/// Updated by IdentityNotifier; read everywhere else.
class IdentityState extends Equatable {
  const IdentityState({
    required this.authType,
    required this.suiAddress,
    required this.nostrPrivKeyHex,
    required this.nostrPubKeyHex,
    required this.npubDisplay,
    // Below will be null for seed auth
    this.zkLoginJwt,
    this.zkLoginProof,
    this.zkLoginEphemeralKeyHex,
    this.zkLoginUserSalt,
    this.zkLoginMaxEpoch,
  });

  final AuthType authType;

  // ── SUI identity ──────────────────────────────────────────────
  final String suiAddress; // 0x... 32-byte hex

  // ── Nostr identity ────────────────────────────────────────────
  final String nostrPrivKeyHex; // 64-char hex — never shown in UI
  final String nostrPubKeyHex; // 64-char hex — used as contact ID
  final String npubDisplay; // bech32 npub1... — shown in profile

  // ── zkLogin fields (only populated when authType == zkLogin) ──
  final String? zkLoginJwt;
  final String? zkLoginProof;
  final String? zkLoginEphemeralKeyHex;
  final String? zkLoginUserSalt;
  final int? zkLoginMaxEpoch;

  bool get isZkLogin => authType == AuthType.zkLogin;
  bool get isSeed => authType == AuthType.seed;

  IdentityState copyWith({
    AuthType? authType,
    String? suiAddress,
    String? nostrPrivKeyHex,
    String? nostrPubKeyHex,
    String? npubDisplay,
    String? zkLoginJwt,
    String? zkLoginProof,
    String? zkLoginEphemeralKeyHex,
    String? zkLoginUserSalt,
    int? zkLoginMaxEpoch,
  }) {
    return IdentityState(
      authType: authType ?? this.authType,
      suiAddress: suiAddress ?? this.suiAddress,
      nostrPrivKeyHex: nostrPrivKeyHex ?? this.nostrPrivKeyHex,
      nostrPubKeyHex: nostrPubKeyHex ?? this.nostrPubKeyHex,
      npubDisplay: npubDisplay ?? this.npubDisplay,
      zkLoginJwt: zkLoginJwt ?? this.zkLoginJwt,
      zkLoginProof: zkLoginProof ?? this.zkLoginProof,
      zkLoginEphemeralKeyHex:
          zkLoginEphemeralKeyHex ?? this.zkLoginEphemeralKeyHex,
      zkLoginUserSalt: zkLoginUserSalt ?? this.zkLoginUserSalt,
      zkLoginMaxEpoch: zkLoginMaxEpoch ?? this.zkLoginMaxEpoch,
    );
  }

  @override
  List<Object?> get props => [
    authType,
    suiAddress,
    nostrPrivKeyHex,
    nostrPubKeyHex,
    npubDisplay,
    zkLoginJwt,
    zkLoginProof,
    zkLoginEphemeralKeyHex,
    zkLoginUserSalt,
    zkLoginMaxEpoch,
  ];
}
