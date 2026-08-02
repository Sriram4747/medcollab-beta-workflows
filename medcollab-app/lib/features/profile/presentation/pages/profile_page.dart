import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medcollab_app/core/config/env_config.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/core/router/app_routes.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/core/utils/clinical_formatters.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:medcollab_app/features/dev/presentation/pages/developer_mode_page.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        final availability =
            user?.availability.status ?? AvailabilityStatus.available;
        final roleLine = [
          if (user?.role.label.isNotEmpty == true) user!.role.label,
          if (user?.speciality != null && user!.speciality!.isNotEmpty)
            user.speciality!,
        ].join(' · ');

        return Scaffold(
          backgroundColor: AppColors.backgroundApp,
          body: Column(
            children: [
              _ProfileHeader(
                name: user?.displayName ?? 'Doctor',
                roleLine: roleLine.isEmpty ? 'Doctor' : roleLine,
                imageUrl: user?.avatarUrl,
                availability: availability,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    _SettingsCard(
                      children: [
                        _SettingsRow(
                          icon: Icons.circle,
                          iconColor: availabilityColor(availability),
                          label: 'Availability',
                          subtitle: availabilityLabel(availability),
                          onTap: () =>
                              _showAvailabilitySheet(context, availability),
                        ),
                        const _RowDivider(),
                        _SettingsRow(
                          icon: Icons.bookmark_outline,
                          label: 'Bookmarks',
                          onTap: () => context.push(AppRoutes.bookmarks),
                        ),
                        const _RowDivider(),
                        _SettingsRow(
                          icon: Icons.grid_view_rounded,
                          label: 'My Groups',
                          onTap: () => context.push(AppRoutes.spacesList),
                        ),
                        const _RowDivider(),
                        _SettingsRow(
                          icon: Icons.notifications_outlined,
                          label: 'Notification settings',
                          onTap: () =>
                              context.push(AppRoutes.notificationSettings),
                        ),
                        const _RowDivider(),
                        _SettingsRow(
                          icon: Icons.help_outline,
                          label: 'Help & FAQ',
                          onTap: () => context.push(AppRoutes.help),
                        ),
                        const _RowDivider(),
                        _SettingsRow(
                          icon: Icons.bug_report_outlined,
                          label: 'Report a bug',
                          onTap: () => context.push(AppRoutes.reportBug),
                        ),
                        const _RowDivider(),
                        _SettingsRow(
                          icon: Icons.lightbulb_outline,
                          label: 'Feature request',
                          onTap: () => context.push(AppRoutes.featureRequest),
                        ),
                        const _RowDivider(),
                        _SettingsRow(
                          icon: Icons.mail_outline,
                          label: 'Contact team',
                          onTap: () => context.push(AppRoutes.contact),
                        ),
                      ],
                    ),
                    if (EnvConfig.enableDeveloperTools) ...[
                      const SizedBox(height: 16),
                      const _DeveloperEntryCard(),
                    ],
                    const SizedBox(height: 16),
                    _SignOutCard(
                      enabled: !state.isLoading,
                      onTap: () => context
                          .read<AuthBloc>()
                          .add(const AuthLogoutRequested()),
                    ),
                    const SizedBox(height: 20),
                    const _VersionFooter(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAvailabilitySheet(
    BuildContext context,
    AvailabilityStatus current,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.surfaceCard,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheet),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                'Availability',
                style: AppTextStyles.screenTitle.copyWith(fontSize: 16),
              ),
            ),
            ...AvailabilityStatus.values.map((status) {
              final color = availabilityColor(status);
              final selected = status == current;
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                leading: Icon(Icons.circle, size: 12, color: color),
                title: Text(
                  availabilityLabel(status),
                  style: AppTextStyles.cardTitle,
                ),
                subtitle: Text(
                  availabilitySubtitle(status),
                  style: AppTextStyles.caption,
                ),
                trailing: selected
                    ? const Icon(Icons.check, color: AppColors.tealPrimary)
                    : null,
                onTap: () async {
                  Navigator.pop(ctx);
                  final deps = AppDependencies.instance;
                  final userId =
                      context.read<AuthBloc>().state.user?.id ?? '';
                  try {
                    final availability = await deps.userRepository
                        .updateAvailability(status: status);
                    if (!context.mounted) return;
                    context
                        .read<AuthBloc>()
                        .add(AuthAvailabilityUpdated(availability));
                    deps.presenceCubit.applyLocal(
                      userId: userId,
                      status: status,
                      isOnline: deps.socketClient.isConnected,
                    );
                    if (deps.socketClient.isConnected) {
                      deps.socketClient
                          .updateAvailability(status: status.value);
                    }
                  } catch (_) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not update availability'),
                      ),
                    );
                  }
                },
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _DeveloperEntryCard extends StatelessWidget {
  const _DeveloperEntryCard();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: DeveloperModePage.isUnlocked(),
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();
        return _SettingsCard(
          children: [
            _SettingsRow(
              icon: Icons.developer_mode_outlined,
              label: 'Developer Mode',
              onTap: () => context.push(AppRoutes.developerMode),
            ),
          ],
        );
      },
    );
  }
}

class _VersionFooter extends StatefulWidget {
  const _VersionFooter();

  @override
  State<_VersionFooter> createState() => _VersionFooterState();
}

class _VersionFooterState extends State<_VersionFooter> {
  int _longPressCount = 0;

  Future<void> _onLongPress() async {
    if (!EnvConfig.enableDeveloperTools) return;

    _longPressCount++;
    if (_longPressCount >= 5) {
      await _unlockAndOpen();
      return;
    }

    final pinController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unlock Developer Mode'),
        content: TextField(
          controller: pinController,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'PIN',
            hintText: 'Enter beta PIN',
          ),
          autofocus: true,
          onSubmitted: (_) {
            final match =
                pinController.text.trim() == DeveloperModePage.unlockPin;
            Navigator.pop(ctx, match);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final match =
                  pinController.text.trim() == DeveloperModePage.unlockPin;
              Navigator.pop(ctx, match);
            },
            child: const Text('Unlock'),
          ),
        ],
      ),
    );

    if (!mounted || ok == null) return;
    if (ok) {
      await _unlockAndOpen();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect PIN')),
      );
    }
  }

  Future<void> _unlockAndOpen() async {
    await DeveloperModePage.setUnlocked(true);
    _longPressCount = 0;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Developer Mode unlocked')),
    );
    context.push(AppRoutes.developerMode);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _onLongPress,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              'Vocle beta',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Clinical collaboration for hospital teams',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
                color: AppColors.textMuted.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.roleLine,
    required this.availability,
    this.imageUrl,
  });

  final String name;
  final String roleLine;
  final String? imageUrl;
  final AvailabilityStatus availability;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final pillColor = availabilityColor(availability);

    return Container(
      width: double.infinity,
      color: AppColors.navyPrimary,
      padding: EdgeInsets.fromLTRB(16, top + 20, 16, 28),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.tealPrimary, width: 2.5),
            ),
            padding: const EdgeInsets.all(2),
            child: AppAvatar(
              name: name,
              imageUrl: imageUrl,
              size: 64,
              foregroundColor: AppColors.tealPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            roleLine,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.55),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: pillColor.withValues(alpha: 0.18),
              borderRadius: AppRadius.pill,
              border: Border.all(color: pillColor.withValues(alpha: 0.55)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: pillColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  availabilityLabel(availability),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: pillColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.borderDefault, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: subtitle == null ? 52 : 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Icon(
                  icon,
                  size: icon == Icons.circle ? 12 : 18,
                  color: iconColor ?? AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.cardTitle),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: AppTextStyles.caption.copyWith(
                          color: iconColor ?? AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 0.5,
      indent: 58,
      color: AppColors.borderLight,
    );
  }
}

class _SignOutCard extends StatelessWidget {
  const _SignOutCard({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: AppRadius.card,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.emergencyBorder, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout_rounded,
                size: 18,
                color: enabled
                    ? AppColors.emergencyRed
                    : AppColors.emergencyRed.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 8),
              Text(
                'Sign out',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: enabled
                      ? AppColors.emergencyRed
                      : AppColors.emergencyRed.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
