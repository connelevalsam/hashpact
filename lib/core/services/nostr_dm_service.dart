/*
* Created by Connel Asikong on 31/03/2026
*
*/

// nostr_dm_service

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:nostr/nostr.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../util/app_constant.dart';

class IncomingDm {
  const IncomingDm({
    required this.fromPubKeyHex,
    required this.toPubKeyHex,
    required this.decryptedContent,
    required this.createdAt,
    required this.eventId,
  });

  final String fromPubKeyHex;
  final String toPubKeyHex;
  final String decryptedContent;
  final DateTime createdAt;
  final String eventId;

  // Returns parsed map if this is a Hashpact typed message
  // Returns null if it's plain text
  Map<String, dynamic>? get parsedPayload {
    try {
      final decoded = jsonDecode(decryptedContent);
      if (decoded is Map<String, dynamic> && decoded.containsKey('type')) {
        return decoded;
      }
    } catch (_) {}
    return null;
  }
}

class NostrDMService {
  NostrDMService({required this.myPrivKeyHex, required this.myPubKeyHex});

  final String myPrivKeyHex;
  final String myPubKeyHex;

  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  bool _disposed = false;

  final _dmController = StreamController<IncomingDm>.broadcast();
  Stream<IncomingDm> get dmStream => _dmController.stream;

  Future<void> connect() async {
    if (_disposed) return;
    try {
      _channel = WebSocketChannel.connect(Uri.parse(AppConstants.nostrRelay));
      _sub = _channel!.stream.listen(
        _onMessage,
        onError: (_) => _scheduleReconnect(),
        onDone: _scheduleReconnect,
      );
      _sendSubscription();
      _reconnectAttempts = 0;
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _sub?.cancel();
    _channel?.sink.close();
  }

  void dispose() {
    _disposed = true;
    disconnect();
    _dmController.close();
  }

  // ── Send plain text DM ────────────────────────────────────

  Future<void> sendText(String toPubKeyHex, String text) async {
    await _sendEncrypted(toPubKeyHex, text);
  }

  // ── Send typed Hashpact payload ───────────────────────────

  Future<void> sendPayload(
    String toPubKeyHex,
    Map<String, dynamic> payload,
  ) async {
    await _sendEncrypted(toPubKeyHex, jsonEncode(payload));
  }

  Future<void> _sendEncrypted(String toPubKeyHex, String content) async {
    try {
      final keychain = Keychain(myPrivKeyHex);
      final encrypted = keychain.encrypt(content, toPubKeyHex);
      final event = Event.from(
        kind: 4,
        tags: [
          ['p', toPubKeyHex],
        ],
        content: encrypted,
        privkey: myPrivKeyHex,
      );
      _channel?.sink.add(jsonEncode(['EVENT', event.toJson()]));
    } catch (_) {}
  }

  void _sendSubscription() {
    final since =
        DateTime.now()
            .subtract(const Duration(seconds: 60))
            .millisecondsSinceEpoch ~/
        1000;

    final request = jsonEncode([
      'REQ',
      'hashpact-dms',
      {
        'kinds': [4],
        '#p': [myPubKeyHex],
        'since': since,
      },
    ]);
    _channel?.sink.add(request);
  }

  void _onMessage(dynamic raw) {
    try {
      final msg = jsonDecode(raw as String) as List<dynamic>;
      if (msg.isEmpty || msg[0] != 'EVENT') return;

      final eventJson = msg[2] as Map<String, dynamic>;
      final event = Event.fromJson(eventJson);

      // Ignore our own messages echoed back by the relay
      if (event.pubkey == myPubKeyHex) return;
      if (event.kind != 4) return;

      final keychain = Keychain(myPrivKeyHex);
      final decrypted = keychain.decrypt(event.content, event.pubkey);

      final toPubKey = event.tags
          .firstWhere(
            (t) => t.isNotEmpty && t[0] == 'p',
            orElse: () => ['p', myPubKeyHex],
          )
          .elementAt(1);

      _dmController.add(
        IncomingDm(
          fromPubKeyHex: event.pubkey,
          toPubKeyHex: toPubKey,
          decryptedContent: decrypted,
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            event.createdAt * 1000,
          ),
          eventId: event.id,
        ),
      );
    } catch (_) {
      // Silently drop malformed or undecryptable messages
    }
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    _sub?.cancel();
    _channel?.sink.close();
    final backoff = min(pow(2, _reconnectAttempts).toInt(), 60);
    _reconnectAttempts++;
    _reconnectTimer = Timer(Duration(seconds: backoff), connect);
  }
}
