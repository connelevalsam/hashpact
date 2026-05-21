/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'package:equatable/equatable.dart';

class Msg {
  const Msg({
    required this.text,
    required this.isMe,
    required this.time,
    this.isSwap = false,
  });

  final String text;
  final bool isMe;
  final DateTime time;
  final bool isSwap;
}

final dummyMessages = [
  Msg(
    text: 'Hey, want to swap 1 SUI for 0.001 BTC?',
    isMe: false,
    time: DateTime.now().subtract(const Duration(minutes: 10)),
  ),
  Msg(
    text: 'Sure, let me check the rate first.',
    isMe: true,
    time: DateTime.now().subtract(const Duration(minutes: 9)),
  ),
  Msg(
    text: 'Rate looks good to me.',
    isMe: false,
    time: DateTime.now().subtract(const Duration(minutes: 8)),
  ),
  Msg(
    text: 'Swap offer sent',
    isMe: true,
    time: DateTime.now().subtract(const Duration(minutes: 7)),
    isSwap: true,
  ),
];

// main
enum MessageType { text, swapOffer, swapStatus }

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.fromPubKeyHex,
    required this.toPubKeyHex,
    required this.type,
    required this.content,
    required this.createdAt,
    this.swapOfferId,
  });

  final String id;
  final String fromPubKeyHex;
  final String toPubKeyHex;
  final MessageType type;
  final String content; // plain text OR JSON string for swap types
  final DateTime createdAt;
  final String? swapOfferId; // set when type != text

  bool get isSwap =>
      type == MessageType.swapOffer || type == MessageType.swapStatus;

  Map<String, dynamic> toJson() => {
    'id': id,
    'fromPubKeyHex': fromPubKeyHex,
    'toPubKeyHex': toPubKeyHex,
    'type': type.name,
    'content': content,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'swapOfferId': swapOfferId,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'] as String,
    fromPubKeyHex: json['fromPubKeyHex'] as String,
    toPubKeyHex: json['toPubKeyHex'] as String,
    type: MessageType.values.byName(json['type'] as String),
    content: json['content'] as String,
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    swapOfferId: json['swapOfferId'] as String?,
  );

  @override
  List<Object?> get props => [id, type, content, createdAt];
}
