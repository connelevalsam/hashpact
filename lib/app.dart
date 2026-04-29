/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hashpact/presentation/screens/auth/welcome_screen.dart';
import 'package:hashpact/presentation/screens/auth/zklogin_screen.dart';
import 'package:hashpact/presentation/screens/intro_screen.dart';

import 'core/providers/identity_provider.dart';
import 'core/util/hashpact_theme.dart';
import 'presentation/screens/auth/pin_setup_screen.dart';
import 'presentation/screens/auth/seed_generate_screen.dart';
import 'presentation/screens/auth/seed_verify_screen.dart';
import 'presentation/screens/dashboard/chat/chat_screen.dart';
import 'presentation/screens/dashboard/chat/contacts_screen.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';
import 'presentation/screens/dashboard/profile/history_screen.dart';
import 'presentation/screens/dashboard/profile/profile_screen.dart';
import 'presentation/screens/splash_screen.dart';

// ── Route paths ─────────────────────────────────────────────────────────────

abstract class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const seedGenerate = '/seed/generate';
  static const seedVerify = '/seed/verify';
  static const pinSetup = '/pin/setup';
  static const zkLogin = '/zklogin';
  static const pinLock = '/pin/lock';
  static const dashboard = '/dashboard';
  static const onboarding = '/onboarding';
  static const contacts = '/contacts';
  static const chat = '/chat/:pubkey';
  static const profile = '/profile';
  static const history = '/history';
}

// ── Router provider ─────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final identityAsync = ref.watch(identityProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      // Still loading — don't redirect yet
      if (identityAsync.isLoading) return null;

      final identity = identityAsync.value;
      final onAuthRoute =
          state.matchedLocation == AppRoutes.splash ||
          state.matchedLocation.startsWith('/onboarding') ||
          state.matchedLocation.startsWith('/welcome') ||
          state.matchedLocation.startsWith('/seed') ||
          state.matchedLocation.startsWith('/zklogin') ||
          state.matchedLocation.startsWith('/pin/setup');

      // No account at all → onboarding
      if (identity == null &&
          !onAuthRoute &&
          state.matchedLocation != AppRoutes.pinLock) {
        return AppRoutes.splash;
      }

      return null;
    },
    routes: [
      // ── Onboarding ──────────────────────────────────────────────
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const IntroScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, __) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.seedGenerate,
        builder: (_, __) => const SeedGenerateScreen(),
      ),
      GoRoute(
        path: AppRoutes.seedVerify,
        builder: (_, __) => const SeedVerifyScreen(),
      ),
      GoRoute(
        path: AppRoutes.pinSetup,
        builder: (_, __) => const PinSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.zkLogin,
        builder: (_, __) => const ZkloginScreen(),
      ),
      GoRoute(
        path: AppRoutes.pinLock,
        builder: (_, __) => const PinSetupScreen(),
      ),

      // ── Main app ────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (_, __) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.contacts,
        builder: (_, __) => const ContactsScreen(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (_, state) =>
            ChatScreen(peerPubKey: state.pathParameters['pubkey']!),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (_, __) => const HistoryScreen(),
      ),
    ],
  );
});

// ── Root app widget ─────────────────────────────────────────────────────────

class HashPact extends ConsumerWidget {
  const HashPact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Hashpact',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
