/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../app.dart';
import '../../../core/util/hashpact_theme.dart';

// ─────────────────────────────────────────────────────────────
// NAV INDEX PROVIDER
// ─────────────────────────────────────────────────────────────

class _NavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final navIndexProvider = NotifierProvider<_NavIndexNotifier, int>(
  _NavIndexNotifier.new,
);

// ─────────────────────────────────────────────────────────────
// NAV TAB MODEL
// ─────────────────────────────────────────────────────────────

class _NavTab {
  const _NavTab({required this.label, required this.icon, required this.route});

  final String label;
  final List<List<dynamic>> icon;
  final String route;
}

// ─────────────────────────────────────────────────────────────
// DASHBOARD SHELL
// ─────────────────────────────────────────────────────────────

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _NavTab(
      label: 'Home',
      icon: HugeIcons.strokeRoundedHome01,
      route: AppRoutes.home,
    ),
    _NavTab(
      label: 'Contacts',
      icon: HugeIcons.strokeRoundedMessageMultiple01,
      route: AppRoutes.contacts,
    ),
    _NavTab(
      label: 'Profile',
      icon: HugeIcons.strokeRoundedUser,
      route: AppRoutes.profile,
    ),
  ];

  int _locationToIndex(String location) {
    if (location.startsWith(AppRoutes.contacts)) return 1;
    if (location.startsWith(AppRoutes.profile)) return 2;
    return 0;
  }

  void _onTabTap(BuildContext context, WidgetRef ref, int index) {
    ref.read(navIndexProvider.notifier).setIndex(index);
    context.go(_tabs[index].route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sync index from actual route location
    // so back button and programmatic navigation stay in sync
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _locationToIndex(location);

    final isWide = MediaQuery.sizeOf(context).width >= 600;

    if (isWide) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Row(
          children: [
            // ── Navigation Rail ──────────────────────────────
            NavigationRail(
              backgroundColor: AppColors.surface,
              selectedIndex: currentIndex,
              onDestinationSelected: (i) => _onTabTap(context, ref, i),
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: const IconThemeData(color: AppColors.primary),
              unselectedIconTheme: const IconThemeData(
                color: AppColors.textMuted,
              ),
              selectedLabelTextStyle: AppTextStyles.label.copyWith(
                color: AppColors.primary,
              ),
              unselectedLabelTextStyle: AppTextStyles.label.copyWith(
                color: AppColors.textMuted,
              ),
              indicatorColor: AppColors.primaryDim,
              leading: const SizedBox(height: AppSpacing.md),
              destinations: _tabs
                  .map(
                    (tab) => NavigationRailDestination(
                      icon: HugeIcon(
                        icon: tab.icon,
                        color: AppColors.textMuted,
                        size: 22,
                      ),
                      selectedIcon: HugeIcon(
                        icon: tab.icon,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      label: Text(tab.label),
                    ),
                  )
                  .toList(),
            ),

            const VerticalDivider(width: 1, color: AppColors.border),

            Expanded(child: child),
          ],
        ),
      );
    }

    // ── Bottom Navigation Bar (mobile) ───────────────────────
    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: _BottomNav(
        currentIndex: currentIndex,
        tabs: _tabs,
        onTap: (i) => _onTabTap(context, ref, i),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BOTTOM NAV
// ─────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
  });

  final int currentIndex;
  final List<_NavTab> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: tabs.asMap().entries.map((entry) {
              final i = entry.key;
              final tab = entry.value;
              final selected = i == currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: HugeIcon(
                          key: ValueKey(selected),
                          icon: tab.icon,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textMuted,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tab.label,
                        style: AppTextStyles.label.copyWith(
                          color: selected
                              ? AppColors.primary
                              : AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
