import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/constants/app_constants.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/utils/phone_utils.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:medcollab_app/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:medcollab_app/features/auth/presentation/widgets/auth_scaffold.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  late final List<TextEditingController> _digitControllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _digitControllers = List.generate(
      AppConstants.otpLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(AppConstants.otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    _otpController.dispose();
    for (final c in _digitControllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _syncOtp() {
    _otpController.text = _digitControllers.map((c) => c.text).join();
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      // Paste / autofill of full OTP into one box.
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (var i = 0; i < AppConstants.otpLength; i++) {
        _digitControllers[i].text =
            i < digits.length ? digits[i] : '';
      }
      _syncOtp();
      final next = digits.length.clamp(0, AppConstants.otpLength - 1);
      _focusNodes[next].requestFocus();
      setState(() {});
      return;
    }

    if (value.length == 1 && index < AppConstants.otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    _syncOtp();
    setState(() {});
  }

  void _submit() {
    _syncOtp();
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthOtpSubmitted(_otpController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final phone = state.phoneE164 ?? '';
        final phoneDisplay =
            phone.isNotEmpty ? PhoneUtils.formatForDisplay(phone) : '';

        return AuthScaffold(
          title: 'Verify OTP',
          subtitle: phoneDisplay.isNotEmpty
              ? 'Code sent to $phoneDisplay'
              : 'Enter the 6-digit verification code',
          logoWidth: 100,
          showBack: true,
          onBack: state.isLoading
              ? null
              : () => context
                  .read<AuthBloc>()
                  .add(const AuthChangePhoneRequested()),
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
                FormField<String>(
                  validator: (_) =>
                      PhoneUtils.validateOtp(_otpController.text),
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(AppConstants.otpLength, (i) {
                            return _OtpDigitBox(
                              controller: _digitControllers[i],
                              focusNode: _focusNodes[i],
                              enabled: !state.isLoading,
                              autofocus: i == 0,
                              onChanged: (v) {
                                _onDigitChanged(i, v);
                                field.didChange(_otpController.text);
                              },
                              onSubmitted: i == AppConstants.otpLength - 1
                                  ? (_) => _submit()
                                  : null,
                            );
                          }),
                        ),
                        if (field.hasError) ...[
                          const SizedBox(height: 8),
                          Text(
                            field.errorText!,
                            style: const TextStyle(
                              color: AppColors.statusError,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                AuthPrimaryButton(
                  label: 'Verify & Continue',
                  isLoading: state.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () => context
                          .read<AuthBloc>()
                          .add(const AuthOtpResendRequested()),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.tealDark,
                    disabledForegroundColor:
                        AppColors.tealDark.withValues(alpha: 0.4),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('Resend OTP'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OtpDigitBox extends StatelessWidget {
  const _OtpDigitBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.enabled = true,
    this.autofocus = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;

  static const _radius = BorderRadius.all(Radius.circular(10));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 52,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        autofocus: autofocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        textInputAction: onSubmitted != null
            ? TextInputAction.done
            : TextInputAction.next,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(AppConstants.otpLength),
        ],
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: AppColors.surfaceCard,
          border: OutlineInputBorder(
            borderRadius: _radius,
            borderSide: BorderSide(color: AppColors.borderDefault),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: _radius,
            borderSide: BorderSide(color: AppColors.borderDefault),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: _radius,
            borderSide: BorderSide(color: AppColors.tealPrimary, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: _radius,
            borderSide: BorderSide(color: AppColors.borderDefault),
          ),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
