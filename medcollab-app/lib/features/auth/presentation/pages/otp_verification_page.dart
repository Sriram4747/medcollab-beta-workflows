import 'dart:async';

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

  Timer? _resendTimer;
  Timer? _tickTimer;
  int _resendSecondsLeft = AppConstants.otpResendCooldownSeconds;
  DateTime? _otpExpiresAt;

  @override
  void initState() {
    super.initState();
    _digitControllers = List.generate(
      AppConstants.otpLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(AppConstants.otpLength, (i) {
      final node = FocusNode();
      node.onKeyEvent = (focus, event) => _onKey(i, event);
      return node;
    });
    _startResendCooldown();
    _otpExpiresAt = DateTime.now().add(
      const Duration(minutes: AppConstants.otpValidityMinutes),
    );
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _tickTimer?.cancel();
    _otpController.dispose();
    for (final c in _digitControllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    setState(() => _resendSecondsLeft = AppConstants.otpResendCooldownSeconds);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendSecondsLeft <= 1) {
        timer.cancel();
        setState(() => _resendSecondsLeft = 0);
      } else {
        setState(() => _resendSecondsLeft -= 1);
      }
    });
  }

  void _syncOtp() {
    _otpController.text = _digitControllers.map((c) => c.text).join();
  }

  void _clearDigits() {
    for (final c in _digitControllers) {
      c.clear();
    }
    _syncOtp();
    _focusNodes.first.requestFocus();
    setState(() {});
  }

  void _applyOtpDigits(String raw, {int startIndex = 0}) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;

    // Full SMS / autofill of 6 digits always replaces the whole field.
    if (digits.length >= AppConstants.otpLength) {
      for (var i = 0; i < AppConstants.otpLength; i++) {
        _digitControllers[i].text = digits[i];
      }
    } else {
      // Partial paste starting at current box — never rewrite earlier boxes.
      var writeAt = startIndex.clamp(0, AppConstants.otpLength - 1);
      for (var d = 0; d < digits.length && writeAt < AppConstants.otpLength; d++) {
        _digitControllers[writeAt].text = digits[d];
        writeAt++;
      }
    }

    _syncOtp();
    final filled = _digitControllers.where((c) => c.text.isNotEmpty).length;
    final focusIndex = filled >= AppConstants.otpLength
        ? AppConstants.otpLength - 1
        : filled.clamp(0, AppConstants.otpLength - 1);
    _focusNodes[focusIndex].requestFocus();
    setState(() {});
  }

  void _onDigitChanged(int index, String value) {
    // Full paste / SMS autofill: only accept complete 6-digit codes wholesale.
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      if (digits.length >= AppConstants.otpLength) {
        _applyOtpDigits(digits.substring(0, AppConstants.otpLength));
      } else if (digits.isNotEmpty) {
        _applyOtpDigits(digits, startIndex: index);
      } else {
        // Discard non-digit multi-character input.
        _digitControllers[index].text =
            _digitControllers[index].text.isEmpty
                ? ''
                : _digitControllers[index].text.characters.first;
      }
      return;
    }

    if (value.isEmpty) {
      _syncOtp();
      setState(() {});
      return;
    }

    // Already complete OTP: ignore extra single keypresses (no wrap to box 0).
    final alreadyFull = _digitControllers.every((c) => c.text.isNotEmpty);
    if (alreadyFull && index == AppConstants.otpLength - 1) {
      final kept = _digitControllers[index].text.isNotEmpty
          ? _digitControllers[index].text.characters.first
          : value.characters.first;
      _digitControllers[index].value = TextEditingValue(
        text: kept,
        selection: const TextSelection.collapsed(offset: 1),
      );
      _syncOtp();
      return;
    }

    // Single digit only — never wrap or restart from box 0 on extra keypress.
    final digit = value.characters.last;
    _digitControllers[index].value = TextEditingValue(
      text: digit,
      selection: const TextSelection.collapsed(offset: 1),
    );

    if (index < AppConstants.otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else {
      // Last box: keep focus here — do not cycle.
      _focusNodes[index].requestFocus();
    }

    _syncOtp();
    setState(() {});
  }

  KeyEventResult _onKey(int index, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.backspace) {
      return KeyEventResult.ignored;
    }
    final current = _digitControllers[index].text;
    if (current.isNotEmpty) {
      _digitControllers[index].clear();
      _syncOtp();
      setState(() {});
      return KeyEventResult.handled;
    }
    if (index > 0) {
      _digitControllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      _syncOtp();
      setState(() {});
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _submit() {
    _syncOtp();
    if (_otpExpiresAt != null && DateTime.now().isAfter(_otpExpiresAt!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP expired. Please request a new code.'),
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthOtpSubmitted(_otpController.text.trim()));
  }

  void _resend() {
    if (_resendSecondsLeft > 0) return;
    context.read<AuthBloc>().add(const AuthOtpResendRequested());
    _clearDigits();
    _otpExpiresAt = DateTime.now().add(
      const Duration(minutes: AppConstants.otpValidityMinutes),
    );
    _startResendCooldown();
  }

  String get _expiryHint {
    final exp = _otpExpiresAt;
    if (exp == null) return '';
    final remaining = exp.difference(DateTime.now());
    if (remaining.isNegative) return 'OTP expired — request a new code';
    final mins = remaining.inMinutes;
    final secs = remaining.inSeconds % 60;
    return 'Code expires in ${mins}m ${secs.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, next) =>
          prev.status == AuthStatus.loading &&
          next.status == AuthStatus.otpSent,
      listener: (context, state) {
        // Successful resend arrives back at otpSent.
        _otpExpiresAt = DateTime.now().add(
          const Duration(minutes: AppConstants.otpValidityMinutes),
        );
      },
      builder: (context, state) {
        final phone = state.phoneE164 ?? '';
        final phoneDisplay =
            phone.isNotEmpty ? PhoneUtils.formatForDisplay(phone) : '';
        final canResend = _resendSecondsLeft == 0 && !state.isLoading;
        final expired = _otpExpiresAt != null &&
            DateTime.now().isAfter(_otpExpiresAt!);

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
                if (expired) ...[
                  AuthErrorBanner(
                    message:
                        'This OTP has expired. Tap Resend OTP to get a new code.',
                    onDismiss: null,
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
                              enabled: !state.isLoading && !expired,
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
                const SizedBox(height: 12),
                Text(
                  _expiryHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: expired
                        ? AppColors.statusError
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                AuthPrimaryButton(
                  label: 'Verify & Continue',
                  isLoading: state.isLoading,
                  onPressed: expired ? null : _submit,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: canResend ? _resend : null,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.tealDark,
                    disabledForegroundColor:
                        AppColors.tealDark.withValues(alpha: 0.4),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: Text(
                    canResend
                        ? 'Resend OTP'
                        : 'Resend OTP in ${_resendSecondsLeft}s',
                  ),
                ),
                if (_resendSecondsLeft > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Wait for the timer before requesting another code.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
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
          LengthLimitingTextInputFormatter(1),
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
