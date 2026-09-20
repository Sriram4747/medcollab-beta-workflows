import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/constants/clinical_profile_options.dart';
import 'package:medcollab_app/shared/presentation/widgets/clinical_autocomplete_field.dart';

/// Shared onboarding / edit profile fields (role-aware).
class ProfileDetailsForm extends StatefulWidget {
  const ProfileDetailsForm({
    required this.nameController,
    required this.institutionController,
    required this.specialityController,
    required this.customRoleController,
    required this.role,
    required this.onRoleChanged,
    required this.enabled,
    super.key,
    this.pgPrepSubject,
    this.onPgPrepSubjectChanged,
  });

  final TextEditingController nameController;
  final TextEditingController institutionController;
  final TextEditingController specialityController;
  final TextEditingController customRoleController;
  final UserRole role;
  final ValueChanged<UserRole> onRoleChanged;
  final bool enabled;
  final String? pgPrepSubject;
  final ValueChanged<String?>? onPgPrepSubjectChanged;

  @override
  State<ProfileDetailsForm> createState() => _ProfileDetailsFormState();
}

class _ProfileDetailsFormState extends State<ProfileDetailsForm> {
  List<String> _colleges = const [];
  String? _pgPrep;

  @override
  void initState() {
    super.initState();
    _pgPrep = widget.pgPrepSubject;
    _loadColleges();
  }

  @override
  void didUpdateWidget(covariant ProfileDetailsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pgPrepSubject != oldWidget.pgPrepSubject) {
      _pgPrep = widget.pgPrepSubject;
    }
  }

  Future<void> _loadColleges() async {
    try {
      final raw = await rootBundle.loadString(
        'assets/data/tn_medical_colleges.json',
      );
      final list = (jsonDecode(raw) as List).cast<String>();
      if (!mounted) return;
      setState(() => _colleges = list);
    } catch (_) {
      /* free-text institution still works */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: widget.nameController,
          textCapitalization: TextCapitalization.words,
          enabled: widget.enabled,
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
          value: widget.role,
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
          onChanged: widget.enabled
              ? (v) => widget.onRoleChanged(v ?? UserRole.intern)
              : null,
        ),
        if (widget.role == UserRole.other) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.customRoleController,
            enabled: widget.enabled,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Your role',
              hintText: 'e.g. Physiotherapist, Pharmacist',
            ),
            validator: (v) {
              if (widget.role == UserRole.other &&
                  (v == null || v.trim().length < 2)) {
                return 'Please describe your role';
              }
              return null;
            },
          ),
        ],
        if (ClinicalProfileOptions.showPgPrepSubject(widget.role)) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<String?>(
            value: _pgPrep,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Clinical interest (optional)',
              hintText: 'Skip if not preparing for PG / exam',
            ),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Skip / none'),
              ),
              ...ClinicalProfileOptions.neetPgSubjects.map(
                (s) => DropdownMenuItem<String?>(
                  value: s,
                  child: Text(s),
                ),
              ),
            ],
            onChanged: widget.enabled
                ? (v) {
                    setState(() => _pgPrep = v);
                    // Keep speciality controller in sync so save always persists.
                    widget.specialityController.text = v ?? '';
                    widget.onPgPrepSubjectChanged?.call(v);
                  }
                : null,
          ),
        ],
        if (ClinicalProfileOptions.showClinicalSpeciality(widget.role)) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: widget.specialityController.text.isEmpty
                ? null
                : widget.specialityController.text,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Speciality / PG subject',
            ),
            items: ClinicalProfileOptions.neetPgSubjects
                .map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Text(s),
                  ),
                )
                .toList(),
            onChanged: widget.enabled
                ? (v) {
                    if (v != null) widget.specialityController.text = v;
                  }
                : null,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Select your speciality' : null,
          ),
        ],
        if (ClinicalProfileOptions.showFreeTextSpeciality(widget.role)) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.specialityController,
            enabled: widget.enabled,
            decoration: const InputDecoration(
              labelText: 'Speciality (optional)',
            ),
          ),
        ],
        const SizedBox(height: 16),
        if (_colleges.isNotEmpty)
          ClinicalAutocompleteField(
            controller: widget.institutionController,
            options: _colleges,
            enabled: widget.enabled,
            labelText: 'Medical college / hospital',
            hintText: 'Start typing — Tamil Nadu list',
          )
        else
          TextFormField(
            controller: widget.institutionController,
            enabled: widget.enabled,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Medical college / hospital (optional)',
              hintText: 'e.g. Madras Medical College',
            ),
          ),
      ],
    );
  }
}

/// Helpers for parent widgets submitting profile forms.
abstract final class ProfileDetailsFormHelper {
  static String? resolveSpeciality({
    required UserRole role,
    required TextEditingController specialityController,
    required TextEditingController customRoleController,
    String? pgPrepSubject,
  }) {
    if (ClinicalProfileOptions.skipSpeciality(role)) {
      return '';
    }
    if (role == UserRole.other) {
      final custom = customRoleController.text.trim();
      if (custom.isNotEmpty) return custom;
      final text = specialityController.text.trim();
      return text;
    }
    if (ClinicalProfileOptions.showPgPrepSubject(role)) {
      return pgPrepSubject?.trim() ?? specialityController.text.trim();
    }
    if (ClinicalProfileOptions.showClinicalSpeciality(role) ||
        ClinicalProfileOptions.showFreeTextSpeciality(role)) {
      return specialityController.text.trim();
    }
    return '';
  }
}
