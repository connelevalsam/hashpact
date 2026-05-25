/*
* Created by Connel Asikong on 31/03/2026
*
*/

// chat_provider

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hashpact/core/models/chat_message.dart';
import 'package:hashpact/presentation/providers/swap_provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/nostr_dm_service.dart';
import '../../core/storage/local_storage.dart';
import '../../core/util/app_constant.dart';
import 'contacts_provider.dart';
import 'identity_provider.dart';

final chatProvider = AsyncNotifierProvider.autoDispose
    .family<ChatNotifier, List<ChatMessage>, String>(ChatNotifier.new);

class ChatNotifier extends AsyncNotifier<List<ChatMessage>> {
  ChatNotifier(this.currentUserId);

  final String currentUserId;

  @override
  FutureOr<List<ChatMessage>> build() {
    final nostrListener = ref.watch(nostrServiceProvider);
    if (nostrListener != null) {
      final sub = nostrListener.dmStream.listen((dm) {
        if (dm.fromPubKeyHex == currentUserId ||
            dm.toPubKeyHex == currentUserId) {
          final payload = dm.parsedPayload;

          if (payload != null) {
            // ROUTE TO SWAP ENGINE
            final engine = ref.read(swapEngineProvider);
          }

          final msg = ChatMessage(
            id: dm.eventId,
            fromPubKeyHex: dm.fromPubKeyHex,
            toPubKeyHex: dm.toPubKeyHex,
            type: dm.parsedPayload != null
                ? (dm.parsedPayload!['type'] == AppConstants.nostrMsgOffer
                      ? MessageType.swapOffer
                      : MessageType.swapStatus)
                : MessageType.text,
            content: dm.decryptedContent,
            createdAt: dm.createdAt,
          );

          appendIncoming(msg);
        }
      });

      ref.onDispose(sub.cancel);
    }

    return _load();
  }

  // ========= LOAD =========
  Future<List<ChatMessage>> _load() async {
    final raw = await PrefStore.instance.getString(
      AppConstants.keyChatWith(currentUserId),
    );
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ========= SEND MESSAGE =========
  Future<void> sendMessage(String text) async {
    final identity = ref.read(identityProvider).value;
    if (identity == null) return;

    final message = ChatMessage(
      id: const Uuid().v4(),
      fromPubKeyHex: identity.nostrPubKeyHex,
      toPubKeyHex: currentUserId,
      type: MessageType.text,
      content: text,
      createdAt: DateTime.now(),
    );

    await _append(message);

    await ref
        .read(contactsProvider.notifier)
        .updateLastMessage(currentUserId, text);

    final nostr = ref.read(nostrServiceProvider);
    await nostr?.sendText(currentUserId, text);
  }

  // ========= APPEND =========
  Future<void> _append(ChatMessage message) async {
    final current = state.value ?? [];

    if (current.any((m) => m.id == message.id)) return;

    final updated = [...current, message];

    // Cap at 200 messages
    final capped = updated.length > AppConstants.chatMaxMessages
        ? updated.sublist(updated.length - AppConstants.chatMaxMessages)
        : updated;

    state = AsyncData(capped);
    await _persist(capped);
  }

  // ========= APPEND INCOMING =========
  Future<void> appendIncoming(ChatMessage message) async {
    await _append(message);
    await ref
        .read(contactsProvider.notifier)
        .updateLastMessage(currentUserId, message.content);
  }

  // ========== NOSTR SERVICE PROVIDER ==========
  final nostrServiceProvider = Provider<NostrDMService?>((ref) {
    final identity = ref.watch(identityProvider).value;
    if (identity == null) return null;
    if (identity.nostrPrivKeyHex == 'pending') return null;

    final service = NostrDMService(
      myPrivKeyHex: identity.nostrPrivKeyHex,
      myPubKeyHex: identity.nostrPubKeyHex,
    );

    // Connect when created, disconnect when disposed
    service.connect();
    ref.onDispose(service.dispose);

    return service;
  });

  // ========= PERSIST =========
  Future<void> _persist(List<ChatMessage> msg) => PrefStore.instance.setString(
    AppConstants.keyChatWith(currentUserId),
    jsonEncode(msg.map((c) => c.toJson()).toList()),
  );
}
