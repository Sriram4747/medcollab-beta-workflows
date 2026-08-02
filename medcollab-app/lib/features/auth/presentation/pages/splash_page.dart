import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_event.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    final status = context.read<AuthBloc>().state.status;
    if (status == AuthStatus.unknown) {
      context.read<AuthBloc>().add(const AuthStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApp,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/branding/vocle_full_logo.jpeg',
              width: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            const Text(
              'For doctors. Built for India.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: AppColors.tealPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
