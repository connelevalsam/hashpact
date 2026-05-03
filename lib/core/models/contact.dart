/*
* Created by Connel Asikong on 31/03/2026
*
*/

//contact

class DummyContact {
  const DummyContact({
    required this.name,
    required this.pubKey,
    this.lastMessage,
    this.lastMessageAt,
  });

  final String name;
  final String pubKey;
  final String? lastMessage;
  final DateTime? lastMessageAt;
}

final dummyContacts = [
  DummyContact(
    name: 'Alice',
    pubKey: 'a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2',
    lastMessage: 'Sure, let me check the rate first.',
    lastMessageAt: DateTime.now().subtract(const Duration(minutes: 4)),
  ),
  DummyContact(
    name: 'Bob',
    pubKey: 'b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3',
    lastMessage: '0.5 SUI for 0.0005 BTC — deal?',
    lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  DummyContact(
    name: 'Charlie',
    pubKey: 'c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4',
    lastMessage: 'Swap completed ✓',
    lastMessageAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
