/*
* Created by Connel Asikong on 31/03/2026
*
*/

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
