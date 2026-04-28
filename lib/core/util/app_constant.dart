/*
* Created by Connel Asikong on 28/04/2026
*
*/

abstract class AppConstants {
  // ── Nostr ────────────────────────────────────────────────
  static const nostrRelay = 'wss://relay.damus.io';
  static const nostrMsgOffer = 'hashpact_swap_offer';
  static const nostrMsgStatus = 'hashpact_swap_status';

  // ── SUI ──────────────────────────────────────────────────
  static const suiDerivationPath = "m/44'/784'/0'/0'/0'";
  static const nostrDerivationPath = "m/44'/1237'/0'/0/0";

  // ── HTLC ─────────────────────────────────────────────────
  static const htlcExpiryHours = 24;
  static const htlcSecretBytes = 32;

  // ── Storage keys ─────────────────────────────────────────
  static const keyAuthType = 'hp_auth_type';
  static const keyNostrPriv = 'hp_nostr_priv';
  static const keyNostrPub = 'hp_nostr_pub';
  static const keySuiAddress = 'hp_sui_address';
  static const keyNpub = 'hp_npub';
  static const keyPinHash = 'hp_pin_hash';
  static const keyZkEphemeral = 'hp_zk_ephemeral';
  static const keyZkSalt = 'hp_zk_salt';
  static const keyContacts = 'hp_contacts';
  static const keySwapHistory = 'hp_swap_history';
  static const keyPrivacyMode = 'hp_privacy_mode';
  static const keyZkMaxEpoch = 'hp_zk_max_epoch';

  static String keyChatWith(String pubkey) => 'hp_chat_$pubkey';
  static String keyWalrusReceipt(String swapId) => 'hp_walrus_$swapId';

  // ── UI ───────────────────────────────────────────────────
  static const chatMaxMessages = 200;
  static const addressPreviewLen = 8; // chars shown before truncation
}
