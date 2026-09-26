import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/core/error/app_exception.dart';
import 'package:medcollab_app/core/presence/presence_cubit.dart';
import 'package:medcollab_app/core/router/dm_navigation.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:medcollab_app/features/members/data/models/space_member_model.dart';
import 'package:medcollab_app/features/members/presentation/cubit/members_cubit.dart';
import 'package:medcollab_app/features/members/presentation/widgets/member_widgets.dart';
import 'package:medcollab_app/features/messages/presentation/widgets/message_request_prompt.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_empty_state.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_search_bar.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_skeleton.dart';
import 'package:medcollab_app/shared/presentation/widgets/error_banner.dart';

/// Space member list with search and presence indicators.
class SpaceMembersPage extends StatefulWidget {
  const SpaceMembersPage({
    required this.spaceId,
    this.spaceName,
    super.key,
  });

  final String spaceId;
  final String? spaceName;

  @override
  State<SpaceMembersPage> createState() => _SpaceMembersPageState();
}

class _SpaceMembersPageState extends State<SpaceMembersPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppDependencies.instance.socketClient.syncSpaceRooms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _canRemove(SpaceMemberModel actor, SpaceMemberModel target) {
    if (actor.user.id.isEmpty || target.user.id.isEmpty) return false;
    if (actor.user.id == target.user.id) return false;
    if (target.spaceRole == SpaceRole.owner) return false;
    return actor.spaceRole == SpaceRole.owner ||
        actor.spaceRole == SpaceRole.admin;
  }

  Future<void> _confirmRemove(
    BuildContext context,
    SpaceMemberModel member,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove member?'),
        content: Text(
          'Remove ${member.user.displayName} from this group? '
          'They will lose access to all channels in this space.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final err =
        await context.read<MembersCubit>().removeMember(member.user.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          err ?? '${member.user.displayName} removed from the group',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.instance;

    return BlocProvider(
      create: (_) => MembersCubit(
        memberRepository: deps.memberRepository,
        userRepository: deps.userRepository,
        presenceCubit: deps.presenceCubit,
        socketClient: deps.socketClient,
        authBloc: deps.authBloc,
        spaceId: widget.spaceId,
        currentUserId: context.read<AuthBloc>().state.user?.id ?? '',
      ),
      child: BlocListener<PresenceCubit, Map<String, PresenceInfo>>(
        bloc: deps.presenceCubit,
        listener: (context, _) {
          context.read<MembersCubit>().applyPresenceUpdate();
        },
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (prev, next) =>
              prev.user?.availability != next.user?.availability,
          listener: (context, _) {
            context.read<MembersCubit>().applyPresenceUpdate();
          },
          child: Builder(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(widget.spaceName ?? 'Members'),
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: AppSearchBar(
                        controller: _searchController,
                        hintText: 'Search members…',
                        onChanged: (q) =>
                            context.read<MembersCubit>().search(q),
                        onClear: () =>
                            context.read<MembersCubit>().search(''),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Team members',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<MembersCubit, MembersState>(
                        builder: (context, state) {
                          if (state.isLoading && state.members.isEmpty) {
                            return const AppListSkeleton();
                          }

                          final members = state.filteredMembers;
                          final me = state.members
                              .where(
                                (m) =>
                                    m.user.id ==
                                    context.read<AuthBloc>().state.user?.id,
                              )
                              .firstOrNull;

                          return Column(
                            children: [
                              if (state.error != null)
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ErrorBanner(message: state.error!),
                                ),
                              Expanded(
                                child: members.isEmpty
                                    ? AppEmptyState(
                                        icon: Icons.people_outline,
                                        title: state.searchQuery.isEmpty
                                            ? 'No members found'
                                            : 'No matches found',
                                        subtitle: state.searchQuery.isEmpty
                                            ? null
                                            : 'Try a different search term.',
                                      )
                                    : ListView.separated(
                                        itemCount: members.length,
                                        separatorBuilder: (_, __) =>
                                            const Divider(height: 1),
                                        itemBuilder: (context, index) {
                                          final member = members[index];
                                          final canRemove = me != null &&
                                              _canRemove(me, member);
                                          return MemberListTile(
                                            member: member,
                                            onTap: () => UserProfileSheet.show(
                                              context,
                                              member,
                                              onMessage: me != null &&
                                                      member.user.id !=
                                                          me.user.id
                                                  ? () async {
                                                      try {
                                                        final channel =
                                                            await AppDependencies
                                                                .instance
                                                                .channelRepository
                                                                .createOrGetDM(
                                                          member.user.id,
                                                        );
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        openDmChat(
                                                          context,
                                                          channelId: channel.id,
                                                          channel: channel,
                                                        );
                                                      } on AppException catch (e) {
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        final msg =
                                                            e.message.toLowerCase();
                                                        if (msg.contains(
                                                              'message request',
                                                            ) ||
                                                            msg.contains(
                                                              'only after',
                                                            ) ||
                                                            msg.contains(
                                                              'send a message',
                                                            )) {
                                                          await promptAndSendMessageRequest(
                                                            context,
                                                            toUserId:
                                                                member.user.id,
                                                            peerName: member
                                                                .user
                                                                .displayName,
                                                          );
                                                          return;
                                                        }
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content:
                                                                Text(e.message),
                                                          ),
                                                        );
                                                      } catch (_) {
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'Could not start conversation',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  : null,
                                              onRemove: canRemove
                                                  ? () {
                                                      Navigator.of(
                                                        context,
                                                        rootNavigator: true,
                                                      ).pop();
                                                      _confirmRemove(
                                                        context,
                                                        member,
                                                      );
                                                    }
                                                  : null,
                                            ),
                                            onLongPress: canRemove
                                                ? () => _confirmRemove(
                                                      context,
                                                      member,
                                                    )
                                                : null,
                                          );
                                        },
                                      ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
