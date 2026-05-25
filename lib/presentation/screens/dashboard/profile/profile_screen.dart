/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app.dart';
import '../../../../core/util/hashpact_theme.dart';
import '../../../providers/balance_provider.dart';
import '../../../providers/identity_provider.dart';
import 'widgets/identity_card.dart';
import 'widgets/settings_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(identityProvider).value;
    final npub = identity?.npubDisplay ?? '—';
    final suiAddress = identity?.suiAddress ?? '—';
    final authType = identity?.isSeed == true ? 'Seed phrase' : 'zkLogin';
    var _privacyMode = ref.watch(privacyModeProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACCOUNT',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('Profile', style: AppTextStyles.heading2),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            // ── Identity card ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.pagePadding,
                child: IdentityCard(
                  npub: npub,
                  suiAddress: suiAddress,
                  authType: authType,
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            // ── Settings sections ──────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Security section
                    _sectionLabel(label: 'Security'),
                    const SizedBox(height: AppSpacing.sm),
                    SettingsTile(
                      icon: HugeIcons.strokeRoundedLockPassword,
                      label: 'Change PIN',
                      onTap: () {
                        // TODO: navigate to change PIN
                      },
                    ),
                    SettingsTile(
                      icon: HugeIcons.strokeRoundedFingerAccess,
                      label: 'Biometric unlock',
                      trailing: Switch(
                        value: false,
                        onChanged: (_) {},
                        activeThumbColor: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Preferences section
                    _sectionLabel(label: 'Preferences'),
                    const SizedBox(height: AppSpacing.sm),
                    SettingsTile(
                      icon: HugeIcons.strokeRoundedScanEye,
                      label: 'Privacy mode',
                      trailing: Switch(
                        value: _privacyMode,
                        onChanged: (v) {
                          ref.read(privacyModeProvider.notifier).toggle();
                        },
                        activeThumbColor: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // History section
                    _sectionLabel(label: 'Activity'),
                    const SizedBox(height: AppSpacing.sm),
                    SettingsTile(
                      icon: HugeIcons.strokeRoundedClock01,
                      label: 'Swap history',
                      showArrow: true,
                      onTap: () => context.push(AppRoutes.history),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Danger zone
                    _sectionLabel(label: 'Danger zone'),
                    const SizedBox(height: AppSpacing.sm),
                    SettingsTile(
                      icon: HugeIcons.strokeRoundedLogout01,
                      label: 'Lock app',
                      iconColor: AppColors.warning,
                      onTap: () {
                        // TODO: lock via identity provider
                      },
                    ),
                    SettingsTile(
                      icon: HugeIcons.strokeRoundedDelete02,
                      label: 'Wipe and reset',
                      iconColor: AppColors.danger,
                      labelColor: AppColors.danger,
                      onTap: () => _confirmWipe(context),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Version tag
                    Center(
                      child: Text(
                        'Hashpact v1.0.0 · Testnet',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmWipe(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.md,
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text('Wipe and reset?', style: AppTextStyles.heading3),
        content: Text(
          'This will delete all keys and data from this device. '
          'Make sure you have your seed phrase before continuing.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.pop();
              // TODO: wipe via identity provider
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Wipe'),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel({required String label}) {
    return Text(
      label.toUpperCase(),
      style: AppTextStyles.label.copyWith(
        color: AppColors.textMuted,
        letterSpacing: 1.2,
      ),
    );
  }
}
