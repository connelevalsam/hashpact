/*
* Created by Connel Asikong on 01/05/2026
*
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/util/hashpact_theme.dart';

class AddContactSheet extends StatefulWidget {
  const AddContactSheet({super.key /*required this.ref*/});

  // final WidgetRef ref;

  @override
  State<AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContactSheet> {
  final _nameController = TextEditingController();
  final _keyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    /*await widget.ref
        .read(contactsProvider.notifier)
        .addContact(_keyController.text.trim(), _nameController.text.trim());*/

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: AppRadius.full,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text('Add contact', style: AppTextStyles.heading3),

              const SizedBox(height: AppSpacing.lg),

              // Display name
              TextFormField(
                controller: _nameController,
                style: AppTextStyles.body,
                decoration: const InputDecoration(
                  labelText: 'Display name',
                  hintText: 'e.g. Alice',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: AppSpacing.md),

              // Nostr public key
              TextFormField(
                controller: _keyController,
                style: AppTextStyles.mono.copyWith(fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Nostr public key',
                  hintText: '64-char hex...',
                  suffixIcon: IconButton(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedScan,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    onPressed: () {
                      // TODO: QR scanner
                    },
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (v.trim().length != 64) {
                    return 'Must be 64 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.pop();
                  }
                },
                // _loading ? null : _save,
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Add contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
