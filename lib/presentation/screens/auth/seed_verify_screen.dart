/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hashpact/presentation/screens/auth/widgets/status_banner_widget.dart';
import 'package:hashpact/presentation/screens/auth/widgets/verify_grid_widget.dart';
import 'package:hashpact/presentation/screens/auth/widgets/word_pool_widget.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../app.dart';
import '../../../core/util/hashpact_theme.dart';
import '../../providers/identity_provider.dart';

class SeedVerifyScreen extends ConsumerStatefulWidget {
  const SeedVerifyScreen({super.key});

  @override
  ConsumerState createState() => _SeedVerifyScreenState();
}

class _SeedVerifyScreenState extends ConsumerState<SeedVerifyScreen> {
  List<String> _allWords = [];
  List<int> _testPositions = [];
  final Map<int, String> _answers = {};
  List<String> _wordPool = [];

  @override
  void initState() {
    _setup();

    super.initState();
  }

  void _setup() {
    final mnemonic = ref.read(identityProvider.notifier).pendingMnemonic;

    if (mnemonic == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppRoutes.seedGenerate);
      });
      return;
    }

    _allWords = mnemonic.split(' ');

    final rng = Random.secure();
    final positions = List.generate(12, (i) => i)..shuffle(rng);
    _testPositions = positions.take(3).toList()..sort();

    final correctWords = _testPositions.map((i) => _allWords[i]).toList();
    final decoys = _allWords.where((w) => !correctWords.contains(w)).toList()
      ..shuffle(rng);
    _wordPool = [...correctWords, ...decoys.take(5)]..shuffle(rng);

    setState(() {});
  }

  bool get _allCorrect {
    if (_answers.length != _testPositions.length) return false;
    return _testPositions.every((pos) => _answers[pos] == _allWords[pos]);
  }

  int numTaps = 5;

  void _tapWord(String word) {
    // Find the first unfilled test position
    final nextEmpty = _testPositions.firstWhere(
      (pos) => !_answers.containsKey(pos),
      orElse: () => -1,
    );
    if (nextEmpty == -1) {
      numTaps--;
      if (numTaps == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go(AppRoutes.seedGenerate);
        });
        return;
      }
    }

    setState(() => _answers[nextEmpty] = word);
  }

  void _clearAnswer(int position) {
    setState(() => _answers.remove(position));
  }

  void _onContinue() {
    if (!_allCorrect) return;

    context.push(AppRoutes.pinSetup);
  }

  @override
  Widget build(BuildContext context) {
    if (_allWords.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Verify your phrase'),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Instruction ───────────────────────────────────
              Text(
                'Tap the missing words in order to confirm '
                'you\'ve saved your seed phrase.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: AppSpacing.lg),

              // ── Word grid with blanks ─────────────────────────
              VerifyGridWidget(
                allWords: _allWords,
                testPositions: _testPositions,
                answers: _answers,
                onClearAnswer: _clearAnswer,
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

              const SizedBox(height: AppSpacing.lg),

              // ── Status message ────────────────────────────────
              if (_answers.length == _testPositions.length)
                StatusBannerWidget(correct: _allCorrect)
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: 0.2, end: 0, duration: 300.ms),

              const SizedBox(height: AppSpacing.md),

              // ── Word pool ─────────────────────────────────────
              WordPoolWidget(
                words: _wordPool,
                usedWords: _answers.values.toSet(),
                onTap: _tapWord,
              ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

              const Spacer(),

              // ── Continue ──────────────────────────────────────
              FilledButton(
                onPressed: _allCorrect ? _onContinue : null,
                child: const Text('Continue'),
              ),

              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
