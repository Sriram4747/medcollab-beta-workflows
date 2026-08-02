import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:medcollab_app/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:medcollab_app/features/auth/presentation/widgets/auth_scaffold.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specialityController = TextEditingController();
  final _institutionController = TextEditingController();
  final _customRoleController = TextEditingController();
  UserRole _role = UserRole.intern;

  @override
  void dispose() {
    _nameController.dispose();
    _specialityController.dispose();
    _institutionController.dispose();
    _customRoleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // When "Other" is chosen the free-text role is stored in speciality so it
    // is still captured (backend `role` is a fixed enum).
    final customRole = _customRoleController.text.trim();
    final speciality = _role == UserRole.other && customRole.isNotEmpty
        ? customRole
        : _specialityController.text.trim();

    context.read<AuthBloc>().add(
          AuthProfileSubmitted(
            name: _nameController.text.trim(),
            role: _role.value,
            speciality: speciality,
            institution: _institutionController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return AuthScaffold(
          title: 'Set up profile',
          subtitle:
              'Tell your team who you are. This takes less than a minute.',
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.errorMessage != null) ...[
                  AuthErrorBanner(
                    message: state.errorMessage!,
                    onDismiss: () => context
                        .read<AuthBloc>()
                        .add(const AuthErrorDismissed()),
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  enabled: !state.isLoading,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: (v) {
                    if (v == null || v.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<UserRole>(
                  value: _role,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: UserRole.values
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(r.label),
                        ),
                      )
                      .toList(),
                  onChanged: state.isLoading
                      ? null
                      : (v) => setState(() => _role = v ?? UserRole.intern),
                ),
                if (_role == UserRole.other) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _customRoleController,
                    enabled: !state.isLoading,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Your role',
                      hintText: 'e.g. Physiotherapist, Pharmacist',
                    ),
                    validator: (v) {
                      if (_role == UserRole.other &&
                          (v == null || v.trim().length < 2)) {
                        return 'Please describe your role';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  controller: _specialityController,
                  enabled: !state.isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Speciality (optional)',
                    hintText: 'General Medicine',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _institutionController,
                  enabled: !state.isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Hospital / College (optional)',
                    hintText: 'AIIMS Delhi',
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: state.isLoading ? null : _submit,
                  child: state.isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Complete setup'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
