/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/contact.dart';
import '../../core/storage/local_storage.dart';
import '../../core/util/app_constant.dart';

final contactsProvider = AsyncNotifierProvider<ContactsNotifier, List<Contact>>(
  ContactsNotifier.new,
);

class ContactsNotifier extends AsyncNotifier<List<Contact>> {
  @override
  FutureOr<List<Contact>> build() async {
    return await _load();
  }

  // ========= LOAD =========
  Future<List<Contact>> _load() async {
    final raw = await PrefStore.instance.getString(AppConstants.keyContacts);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => Contact.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ========= ADD CONTACT =========
  Future<void> addContact(String pubKeyHex, String displayName) async {
    final currentMessage = state.value ?? [];

    // ======== Don't add duplicates =========
    if (currentMessage.any((current) => current.nostrPubKeyHex == pubKeyHex))
      return;

    final updated = [
      ...currentMessage,
      Contact(nostrPubKeyHex: pubKeyHex, displayName: displayName),
    ];

    state = AsyncData(updated);
    await _persist(updated);
  }

  // ========= UPDATE LAST MESSAGE =========
  Future<void> updateLastMessage(String pubKeyHex, String message) async {
    final current = state.value ?? [];
    final updated = current.map((data) {
      if (data.nostrPubKeyHex != pubKeyHex) return data;
      return data.copyWith(lastMessage: message, lastMessageAt: DateTime.now());
    }).toList();

    state = AsyncData(updated);
    await _persist(updated);
  }

  // ========= REMOVE CONTACT =========
  Future<void> removeContact(String pubKeyHex) async {
    final current = state.value ?? [];
    final updated = current
        .where((data) => data.nostrPubKeyHex != pubKeyHex)
        .toList();
    state = AsyncData(updated);
    await _persist(updated);
  }

  // ========= FIND BY PUBKEY =========
  Contact? findByPubKey(String pubKeyHex) {
    return state.value?.firstWhere(
      (c) => c.nostrPubKeyHex == pubKeyHex,
      orElse: () =>
          Contact(nostrPubKeyHex: pubKeyHex, displayName: _truncate(pubKeyHex)),
    );
  }

  // ========= TRUNCATE =========
  String _truncate(String key) =>
      '${key.substring(0, 8)}...${key.substring(key.length - 8)}';

  // ========= PERSIST =========
  Future<void> _persist(List<Contact> contacts) => PrefStore.instance.setString(
    AppConstants.keyContacts,
    jsonEncode(contacts.map((c) => c.toJson()).toList()),
  );
}

/*
final contactsProvider = AsyncNotifierProvider<ContactsNotifier, List<Contact>>(
  ContactsNotifier.new,
);

class ContactsNotifier extends AsyncNotifier<List<Contact>> {
  @override
  Future<List<Contact>> build() async {
    final raw = await PrefStore.instance.getString(AppConstants.keyContacts);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => Contact.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addContact(String pubKeyHex, String displayName) async {
    final current = state.value ?? [];

    // Don't add duplicates
    if (current.any((c) => c.nostrPubKeyHex == pubKeyHex)) return;

    final updated = [
      ...current,
      Contact(nostrPubKeyHex: pubKeyHex, displayName: displayName),
    ];

    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> updateLastMessage(String pubKeyHex, String message) async {
    final current = state.value ?? [];
    final updated = current.map((c) {
      if (c.nostrPubKeyHex != pubKeyHex) return c;
      return c.copyWith(lastMessage: message, lastMessageAt: DateTime.now());
    }).toList();

    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> removeContact(String pubKeyHex) async {
    final updated = (state.value ?? [])
        .where((c) => c.nostrPubKeyHex != pubKeyHex)
        .toList();
    state = AsyncData(updated);
    await _persist(updated);
  }

  Future<void> _persist(List<Contact> contacts) => PrefStore.instance.setString(
    AppConstants.keyContacts,
    jsonEncode(contacts.map((c) => c.toJson()).toList()),
  );
}
*/
