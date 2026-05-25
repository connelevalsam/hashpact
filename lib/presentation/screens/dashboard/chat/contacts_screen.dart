/*
* Created by Connel Asikong on 31/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hashpact/core/models/contact.dart';
import 'package:hashpact/presentation/screens/dashboard/chat/widgets/add_contact_sheet.dart';
import 'package:hashpact/presentation/screens/dashboard/chat/widgets/contact_tile_widget.dart';
import 'package:hashpact/presentation/screens/dashboard/chat/widgets/empty_state_widget.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../app.dart';
import '../../../../core/util/hashpact_theme.dart';
import '../../../providers/contacts_provider.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ContactsScreenState createState() => ContactsScreenState();
}

class ContactsScreenState extends ConsumerState<ContactsScreen> {
  final _txtSearchController = TextEditingController();

  List<Contact> get _filtered {
    final contacts = ref.watch(contactsProvider).value ?? [];
    final _search = _txtSearchController.text.trim();
    return contacts.where((contact) {
      return contact.displayName.toLowerCase().contains(_search.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final _contacts = ref.watch(contactsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MESSAGES',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textMuted,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text('Contacts', style: AppTextStyles.heading2),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showAddContact(context, ref),
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedUserAdd01,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: AppSpacing.md),

            // ── Search bar ──────────────────────────────────────
            Padding(
              padding: AppSpacing.pagePadding,
              child: TextField(
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedSearch01,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ),
                ),
                onChanged: (val) => _filtered,
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

            const SizedBox(height: AppSpacing.md),

            // ── List ──────────────────────────────────────────
            Expanded(
              child: _contacts.when(
                data: (contacts) => contacts.isNotEmpty
                    ? ListView.builder(
                        padding: AppSpacing.pagePadding,
                        itemCount: _contacts.value?.length,
                        itemBuilder: (_, i) {
                          final c = _contacts.value?[i];
                          return ContactTileWidget(
                                contact: c!,
                                onTap: () => context.push(
                                  AppRoutes.chatWith(c.nostrPubKeyHex),
                                ),
                              )
                              .animate()
                              .fadeIn(
                                delay: Duration(milliseconds: 60 * i),
                                duration: 300.ms,
                              )
                              .slideX(
                                begin: 0.05,
                                end: 0,
                                delay: Duration(milliseconds: 60 * i),
                                duration: 300.ms,
                              );
                        },
                      )
                    : EmptyStateWidget(
                        onAddTap: () => _showAddContact(context, ref),
                      ),
                error: (error, _) => Text(error.toString()),
                loading: () => CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContact(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddContactSheet(ref: ref),
    );
  }
}
