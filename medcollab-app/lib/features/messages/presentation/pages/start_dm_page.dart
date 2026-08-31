import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/core/error/app_exception.dart';
import 'package:medcollab_app/core/router/dm_navigation.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_spacing.dart';
import 'package:medcollab_app/core/utils/phone_utils.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/features/messages/data/models/user_lookup_result.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_avatar.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_empty_state.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_search_bar.dart';
import 'package:medcollab_app/shared/presentation/widgets/clinical_card.dart';
import 'package:medcollab_app/shared/presentation/widgets/error_banner.dart';

/// Search doctors by name or phone; message requests for strangers.
class StartDmPage extends StatefulWidget {
  const StartDmPage({super.key});

  @override
  State<StartDmPage> createState() => _StartDmPageState();
}

class _StartDmPageState extends State<StartDmPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  List<UserModel> _nameResults = const [];
  UserLookupResult? _phoneLookup;
  bool _searching = false;
  String? _error;
  String? _busyUserId;
  String? _busyRequestId;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  bool _isPhoneQuery(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return false;
    final local = digits.length > 10 ? digits.substring(digits.length - 10) : digits;
    return PhoneUtils.validateLocalNumber(local) == null;
  }

  String _phoneE164(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    final local = digits.length > 10 ? digits.substring(digits.length - 10) : digits;
    return PhoneUtils.toE164(local);
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      setState(() {
        _nameResults = const [];
        _phoneLookup = null;
        _searching = false;
        _error = null;
      });
      return;
    }

    if (_isPhoneQuery(trimmed)) {
      _debounce = Timer(const Duration(milliseconds: 400), () => _lookupPhone(trimmed));
      return;
    }

    if (trimmed.length < 2) {
      setState(() {
        _nameResults = const [];
        _phoneLookup = null;
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
        _phoneLookup = null;
      });
      try {
        final users = await AppDependencies.instance.memberRepository
            .searchMembers(query: trimmed);
        if (!mounted) return;
        setState(() {
          _nameResults = users.where((u) => u.id != selfId).toList();
          _searching = false;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _searching = false;
          _error = 'Could not search colleagues';
        });
      }
    });
  }

  Future<void> _lookupPhone(String raw) async {
    if (!mounted) return;
    setState(() {
      _searching = true;
      _error = null;
      _nameResults = const [];
    });
    try {
      final result = await AppDependencies.instance.userRepository
          .lookupByPhone(_phoneE164(raw));
      if (!mounted) return;
      setState(() {
        _phoneLookup = result;
        _searching = false;
      });
    } on NotFoundException catch (e) {
      if (!mounted) return;
      setState(() {
        _phoneLookup = null;
        _searching = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _phoneLookup = null;
        _searching = false;
        _error = 'Could not look up this number';
      });
    }
  }

  Future<void> _startDm(UserModel user) async {
    if (_busyUserId != null) return;
    setState(() => _busyUserId = user.id);
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
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() => _busyUserId = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _busyUserId = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not start conversation')),
      );
    }
  }

  Future<void> _sendRequest(UserModel user) async {
    if (_busyUserId != null) return;
    setState(() => _busyUserId = user.id);
    try {
      await AppDependencies.instance.messageRequestRepository.sendRequest(
        toUserId: user.id,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message request sent')),
      );
      await _lookupPhone(_searchController.text.trim());
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) setState(() => _busyUserId = null);
    }
  }

  Future<void> _acceptRequest(String requestId, UserModel user) async {
    if (_busyRequestId != null) return;
    setState(() => _busyRequestId = requestId);
    try {
      await AppDependencies.instance.messageRequestRepository
          .acceptRequest(requestId);
      if (!mounted) return;
      await _startDm(user);
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) setState(() => _busyRequestId = null);
    }
  }

  Widget _userSubtitle(UserModel user) {
    return Text(
      [
        user.role.label,
        if (user.speciality != null && user.speciality!.isNotEmpty)
          user.speciality!,
        if (user.institution != null && user.institution!.isNotEmpty)
          user.institution!,
      ].join(' · '),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
    );
  }

  Widget _phoneLookupCard(UserLookupResult lookup) {
    final user = lookup.user;
    final pending = lookup.pendingRequest;
    final busy = _busyUserId == user.id || _busyRequestId == pending?.id;

    Widget? action;
    if (lookup.canMessage) {
      action = FilledButton(
        onPressed: busy ? null : () => _startDm(user),
        child: const Text('Message'),
      );
    } else if (pending?.isReceived == true) {
      action = Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: busy
                  ? null
                  : () async {
                      await AppDependencies.instance.messageRequestRepository
                          .declineRequest(pending!.id);
                      if (!mounted) return;
                      await _lookupPhone(_searchController.text.trim());
                    },
              child: const Text('Decline'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilledButton(
              onPressed: busy
                  ? null
                  : () => _acceptRequest(pending!.id, user),
              child: const Text('Accept'),
            ),
          ),
        ],
      );
    } else if (pending?.isSent == true) {
      action = OutlinedButton(
        onPressed: null,
        child: const Text('Request pending'),
      );
    } else {
      action = FilledButton(
        onPressed: busy ? null : () => _sendRequest(user),
        child: const Text('Send request'),
      );
    }

    return ClinicalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppAvatar(name: user.displayName, imageUrl: user.avatarUrl),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    _userSubtitle(user),
                  ],
                ),
              ),
            ],
          ),
          if (!lookup.canMessage && pending == null) ...[
            const SizedBox(height: 12),
            Text(
              'This doctor is not in your groups yet. Send a request — '
              'they must approve before you can chat.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
          ],
          if (pending?.introMessage?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              '"${pending!.introMessage}"',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
          const SizedBox(height: 12),
          if (busy)
            const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (action != null)
            action,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trimmed = _searchController.text.trim();
    final showEmpty = trimmed.isEmpty ||
        (!_searching &&
            _phoneLookup == null &&
            _nameResults.isEmpty &&
            _error == null);

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
              hintText: 'Name or mobile number',
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
            child: showEmpty
                ? AppEmptyState(
                    icon: Icons.person_search_outlined,
                    title: trimmed.isEmpty
                        ? 'Find a colleague'
                        : 'No results',
                    subtitle: trimmed.isEmpty
                        ? 'Search by name (from your groups) or enter a '
                            '10-digit mobile number registered on Vocle.'
                        : _isPhoneQuery(trimmed)
                            ? 'This number is not on Vocle yet, or the doctor '
                                'has not completed setup.'
                            : 'Try a full name, or search by mobile number.',
                  )
                : ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      if (_phoneLookup != null)
                        _phoneLookupCard(_phoneLookup!)
                      else
                        ..._nameResults.map((user) {
                          final busy = _busyUserId == user.id;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: ClinicalCard(
                              onTap: busy ? null : () => _startDm(user),
                              child: Row(
                                children: [
                                  AppAvatar(
                                    name: user.displayName,
                                    imageUrl: user.avatarUrl,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.displayName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        _userSubtitle(user),
                                      ],
                                    ),
                                  ),
                                  if (busy)
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  else
                                    const Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
