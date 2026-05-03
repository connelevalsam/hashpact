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
import 'presentation/screens/auth/pin_lock_screen.dart';
import 'presentation/screens/auth/pin_setup_screen.dart';
import 'presentation/screens/auth/seed_generate_screen.dart';
import 'presentation/screens/auth/seed_verify_screen.dart';
import 'presentation/screens/dashboard/chat/chat_screen.dart';
import 'presentation/screens/dashboard/chat/contacts_screen.dart';
import 'presentation/screens/dashboard/dashboard.dart';
import 'presentation/screens/dashboard/home/home_screen.dart';
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
  static const onboarding = '/onboarding';

  static const home = '/dashboard';
  static const contacts = '/dashboard/contacts';
  static const chat = '/dashboard/contacts/:pubkey';
  static const profile = '/dashboard/profile';
  static const history = '/dashboard/profile/history';

  // chatWith helper
  static String chatWith(String pubkey) => '/dashboard/contacts/$pubkey';
}

// ── Router provider ─────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.read(identityProvider.notifier);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _IdentityListenable(ref),
    redirect: (context, state) {
      final identityAsync = ref.read(identityProvider);
      // Still loading — don't redirect yet
      if (identityAsync.isLoading) return null;

      final identity = identityAsync.value;
      final local = state.matchedLocation;

      if (local == AppRoutes.splash) return null;

      final isPublicRoute =
          local == AppRoutes.splash ||
          local.startsWith('/onboarding') ||
          local.startsWith('/welcome') ||
          local.startsWith('/seed') ||
          local.startsWith('/zklogin') ||
          local.startsWith('/pin');

      // Has account + trying to access public route → send home
      if (identity != null && isPublicRoute && local != AppRoutes.pinLock) {
        return AppRoutes.home;
      }

      // No account + trying to access protected route → send to splash
      if (identity == null && !isPublicRoute) {
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
        path: AppRoutes.pinLock,
        builder: (_, __) => const PinLockScreen(),
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
      ShellRoute(
        builder: (context, state, child) => Dashboard(child: child),
        routes: [
          GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
          GoRoute(
            path: AppRoutes.contacts,
            builder: (_, __) => const ContactsScreen(),
            routes: [
              GoRoute(
                path: ':pubkey',
                builder: (_, state) =>
                    ChatScreen(peerPubKey: state.pathParameters['pubkey']!),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, __) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'history',
                builder: (_, __) => const HistoryScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _IdentityListenable extends ChangeNotifier {
  _IdentityListenable(Ref ref) {
    ref.listen(identityProvider, (_, __) => notifyListeners());
  }
}

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
