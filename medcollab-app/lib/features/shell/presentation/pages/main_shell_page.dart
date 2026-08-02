import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/features/handoffs/presentation/pages/global_handoffs_page.dart';
import 'package:medcollab_app/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:medcollab_app/features/messages_hub/presentation/pages/messages_hub_page.dart';
import 'package:medcollab_app/features/notifications/presentation/cubit/notification_badge_cubit.dart';
import 'package:medcollab_app/features/notifications/presentation/pages/notifications_page.dart';
import 'package:medcollab_app/features/profile/presentation/pages/profile_page.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_nav_bar.dart';

/// Bottom navigation shell — Vocle redesign Step 2 ([AppNavBar]).
class MainShellPage extends StatefulWidget {
  const MainShellPage({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  @override
  void initState() {
    super.initState();
    final deps = AppDependencies.instance;
    if (deps.socketClient.isConnected) {
      deps.socketClient.syncSpaceRooms();
    }
    deps.notificationBadgeCubit.refresh();
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    if (index == 3) {
      AppDependencies.instance.notificationBadgeCubit.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BlocBuilder<NotificationBadgeCubit, int>(
        builder: (context, alertsBadge) {
          return AppNavBar(
            currentIndex: widget.navigationShell.currentIndex,
            onTap: _onTap,
            alertsBadge: alertsBadge,
            // Message / handoff dots wired when unread sources are available.
            messagesDot: false,
            handoffsDot: false,
          );
        },
      ),
    );
  }
}

/// Tab pages registered in [AppRouter] shell branches.
abstract final class ShellTabPages {
  static const home = HomeDashboardPage();
  static const messages = MessagesHubPage();
  static const handoffs = GlobalHandoffsPage();
  static const notifications = NotificationsPage();
  static const profile = ProfilePage();
}
