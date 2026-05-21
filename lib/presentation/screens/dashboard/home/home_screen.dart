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
import '../../../../core/models/token_info.dart';
import '../../../../core/util/hashpact_theme.dart';
import '../../../providers/balance_provider.dart';
import '../../../providers/identity_provider.dart';
import 'widgets/header.dart';
import 'widgets/porfolio_total.dart';
import 'widgets/secondary_token_row.dart';
import 'widgets/token_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(identityProvider).value;
    final balanceAsync = ref.watch(balanceProvider);
    final privacyMode = ref.watch(privacyModeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: () => ref.read(balanceProvider.notifier).refresh(),
          child: CustomScrollView(
            slivers: [
              // ── Header ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Header(
                    npub: identity?.npubDisplay ?? '',
                    privacyMode: privacyMode,
                    onPrivacyToggle: () =>
                        ref.read(privacyModeProvider.notifier).toggle(),
                    onProfileTap: () => context.go(AppRoutes.profile),
                  ),
                ).animate().fadeIn(duration: 400.ms),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

              // ── Portfolio total ─────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.pagePadding,
                  child: PortfolioTotal(
                    balanceAsync: balanceAsync,
                    privacyMode: privacyMode,
                  ),
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

              // ── Token cards ─────────────────────────────────
              SliverPadding(
                padding: AppSpacing.pagePadding,
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    TokenCard(
                          token: TokenRegistry.sui,
                          balance: balanceAsync.value?['SUI'] ?? BigInt.zero,
                          privacyMode: privacyMode,
                        )
                        .animate()
                        .fadeIn(delay: 150.ms, duration: 400.ms)
                        .slideY(
                          begin: 0.1,
                          end: 0,
                          delay: 150.ms,
                          duration: 400.ms,
                        ),

                    const SizedBox(height: AppSpacing.sm),

                    TokenCard(
                          token: TokenRegistry.btc,
                          balance: balanceAsync.value?['BTC'] ?? BigInt.zero,
                          privacyMode: privacyMode,
                        )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms)
                        .slideY(
                          begin: 0.1,
                          end: 0,
                          delay: 200.ms,
                          duration: 400.ms,
                        ),

                    const SizedBox(height: AppSpacing.sm),

                    SecondaryTokenRow(
                      balances: balanceAsync.value ?? {},
                      privacyMode: privacyMode,
                    ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

                    const SizedBox(height: AppSpacing.xl),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),

      // ── FAB ─────────────────────────────────────────────────
      floatingActionButton:
          FloatingActionButton.extended(
                onPressed: () => context.go(AppRoutes.contacts),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCoinsSwap,
                  color: Colors.white,
                  size: 22,
                ),
                label: Text(
                  'New swap',
                  style: AppTextStyles.buttonText.copyWith(color: Colors.white),
                ),
              )
              .animate()
              .fadeIn(delay: 400.ms, duration: 400.ms)
              .slideY(begin: 0.3, end: 0, delay: 400.ms, duration: 400.ms),
    );
  }
}
