/*
* Created by Connel Asikong on 31/03/2026
*
*/
// swap_engine

// lib/core/services/swap_engine.dart

import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../crypto/htlc_crypto.dart';
import '../models/swap_offer.dart';
import '../models/token_info.dart';
import '../util/app_constant.dart';
import 'nostr_dm_service.dart';

class SwapEngine {
  SwapEngine({
    required this.myPubKeyHex,
    required this.nostrService,
    required this.onSwapUpdate,
  });

  final String myPubKeyHex;
  final NostrDMService nostrService;

  // Called whenever a swap state changes — SwapProvider listens here
  final void Function(SwapOffer swap) onSwapUpdate;

  // In-memory swap store
  final Map<String, SwapOffer> _swaps = {};

  // ── Alice: create and send offer ──────────────────────────

  Future<SwapOffer> createOffer({
    required String counterPubKey,
    required String sendTokenId,
    required String receiveTokenId,
    required BigInt sendAmount,
    required BigInt receiveAmount,
  }) async {
    final sendToken = TokenRegistry.byId(sendTokenId);
    final receiveToken = TokenRegistry.byId(receiveTokenId);

    // Generate HTLC secret
    final htlc = await HTLCCrypto.generateSecret(
      suiPackageId: '0x0', // placeholder until contract deployed
    );

    final offer = SwapOffer(
      id: const Uuid().v4(),
      initiatorPubKey: myPubKeyHex,
      counterPubKey: counterPubKey,
      sendTokenId: sendTokenId,
      receiveTokenId: receiveTokenId,
      sendChain: sendToken.chain,
      receiveChain: receiveToken.chain,
      sendAmount: sendAmount,
      receiveAmount: receiveAmount,
      secretHash: htlc.secretHashHex,
      expiresAt: _expiresAt24h(),
      state: SwapState.offerSent,
      secret: htlc.secretHex,
      sealWrappedSecret: htlc.sealWrappedBlob,
    );

    _swaps[offer.id] = offer;
    onSwapUpdate(offer);

    // Send over Nostr — secret NOT included
    await nostrService.sendPayload(counterPubKey, {
      'type': AppConstants.nostrMsgOffer,
      'offer': _toWire(offer),
    });

    return offer;
  }

  // ── Bob: accept incoming offer ────────────────────────────

  void receiveOffer(String fromPubKey, Map<String, dynamic> offerJson) {
    final offer = _fromWire(offerJson, fromPubKey);
    if (_swaps.containsKey(offer.id)) return; // deduplicate
    _swaps[offer.id] = offer;
    onSwapUpdate(offer);
  }

  Future<void> acceptOffer(String swapId) async {
    final swap = _swaps[swapId];
    if (swap == null || swap.state != SwapState.offerSent) return;
    await _broadcastStatus(swap, SwapState.initiatorLocked);
  }

  Future<void> declineOffer(String swapId) async {
    final swap = _swaps[swapId];
    if (swap == null || swap.isTerminal) return;
    final updated = swap.copyWith(state: SwapState.declined);
    _swaps[swapId] = updated;
    onSwapUpdate(updated);
    await _broadcastStatus(updated, SwapState.declined);
  }

  // ── Handle incoming status updates ───────────────────────

  void receiveStatus(Map<String, dynamic> payload) {
    final swapId = payload['swapId'] as String?;
    if (swapId == null) return;

    final swap = _swaps[swapId];
    if (swap == null || swap.isTerminal) return;

    final newState = SwapState.values.byName(payload['state'] as String);
    final updated = swap.copyWith(
      state: newState,
      secret: payload['secret'] as String? ?? swap.secret,
    );

    _swaps[swapId] = updated;
    onSwapUpdate(updated);
  }

  // ── Restore from persisted swaps ─────────────────────────

  void restore(SwapOffer swap) {
    _swaps[swap.id] = swap;
  }

  // ── Helpers ───────────────────────────────────────────────

  Future<void> _broadcastStatus(
    SwapOffer swap,
    SwapState newState, {
    Map<String, dynamic>? extra,
  }) async {
    final peer = swap.initiatorPubKey == myPubKeyHex
        ? swap.counterPubKey
        : swap.initiatorPubKey;

    await nostrService.sendPayload(peer, {
      'type': AppConstants.nostrMsgStatus,
      'swapId': swap.id,
      'state': newState.name,
      ...?extra,
    });
  }

  // Wire format — secret intentionally omitted
  Map<String, dynamic> _toWire(SwapOffer offer) => {
    'id': offer.id,
    'initiatorPubKey': offer.initiatorPubKey,
    'counterPubKey': offer.counterPubKey,
    'sendTokenId': offer.sendTokenId,
    'receiveTokenId': offer.receiveTokenId,
    'sendChain': offer.sendChain.name,
    'receiveChain': offer.receiveChain.name,
    'sendAmount': offer.sendAmount.toString(),
    'receiveAmount': offer.receiveAmount.toString(),
    'secretHash': offer.secretHash,
    'expiresAt': offer.expiresAt,
    'sealWrappedSecret': offer.sealWrappedSecret,
  };

  SwapOffer _fromWire(Map<String, dynamic> json, String fromPubKey) =>
      SwapOffer(
        id: json['id'] as String,
        initiatorPubKey: fromPubKey,
        counterPubKey: myPubKeyHex,
        sendTokenId: json['sendTokenId'] as String,
        receiveTokenId: json['receiveTokenId'] as String,
        sendChain: Chain.values.byName(json['sendChain'] as String),
        receiveChain: Chain.values.byName(json['receiveChain'] as String),
        sendAmount: BigInt.parse(json['sendAmount'] as String),
        receiveAmount: BigInt.parse(json['receiveAmount'] as String),
        secretHash: json['secretHash'] as String,
        expiresAt: json['expiresAt'] as int,
        state: SwapState.offerSent,
        sealWrappedSecret: json['sealWrappedSecret'] as String?,
      );

  int _expiresAt24h() =>
      DateTime.now()
          .add(const Duration(hours: AppConstants.htlcExpiryHours))
          .millisecondsSinceEpoch ~/
      1000;
}
