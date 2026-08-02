import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/core/router/dm_navigation.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_spacing.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_avatar.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_empty_state.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_search_bar.dart';
import 'package:medcollab_app/shared/presentation/widgets/clinical_card.dart';
import 'package:medcollab_app/shared/presentation/widgets/error_banner.dart';

/// Search doctors and start a direct message.
class StartDmPage extends StatefulWidget {
  const StartDmPage({super.key});

  @override
  State<StartDmPage> createState() => _StartDmPageState();
}

class _StartDmPageState extends State<StartDmPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  List<UserModel> _results = const [];
  bool _searching = false;
  String? _error;
  String? _startingUserId;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      setState(() {
        _results = const [];
        _searching = false;
        _error = null;
      });
      return;
    }

    final selfId = context.read<AuthBloc>().state.user?.id ?? '';
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (!mounted) return;
      setState(() {
        _searching = true;
        _error = null;
      });
      try {
        final users = await AppDependencies.instance.memberRepository
            .searchMembers(query: trimmed);
        if (!mounted) return;
        setState(() {
          _results = users.where((u) => u.id != selfId).toList();
          _searching = false;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _searching = false;
          _error = 'Could not search colleagues in your groups';
        });
      }
    });
  }

  Future<void> _startDm(UserModel user) async {
    if (_startingUserId != null) return;
    setState(() => _startingUserId = user.id);
    try {
      final channel = await AppDependencies.instance.channelRepository
          .createOrGetDM(user.id);
      if (!mounted) return;
      openDmChat(
        context,
        channelId: channel.id,
        channel: channel,
        replace: true,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _startingUserId = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not start conversation')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('New message'),
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppSearchBar(
              controller: _searchController,
              hintText: 'Search doctors by name…',
              onChanged: _onQueryChanged,
              onClear: () => _onQueryChanged(''),
            ),
          ),
          if (_searching) const LinearProgressIndicator(minHeight: 2),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: ErrorBanner(message: _error!),
            ),
          Expanded(
            child: _results.isEmpty
                ? AppEmptyState(
                    icon: Icons.person_search_outlined,
                    title: _searchController.text.trim().length < 2
                        ? 'Find a colleague'
                        : 'No doctors found',
                    subtitle: _searchController.text.trim().length < 2
                        ? 'Search colleagues from your groups, institution, or existing chats.'
                        : 'Only people you share a group with, DM, or institution appear here.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: _results.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final user = _results[index];
                      final busy = _startingUserId == user.id;
                      return ClinicalCard(
                        onTap: busy ? null : () => _startDm(user),
                        child: Row(
                          children: [
                            AppAvatar(name: user.displayName),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.displayName,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    [
                                      user.role.label,
                                      if (user.speciality != null &&
                                          user.speciality!.isNotEmpty)
                                        user.speciality!,
                                    ].join(' · '),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (busy)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            else
                              const Icon(Icons.chevron_right),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
