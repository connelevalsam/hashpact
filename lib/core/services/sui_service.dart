/*
* Created by Connel Asikong on 31/03/2026
*
*/

// sui_service

import 'dart:convert';

import 'package:http/http.dart' as http;

class SuiService {
  SuiService({this.useTestnet = true});

  final bool useTestnet;

  String get _rpcUrl => useTestnet
      ? 'https://fullnode.testnet.sui.io'
      : 'https://fullnode.mainnet.sui.io';

  // Fetch SUI balance in MIST (1 SUI = 1_000_000_000 MIST)
  Future<BigInt> getSuiBalance(String address) async {
    try {
      final response = await http.post(
        Uri.parse(_rpcUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'suix_getBalance',
          'params': [address, '0x2::sui::SUI'],
        }),
      );

      if (response.statusCode != 200) return BigInt.zero;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['result'] as Map<String, dynamic>?;
      if (result == null) return BigInt.zero;

      return BigInt.parse(result['totalBalance'] as String);
    } catch (_) {
      return BigInt.zero;
    }
  }

  // Fetch any coin type balance
  Future<BigInt> getCoinBalance(String address, String coinType) async {
    try {
      final response = await http.post(
        Uri.parse(_rpcUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'suix_getBalance',
          'params': [address, coinType],
        }),
      );

      if (response.statusCode != 200) return BigInt.zero;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['result'] as Map<String, dynamic>?;
      if (result == null) return BigInt.zero;

      return BigInt.parse(result['totalBalance'] as String);
    } catch (_) {
      return BigInt.zero;
    }
  }
}
