/*
* Created by Connel Asikong on 31/03/2026
*
*/

// key_manager

// ─────────────────────────────────────────────────────────────
// What comes out of key derivation
// ─────────────────────────────────────────────────────────────

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:sui/cryptography/signature.dart';
import 'package:sui/sui_account.dart';

class DerivedKeys {
  const DerivedKeys({
    required this.nostrPrivKeyHex,
    required this.nostrPubKeyHex,
    required this.suiPrivKeyHex,
    required this.suiAddress,
  });

  final String nostrPrivKeyHex; // 64-char hex — NEVER shown in UI
  final String nostrPubKeyHex; // 64-char hex — shared as contact ID
  final String suiPrivKeyHex; // 64-char hex — NEVER shown in UI
  final String suiAddress; // 0x... — shown in profile
}

// ─────────────────────────────────────────────────────────────
// KEY MANAGER
// ─────────────────────────────────────────────────────────────

abstract class KeyManager {
  /// Generate a fresh random 12-word mnemonic.
  static String generateMnemonic() => bip39.generateMnemonic();

  /// Validate all 12 words are in the BIP39 word list.
  static bool validateMnemonic(String mnemonic) =>
      bip39.validateMnemonic(mnemonic);

  /// Derive all keys from a mnemonic.
  /// This is deterministic — same mnemonic always produces
  /// the exact same keys. This is what makes seed phrases work.
  static DerivedKeys deriveFromMnemonic(String mnemonic) {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw Exception('Invalid mnemonic');
    }

    // Step 1: mnemonic → 64-byte seed
    final seed = bip39.mnemonicToSeed(mnemonic);

    // Step 2: seed → BIP32 root node (secp256k1 tree)
    final root = bip32.BIP32.fromSeed(seed);

    // Step 3: derive Nostr keypair at NIP-06 path
    // m/44'/1237'/0'/0/0
    // The apostrophes mean "hardened" — extra security,
    // child keys can't be derived from parent public key
    final nostrNode = root.derivePath("m/44'/1237'/0'/0/0");
    final nostrPriv = nostrNode.privateKey!;
    final nostrPrivHex = _bytesToHex(nostrPriv);

    // Nostr public key is the x-only secp256k1 point
    // The nostr package derives this correctly from the privkey
    final nostrPubHex = _bytesToHex(nostrNode.publicKey).substring(2);
    // publicKey is 33 bytes (02/03 prefix + 32 bytes x-coord)
    // Nostr uses only the 32-byte x-coordinate — strip prefix

    // Step 4: derive SUI keypair
    // SUI uses ed25519 with SLIP-10 hardened derivation
    // The sui package handles this internally via fromMnemonics
    final suiAccount = SuiAccount.fromMnemonics(
      mnemonic,
      SignatureScheme.Ed25519,
    );

    return DerivedKeys(
      nostrPrivKeyHex: nostrPrivHex,
      nostrPubKeyHex: nostrPubHex,
      suiPrivKeyHex: suiAccount.privateKey.toString(),
      suiAddress: suiAccount.getAddress(),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────

  static String _bytesToHex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
