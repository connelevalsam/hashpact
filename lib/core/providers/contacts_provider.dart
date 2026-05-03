/*
* Created by Connel Asikong on 31/03/2026
*
*/

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
