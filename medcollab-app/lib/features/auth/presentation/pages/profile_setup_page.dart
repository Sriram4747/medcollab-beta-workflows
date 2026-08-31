import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/constants/clinical_profile_options.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:medcollab_app/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:medcollab_app/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:medcollab_app/features/profile/presentation/widgets/profile_details_form.dart';

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
  String? _pgPrepSubject;

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

    final speciality = ProfileDetailsFormHelper.resolveSpeciality(
      role: _role,
      specialityController: _specialityController,
      customRoleController: _customRoleController,
      pgPrepSubject: _pgPrepSubject,
    );

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
              'Tell your team who you are. Fields adjust based on your role.',
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'MBBS interns can skip speciality. PG residents pick a '
                    'NEET PG subject. You can update this later in Profile.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 16),
                if (state.errorMessage != null) ...[
                  AuthErrorBanner(
                    message: state.errorMessage!,
                    onDismiss: () => context
                        .read<AuthBloc>()
                        .add(const AuthErrorDismissed()),
                  ),
                  const SizedBox(height: 16),
                ],
                ProfileDetailsForm(
                  nameController: _nameController,
                  institutionController: _institutionController,
                  specialityController: _specialityController,
                  customRoleController: _customRoleController,
                  role: _role,
                  enabled: !state.isLoading,
                  pgPrepSubject: _pgPrepSubject,
                  onPgPrepSubjectChanged: (v) => _pgPrepSubject = v,
                  onRoleChanged: (role) {
                    setState(() {
                      _role = role;
                      if (!ClinicalProfileOptions.showClinicalSpeciality(role) &&
                          !ClinicalProfileOptions.showFreeTextSpeciality(role)) {
                        _specialityController.clear();
                      }
                      _pgPrepSubject = null;
                    });
                  },
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
