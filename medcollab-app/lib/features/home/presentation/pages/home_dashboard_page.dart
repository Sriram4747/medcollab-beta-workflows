import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/core/router/app_routes.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/core/utils/clinical_formatters.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/features/handoffs/data/models/handoff_model.dart';
import 'package:medcollab_app/features/home/data/dashboard_preferences_service.dart';
import 'package:medcollab_app/features/home/presentation/cubit/home_dashboard_cubit.dart';
import 'package:medcollab_app/features/home/presentation/cubit/home_dashboard_state.dart';
import 'package:medcollab_app/features/home/presentation/widgets/doctor_workspace_widgets.dart';
import 'package:medcollab_app/features/spaces/data/models/channel_model.dart';
import 'package:medcollab_app/features/spaces/data/models/space_model.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_skeleton.dart';
import 'package:medcollab_app/shared/presentation/widgets/availability_pill.dart';
import 'package:medcollab_app/shared/presentation/widgets/error_banner.dart';

/// Modular daily workspace assembled from the doctor's local widget settings.
class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.instance;
    final userId = context.read<AuthBloc>().state.user?.id ?? '';

    return BlocProvider(
      create: (_) => HomeDashboardCubit(
        spaceRepository: deps.spaceRepository,
        handoffRepository: deps.handoffRepository,
        channelRepository: deps.channelRepository,
        notificationRepository: deps.notificationRepository,
        recentItemsService: deps.recentItemsService,
        bookmarkService: deps.bookmarkService,
        dashboardPreferencesService: deps.dashboardPreferencesService,
        currentUserId: userId,
      ),
      child: const _HomeDashboardView(),
    );
  }
}

class _HomeDashboardView extends StatelessWidget {
  const _HomeDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApp,
      body: BlocBuilder<HomeDashboardCubit, HomeDashboardState>(
        builder: (context, state) {
          if (state.isLoading && state.spaces.isEmpty) {
            return const SafeArea(child: _DashboardSkeleton());
          }

          return RefreshIndicator(
            onRefresh: () => context.read<HomeDashboardCubit>().load(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _Header(state: state)),
                if (state.error != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppGaps.screenH),
                      child: ErrorBanner(message: state.error!),
                    ),
                  ),
                if (!state.isLoading && state.spaces.isEmpty)
                  const SliverToBoxAdapter(child: _WelcomeEmptyCard()),
                ..._workspaceSlivers(context, state),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 40),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _workspaceSlivers(
    BuildContext context,
    HomeDashboardState state,
  ) {
    // `todayShift` and `availability` render inside the navy header, so they
    // are intentionally skipped here even when marked visible.
    final visible = state.widgetPreferences.where(
      (item) =>
          item.isVisible &&
          item.id != DashboardWidgetId.todayShift &&
          item.id != DashboardWidgetId.availability,
    );

    return visible.map((preference) {
      final widget = switch (preference.id) {
        DashboardWidgetId.todayShift => TodayShiftWidget(
            handoffs: state.todayHandoffs,
            onOpenHandoffs: () => context.go(AppRoutes.handoffs),
          ),
        DashboardWidgetId.availability => AvailabilityWidget(
            user: context.watch<AuthBloc>().state.user,
          ),
        DashboardWidgetId.assignedHandoffs =>
          AssignedHandoffsWidget(handoffs: state.assignedHandoffs),
        DashboardWidgetId.pendingTasks => PendingTasksWidget(state: state),
        DashboardWidgetId.patientDiscussions => PatientDiscussionsWidget(
            discussions: state.patientDiscussions,
          ),
        DashboardWidgetId.recentDms => RecentDmsWidget(dms: state.recentDms),
        DashboardWidgetId.quickActions => WorkspaceQuickActionsWidget(
            onNewHandoff: () => _newHandoff(context, state),
            onNewMessage: () => context.push(AppRoutes.startDm),
          ),
        DashboardWidgetId.emergency => EmergencyWorkspaceWidget(
            onPressed: () => _openEmergency(context, state),
          ),
        DashboardWidgetId.hospitalAnnouncements => WorkspaceAnnouncementsWidget(
            title: 'Hospital announcements',
            announcements: state.hospitalAnnouncements,
            emptyMessage:
                'Announcements from hospital spaces will appear here.',
          ),
        DashboardWidgetId.departmentAnnouncements =>
          WorkspaceAnnouncementsWidget(
            title: 'Department announcements',
            announcements: state.departmentAnnouncements,
            emptyMessage:
                'Announcements from department spaces will appear here.',
          ),
      };
      return SliverToBoxAdapter(child: widget);
    }).toList();
  }

  Future<void> _newHandoff(
    BuildContext context,
    HomeDashboardState state,
  ) async {
    final cubit = context.read<HomeDashboardCubit>();
    if (state.spaces.isEmpty) {
      await context.push(AppRoutes.spacesList);
      return;
    }

    SpaceModel? space = state.spaces.length == 1 ? state.spaces.first : null;
    if (space == null) {
      space = await showModalBottomSheet<SpaceModel>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) {
          return SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                const ListTile(
                  title: Text('Create handoff in which group?'),
                ),
                ...state.spaces.map(
                  (item) => ListTile(
                    leading: const Icon(Icons.groups_outlined),
                    title: Text(item.name),
                    onTap: () => Navigator.of(sheetContext).pop(item),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    if (space == null || !context.mounted) return;
    await context.push(AppRoutes.spaceHandoffCreatePath(space.id));
    await cubit.load();
  }

  Future<void> _openEmergency(
    BuildContext context,
    HomeDashboardState state,
  ) async {
    final options = <({SpaceModel space, ChannelModel channel})>[];
    for (final space in state.spaces) {
      for (final channel in space.channels) {
        final isEmergency = channel.type == ChannelType.emergency ||
            channel.name.toLowerCase() == 'emergency';
        if (isEmergency) {
          options.add((space: space, channel: channel));
        }
      }
    }

    if (options.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No emergency channel found. Open a group and check #emergency.',
            ),
          ),
        );
      }
      return;
    }

    var selected = options.length == 1 ? options.first : null;
    if (selected == null) {
      selected =
          await showModalBottomSheet<({SpaceModel space, ChannelModel channel})>(
        context: context,
        showDragHandle: true,
        builder: (sheetContext) {
          return SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                const ListTile(
                  title: Text('Which emergency channel?'),
                ),
                ...options.map(
                  (option) => ListTile(
                    leading: const Icon(
                      Icons.emergency_outlined,
                      color: AppColors.emergencyRed,
                    ),
                    title: Text(option.channel.displayName),
                    subtitle: Text(option.space.name),
                    onTap: () => Navigator.of(sheetContext).pop(option),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    if (selected == null || !context.mounted) return;
    final choice = selected;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.emergency_outlined,
          color: AppColors.emergencyRed,
        ),
        title: const Text('Open emergency channel?'),
        content: Text(
          'This opens ${choice.channel.displayName} in ${choice.space.name}. '
          'Messages sent there may notify the full clinical team.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Open channel'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.push(
        AppRoutes.channelPath(choice.space.id, choice.channel.id),
        extra: choice.channel,
      );
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});

  final HomeDashboardState state;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      color: AppColors.navyPrimary,
      padding: EdgeInsets.fromLTRB(
        AppGaps.screenH,
        topPadding + 20,
        AppGaps.screenH,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinicalGreeting(DateTime.now()),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user?.displayName ?? 'Doctor',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.doctorName,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Configure Home',
                onPressed: () => _openConfigureSheet(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: Icon(
                  Icons.tune,
                  color: Colors.white.withValues(alpha: 0.55),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ShiftCard(state: state, user: user),
        ],
      ),
    );
  }

  void _openConfigureSheet(BuildContext context) {
    final cubit = context.read<HomeDashboardCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => DashboardConfigurationSheet(
        initialPreferences: state.widgetPreferences,
        onSave: cubit.saveWidgetPreferences,
        onReset: cubit.resetWidgetPreferences,
      ),
    );
  }
}

/// Navy shift card: TODAY'S SHIFT + text + availability pill (brief SCREEN 1).
class _ShiftCard extends StatelessWidget {
  const _ShiftCard({required this.state, required this.user});

  final HomeDashboardState state;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final availability =
        user?.availability.status ?? AvailabilityStatus.available;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: AppRadius.card,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppGaps.cardH,
        vertical: AppGaps.cardV,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TODAY'S SHIFT",
                  style: AppTextStyles.sectionLabel.copyWith(
                    color: Colors.white.withValues(alpha: 0.50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _shiftLabel(state.todayHandoffs.firstOrNull),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textOnDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AvailabilityPill(status: availability, onDark: true, compact: true),
        ],
      ),
    );
  }

  String _shiftLabel(HandoffModel? handoff) {
    if (handoff == null) return 'No shift assigned today';
    final shiftName = switch (handoff.shiftType) {
      ShiftType.morning => 'Morning',
      ShiftType.evening => 'Evening',
      ShiftType.night => 'Night',
    };
    final window = switch (handoff.shiftType) {
      ShiftType.morning => '8am – 2pm',
      ShiftType.evening => '2pm – 8pm',
      ShiftType.night => '8pm – 8am',
    };
    final ward = handoff.primaryPatient?.ward.trim();
    if (ward != null && ward.isNotEmpty) {
      return '$shiftName · $ward · $window';
    }
    return '$shiftName · ${handoff.patients.length} patients · $window';
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppGaps.screenH),
      children: const [
        AppSkeletonBox(width: 180, height: 28),
        SizedBox(height: 8),
        AppSkeletonBox(width: 240, height: 18),
        SizedBox(height: 16),
        AppSkeletonBox(height: 120),
        SizedBox(height: 16),
        AppListSkeleton(itemCount: 4),
      ],
    );
  }
}

/// First-run Home when the doctor has not joined any spaces yet.
class _WelcomeEmptyCard extends StatelessWidget {
  const _WelcomeEmptyCard();

  Future<void> _joinWithCode(BuildContext context) async {
    final codeController = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Join with invite code'),
        content: TextField(
          controller: codeController,
          decoration: const InputDecoration(
            labelText: 'Invite code',
            hintText: 'A3K7BX',
          ),
          textCapitalization: TextCapitalization.characters,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final trimmed = codeController.text.trim();
              if (trimmed.length < 4) return;
              Navigator.pop(ctx, trimmed);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (code == null || !context.mounted) return;
    await context.push(AppRoutes.joinInvitePath(code.toUpperCase()));
    if (context.mounted) {
      context.read<HomeDashboardCubit>().load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppGaps.screenH,
        16,
        AppGaps.screenH,
        8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.borderDefault, width: 0.5),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Vocle',
              style: AppTextStyles.screenTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              'Join your department space to see handoffs, messages, and '
              'shift context for your team.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _joinWithCode(context),
              icon: const Icon(Icons.group_add_outlined, size: 18),
              label: const Text('Join with invite code'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.spacesList),
              icon: const Icon(Icons.grid_view_rounded, size: 18),
              label: const Text('Browse / create groups'),
            ),
          ],
        ),
      ),
    );
  }
}
