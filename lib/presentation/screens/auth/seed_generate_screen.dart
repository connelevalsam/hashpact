/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hashpact/presentation/screens/auth/widgets/warning_banner_widget.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../app.dart';
import '../../../core/providers/identity_provider.dart';
import '../../../core/util/hashpact_theme.dart';
import 'widgets/word_grid_widget.dart';

class SeedGenerateScreen extends ConsumerStatefulWidget {
  const SeedGenerateScreen({super.key});

  @override
  ConsumerState<SeedGenerateScreen> createState() => _SeedGenerateScreenState();
}

class _SeedGenerateScreenState extends ConsumerState<SeedGenerateScreen> {
  List<String> _words = [];
  bool _revealed = false;
  bool _copied = false;

  @override
  void initState() {
    _generate();
    super.initState();
  }

  Future<void> _generate() async {
    final mnemonic = await ref
        .read(identityProvider.notifier)
        .generateNewMnemonic();
    if (!mounted) return;
    setState(() => _words = mnemonic.split(' '));
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _words.join(' ')));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your seed phrase'),
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: _words.isEmpty
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SafeArea(
              child: Padding(
                padding: AppSpacing.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WarningBannerWidget(
                      message:
                          'Write these words down in order and store them somewhere safe. '
                          'Anyone with these words controls your funds.',
                    ).animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: AppSpacing.lg),

                    Expanded(
                      child: WordGridWidget(
                        words: _words,
                        revealed: _revealed,
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                setState(() => _revealed = !_revealed),
                            icon: HugeIcon(
                              icon: _revealed
                                  ? HugeIcons.strokeRoundedScanEye
                                  : HugeIcons.strokeRoundedEye,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            label: Text(_revealed ? 'Hide' : 'Reveal'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _revealed ? _copyToClipboard : null,
                            icon: HugeIcon(
                              icon: _copied
                                  ? HugeIcons.strokeRoundedCheckmarkCircle01
                                  : HugeIcons.strokeRoundedCopy01,
                              color: _copied
                                  ? AppColors.success
                                  : AppColors.primary,
                              size: 18,
                            ),
                            label: Text(_copied ? 'Copied!' : 'Copy'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),
                    FilledButton(
                      onPressed: _revealed
                          ? () => context.go(AppRoutes.seedVerify)
                          : null,
                      child: const Text("I've written it down"),
                    ),

                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
    );
  }
}
