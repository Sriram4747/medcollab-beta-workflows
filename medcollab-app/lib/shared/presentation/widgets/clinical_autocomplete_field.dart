import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';

/// Searchable field backed by a fixed option list (e.g. medical colleges).
class ClinicalAutocompleteField extends StatefulWidget {
  const ClinicalAutocompleteField({
    required this.controller,
    required this.options,
    required this.labelText,
    super.key,
    this.hintText,
    this.enabled = true,
    this.validator,
  });

  final TextEditingController controller;
  final List<String> options;
  final String labelText;
  final String? hintText;
  final bool enabled;
  final String? Function(String?)? validator;

  @override
  State<ClinicalAutocompleteField> createState() =>
      _ClinicalAutocompleteFieldState();
}

class _ClinicalAutocompleteFieldState extends State<ClinicalAutocompleteField> {
  TextEditingController? _fieldController;
  VoidCallback? _syncToParent;

  @override
  void dispose() {
    if (_fieldController != null && _syncToParent != null) {
      _fieldController!.removeListener(_syncToParent!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) {
          return widget.options.take(8);
        }
        return widget.options
            .where((o) => o.toLowerCase().contains(query))
            .take(12);
      },
      onSelected: (selection) {
        widget.controller.text = selection;
      },
      fieldViewBuilder: (context, fieldController, focusNode, onFieldSubmitted) {
        if (_fieldController != fieldController) {
          if (_fieldController != null && _syncToParent != null) {
            _fieldController!.removeListener(_syncToParent!);
          }
          _fieldController = fieldController;
          if (fieldController.text != widget.controller.text) {
            fieldController.text = widget.controller.text;
          }
          _syncToParent = () {
            if (fieldController.text != widget.controller.text) {
              widget.controller.text = fieldController.text;
            }
          };
          fieldController.addListener(_syncToParent!);
        }

        return TextFormField(
          controller: fieldController,
          focusNode: focusNode,
          enabled: widget.enabled,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
          ),
          validator: widget.validator,
          onFieldSubmitted: (_) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, iterable) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 400),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: iterable.length,
                itemBuilder: (context, index) {
                  final option = iterable.elementAt(index);
                  return ListTile(
                    dense: true,
                    title: Text(
                      option,
                      style: const TextStyle(fontSize: 14),
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
