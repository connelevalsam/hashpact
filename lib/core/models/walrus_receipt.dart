/*
* Created by Connel Asikong on 31/03/2026
*
*/

// Proof-of-swap written to Walrus at completion.
// Both Alice and Bob write their own receipt independently.
// The blobId is stored locally and can retrieve the receipt
// without trusting the counterparty.

import 'package:equatable/equatable.dart';

class WalrusReceipt extends Equatable {
  const WalrusReceipt({
    required this.swapId,
    required this.blobId,
    required this.sendTokenId,
    required this.receiveTokenId,
    required this.sendAmount,
    required this.receiveAmount,
    required this.initiatorSuiAddress,
    required this.counterSuiAddress,
    required this.completedAt,
    this.initiatorTxHash,
    this.counterTxHash,
  });

  final String swapId;
  final String blobId;
  final String sendTokenId;
  final String receiveTokenId;
  final BigInt sendAmount;
  final BigInt receiveAmount;
  final String initiatorSuiAddress;
  final String counterSuiAddress;
  final DateTime completedAt;
  final String? initiatorTxHash;
  final String? counterTxHash;

  Map<String, dynamic> toJson() => {
    'swapId': swapId,
    'blobId': blobId,
    'sendTokenId': sendTokenId,
    'receiveTokenId': receiveTokenId,
    'sendAmount': sendAmount.toString(),
    'receiveAmount': receiveAmount.toString(),
    'initiatorSuiAddress': initiatorSuiAddress,
    'counterSuiAddress': counterSuiAddress,
    'completedAt': completedAt.millisecondsSinceEpoch,
    'initiatorTxHash': initiatorTxHash,
    'counterTxHash': counterTxHash,
  };

  factory WalrusReceipt.fromJson(Map<String, dynamic> json) => WalrusReceipt(
    swapId: json['swapId'] as String,
    blobId: json['blobId'] as String,
    sendTokenId: json['sendTokenId'] as String,
    receiveTokenId: json['receiveTokenId'] as String,
    sendAmount: BigInt.parse(json['sendAmount'] as String),
    receiveAmount: BigInt.parse(json['receiveAmount'] as String),
    initiatorSuiAddress: json['initiatorSuiAddress'] as String,
    counterSuiAddress: json['counterSuiAddress'] as String,
    completedAt: DateTime.fromMillisecondsSinceEpoch(
      json['completedAt'] as int,
    ),
    initiatorTxHash: json['initiatorTxHash'] as String?,
    counterTxHash: json['counterTxHash'] as String?,
  );

  @override
  List<Object?> get props => [swapId, blobId, completedAt];
}
