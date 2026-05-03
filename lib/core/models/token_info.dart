/*
* Created by Connel Asikong on 31/03/2026
*
*/

// lib/core/models/token_info.dart

import 'package:flutter/material.dart';

enum Chain { sui, bitcoin }

class TokenInfo {
  const TokenInfo({
    required this.id,
    required this.symbol,
    required this.name,
    required this.chain,
    required this.emoji,
    required this.color,
    required this.bgColor,
    required this.decimals,
    this.coinType,
    this.testnetCoinType,
  });

  final String id;
  final String symbol;
  final String name;
  final Chain chain;
  final String emoji;
  final Color color;
  final Color bgColor;
  final int decimals;
  final String? coinType;
  final String? testnetCoinType;

  bool get isSui => chain == Chain.sui;
  bool get isBitcoin => chain == Chain.bitcoin;
}

abstract class TokenRegistry {
  static const sui = TokenInfo(
    id: 'SUI',
    symbol: 'SUI',
    name: 'SUI',
    chain: Chain.sui,
    emoji: '💧',
    color: Color(0xFF4DA2FF),
    bgColor: Color(0xFF0E1C33),
    decimals: 9,
    coinType: '0x2::sui::SUI',
    testnetCoinType: '0x2::sui::SUI',
  );

  static const usdc = TokenInfo(
    id: 'USDC',
    symbol: 'USDC',
    name: 'USD Coin',
    chain: Chain.sui,
    emoji: '🔵',
    color: Color(0xFF2775CA),
    bgColor: Color(0xFF0A1726),
    decimals: 6,
    coinType:
        '0x5d4b302506645c37ff133b98c4b50a5ae14841659738d6d733d59d0d217a93bf::coin::COIN',
    testnetCoinType:
        '0x5d4b302506645c37ff133b98c4b50a5ae14841659738d6d733d59d0d217a93bf::coin::COIN',
  );

  static const usdt = TokenInfo(
    id: 'USDT',
    symbol: 'USDT',
    name: 'Tether USD',
    chain: Chain.sui,
    emoji: '🟢',
    color: Color(0xFF26A17B),
    bgColor: Color(0xFF0A1A16),
    decimals: 6,
    coinType:
        '0xc060006111016b8a020ad5b33834984a437aaa7d3c74c18e09a95d48aceab08c::coin::COIN',
    testnetCoinType:
        '0xc060006111016b8a020ad5b33834984a437aaa7d3c74c18e09a95d48aceab08c::coin::COIN',
  );

  static const btc = TokenInfo(
    id: 'BTC',
    symbol: 'BTC',
    name: 'Bitcoin',
    chain: Chain.bitcoin,
    emoji: '₿',
    color: Color(0xFFF7931A),
    bgColor: Color(0xFF1A1208),
    decimals: 8,
  );

  static const List<TokenInfo> all = [sui, usdc, usdt, btc];
  static List<TokenInfo> get suiTokens => all.where((t) => t.isSui).toList();
  static TokenInfo byId(String id) => all.firstWhere((t) => t.id == id);
}
