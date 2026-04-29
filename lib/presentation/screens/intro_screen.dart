/*
* Created by Connel Asikong on 29/04/2026
*
*/

import 'package:cb_intros/cb_intros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hashpact/app.dart';
import 'package:hashpact/core/util/hashpact_theme.dart';
import 'package:hugeicons/hugeicons.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final List<Widget> bgDisplay = [
    HugeIcon(
      icon: HugeIcons.strokeRoundedCoinsSwap,
      size: 200,
      color: AppColors.primary,
    ),

    HugeIcon(
      icon: HugeIcons.strokeRoundedShieldBlockchain,
      size: 200,
      color: AppColors.primary,
    ),

    HugeIcon(
      icon: HugeIcons.strokeRoundedKey01,
      size: 200,
      color: AppColors.primary,
    ),
  ];

  final List<String> title = [
    "Chat and swap.",
    "Trustless by design.",
    "Your keys. Your funds.",
  ];
  final List<String> desc = [
    "Find a counterparty, agree on terms, and execute a swap — all inside a single encrypted chat.",
    "Funds lock on-chain via HTLC. Both sides complete or both sides refund. No escrow, no middlemen.",
    "Your seed phrase never leaves your device. No KYC. No accounts. Just cryptography.",
  ];
  final List<Color> colors = [Colors.black, Colors.black87, Colors.black54];

  final List<List<Effect>> animationEffects = [
    [
      const TintEffect(
        delay: Duration(seconds: 1),
        duration: Duration(seconds: 1),
        begin: 0.9,
        end: 0,
      ),
    ],
    [
      const FadeEffect(
        delay: Duration(seconds: 1),
        curve: Curves.easeInOutCubic,
      ),
    ],
    [
      const BlurEffect(
        delay: Duration(seconds: 1),
        begin: Offset.zero,
        end: Offset(10, 10),
      ),
    ],
  ];

  Future<void> moveToNextScreen() async {
    // await StorageService().saveKey(StorageKeys.onboardingComplete, 'true');
    if (mounted) context.go(AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CbIntros(
        items: bgDisplay,
        colors: colors,
        titles: title,
        desc: desc,
        moveToNextScreen: moveToNextScreen,
        boxHeight: 300,
        appPadding: AppSpacing.lg,
        btnColor: Theme.of(context).colorScheme.surfaceTint,
        boxColor: AppColors.primaryDim,
        titleContainer: (BuildContext context, String content) {
          return Text(
            content,
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          );
        },
        descContainer: (BuildContext context, String content) {
          return Text(
            content,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          );
        },
        animationEffects: animationEffects,
      ),
    );
  }
}
