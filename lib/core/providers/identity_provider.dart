/*
* Created by Connel Asikong on 31/03/2026
*
*/

// identity_provider

// ── Providers ────────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/identity.dart';

/// The root identity provider. AsyncValue<IdentityState?>.
/// null  = no account exists yet (show onboarding)
/// data  = authenticated identity
final identityProvider =
    AsyncNotifierProvider<IdentityNotifier, IdentityState?>(
      IdentityNotifier.new,
    );

// ── Notifier ─────────────────────────────────────────────────────────────────

class IdentityNotifier extends AsyncNotifier<IdentityState?> {
  @override
  Future<IdentityState?> build() async {
    // On cold start: check if we already have keys stored
    return null;
  }
}
