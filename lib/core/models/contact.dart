/*
* Created by Connel Asikong on 31/03/2026
*
*/

//contact

import 'package:equatable/equatable.dart';

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

// Real Data

class Contact extends Equatable {
  const Contact({
    required this.displayName,
    required this.nostrPubKeyHex,
    this.lastMessage,
    this.lastMessageAt,
  });

  final String displayName;
  final String nostrPubKeyHex;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  Contact copyWith({
    String? displayName,
    String? nostrPubKeyHex,
    String? lastMessage,
    DateTime? lastMessageAt,
  }) {
    return Contact(
      displayName: displayName ?? this.displayName,
      nostrPubKeyHex: nostrPubKeyHex ?? this.nostrPubKeyHex,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }

  // JSON — stored in SharedPreferences
  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'nostrPubKeyHex': nostrPubKeyHex,
    'lastMessage': lastMessage,
    'lastMessageAt': lastMessageAt?.toIso8601String(),
  };

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    displayName: json['displayName'] as String,
    nostrPubKeyHex: json['nostrPubKeyHex'] as String,
    lastMessage: json['lastMessage'] as String?,
    lastMessageAt: json['lastMessageAt'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['lastMessageAt'] as int)
        : null,
  );

  @override
  List<Object?> get props => [
    displayName,
    nostrPubKeyHex,
    lastMessage,
    lastMessageAt,
  ];
}
