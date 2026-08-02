import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/core/presence/presence_cubit.dart';
import 'package:medcollab_app/core/router/app_routes.dart';
import 'package:medcollab_app/core/router/dm_navigation.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/features/channels/presentation/widgets/create_channel_dialog.dart';
import 'package:medcollab_app/features/spaces/data/models/channel_model.dart';
import 'package:medcollab_app/features/spaces/data/models/last_message_preview.dart';
import 'package:medcollab_app/features/spaces/data/models/space_model.dart';
import 'package:medcollab_app/features/spaces/presentation/widgets/space_invite_share_sheet.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_empty_state.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_skeleton.dart';
import 'package:medcollab_app/shared/presentation/widgets/dm_row.dart';
import 'package:medcollab_app/shared/presentation/widgets/error_banner.dart';
import 'package:medcollab_app/shared/presentation/widgets/group_row.dart';
import 'package:medcollab_app/shared/presentation/widgets/subgroup_row.dart';

/// Messages hub: Group → subgroups, plus Direct (brief SCREEN 2–3).
class MessagesHubPage extends StatefulWidget {
  const MessagesHubPage({super.key});

  @override
  State<MessagesHubPage> createState() => _MessagesHubPageState();
}

class _MessagesHubPageState extends State<MessagesHubPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<SpaceModel>> _spacesFuture;
  late Future<List<ChannelModel>> _dmsFuture;
  late Future<Set<String>> _draftIdsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _reload();
  }

  void _reload() {
    setState(() {
      _spacesFuture =
          AppDependencies.instance.spaceRepository.getMySpaces();
      _dmsFuture = AppDependencies.instance.channelRepository.getMyDMs();
      _draftIdsFuture =
          AppDependencies.instance.draftMessageService.draftChannelIds();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApp,
      body: Column(
        children: [
          _MessagesHeader(
            tabController: _tabController,
            onSearch: () => context.push(AppRoutes.search),
            onCompose: () => context.push(AppRoutes.startDm),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _GroupsTab(
                  spacesFuture: _spacesFuture,
                  draftIdsFuture: _draftIdsFuture,
                  onReload: _reload,
                ),
                _DirectTab(
                  dmsFuture: _dmsFuture,
                  draftIdsFuture: _draftIdsFuture,
                  onReload: _reload,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessagesHeader extends StatelessWidget {
  const _MessagesHeader({
    required this.tabController,
    required this.onSearch,
    required this.onCompose,
  });

  final TabController tabController;
  final VoidCallback onSearch;
  final VoidCallback onCompose;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Material(
      color: AppColors.surfaceCard,
      child: Column(
        children: [
          SizedBox(height: top),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppGaps.screenH,
              8,
              4,
              0,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Messages', style: AppTextStyles.screenTitle),
                ),
                IconButton(
                  tooltip: 'Search',
                  onPressed: onSearch,
                  icon: const Icon(
                    Icons.search,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  tooltip: 'New message',
                  onPressed: onCompose,
                  icon: const Icon(
                    Icons.edit_square,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: tabController,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            unselectedLabelStyle: AppTextStyles.cardTitle.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.textMuted,
            ),
            indicatorColor: AppColors.tealPrimary,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: AppColors.borderLight,
            tabs: const [
              Tab(text: 'Groups'),
              Tab(text: 'Direct'),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupsTab extends StatelessWidget {
  const _GroupsTab({
    required this.spacesFuture,
    required this.draftIdsFuture,
    required this.onReload,
  });

  final Future<List<SpaceModel>> spacesFuture;
  final Future<Set<String>> draftIdsFuture;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Object>>(
      future: Future.wait([spacesFuture, draftIdsFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppListSkeleton();
        }
        if (snapshot.hasError) {
          return const Center(
            child: ErrorBanner(message: 'Could not load groups'),
          );
        }
        final spaces = snapshot.data![0] as List<SpaceModel>;

        if (spaces.isEmpty) {
          return AppEmptyState(
            icon: Icons.domain_outlined,
            title: 'No channels yet',
            subtitle:
                'Join a clinical group to see ward and team subgroups here.',
            action: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton(
                  onPressed: () => context.push(AppRoutes.spacesList),
                  child: const Text('Browse / join groups'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => context.push(AppRoutes.startDm),
                  child: const Text('New message'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => onReload(),
          child: ListView.separated(
            padding: const EdgeInsets.all(AppGaps.screenH),
            itemCount: spaces.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppGaps.itemGap),
            itemBuilder: (context, index) {
              final space = spaces[index];
              final latest = _latestChannel(space);
              final preview = _groupPreview(latest);
              final timestamp = _formatTimestamp(latest?.lastMessage?.sentAt);

              return GroupRow(
                name: space.name,
                preview: preview,
                timestamp: timestamp,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SpaceSubgroupsPage(space: space),
                    ),
                  );
                  onReload();
                },
              );
            },
          ),
        );
      },
    );
  }

  ChannelModel? _latestChannel(SpaceModel space) {
    if (space.channels.isEmpty) return null;
    final sorted = List<ChannelModel>.of(space.channels)
      ..sort((a, b) {
        final at = a.lastMessage?.sentAt ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final bt = b.lastMessage?.sentAt ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return bt.compareTo(at);
      });
    return sorted.first;
  }

  String _groupPreview(ChannelModel? channel) {
    if (channel == null) return 'No subgroups yet';
    final tag = channel.displayName;
    final msg = channel.lastMessage;
    if (msg?.text == null || msg!.text!.isEmpty) {
      return tag;
    }
    final sender = (msg.senderName ?? '').trim();
    if (sender.isEmpty) return '$tag · ${msg.text}';
    return '$tag · $sender: ${msg.text}';
  }
}

/// Group → list of subgroups, with create (+) and live draft badges.
class SpaceSubgroupsPage extends StatefulWidget {
  const SpaceSubgroupsPage({required this.space, super.key});

  final SpaceModel space;

  @override
  State<SpaceSubgroupsPage> createState() => _SpaceSubgroupsPageState();
}

class _SpaceSubgroupsPageState extends State<SpaceSubgroupsPage> {
  late List<ChannelModel> _channels;
  Set<String> _draftIds = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _channels = List.of(widget.space.channels);
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final channels = await AppDependencies.instance.channelRepository
          .getSpaceChannels(widget.space.id);
      final drafts =
          await AppDependencies.instance.draftMessageService.draftChannelIds();
      if (!mounted) return;
      setState(() {
        _channels = channels;
        _draftIds = drafts;
        _loading = false;
      });
    } catch (_) {
      final drafts =
          await AppDependencies.instance.draftMessageService.draftChannelIds();
      if (!mounted) return;
      setState(() {
        _draftIds = drafts;
        _loading = false;
      });
    }
  }

  Future<void> _openChannel(ChannelModel channel) async {
    await AppDependencies.instance.recentItemsService.recordChannelVisit(
      spaceId: widget.space.id,
      channelId: channel.id,
      channelName: channel.name,
      spaceName: widget.space.name,
    );
    if (!mounted) return;
    await context.push(
      AppRoutes.channelPath(widget.space.id, channel.id),
      extra: channel,
    );
    await _refresh();
  }

  void _createSubgroup() {
    CreateChannelDialog.show(
      context,
      spaceId: widget.space.id,
      onCreated: (channel) {
        setState(() {
          _channels = [..._channels, channel];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final channels = List<ChannelModel>.of(_channels)
      ..sort((a, b) {
        final at = a.lastMessage?.sentAt ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final bt = b.lastMessage?.sentAt ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return bt.compareTo(at);
      });

    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.backgroundApp,
      body: Column(
        children: [
          Material(
            color: AppColors.surfaceCard,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                4,
                top + 4,
                AppGaps.screenH,
                10,
              ),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.space.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.screenTitle,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Members',
                    onPressed: () => context.push(
                      AppRoutes.spaceMembersPath(widget.space.id),
                    ),
                    icon: const Icon(
                      Icons.people_outline,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (widget.space.inviteCode != null &&
                      widget.space.inviteCode!.isNotEmpty)
                    IconButton(
                      tooltip: 'Invite code',
                      onPressed: () => SpaceInviteShareSheet.show(
                        context,
                        spaceName: widget.space.name,
                        inviteCode: widget.space.inviteCode!,
                      ),
                      icon: const Icon(
                        Icons.qr_code_2_rounded,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  Material(
                    color: AppColors.tealPrimary,
                    borderRadius: AppRadius.button,
                    child: InkWell(
                      onTap: _createSubgroup,
                      borderRadius: AppRadius.button,
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(
                          Icons.add,
                          color: AppColors.textOnDark,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _loading && channels.isEmpty
                ? const AppListSkeleton()
                : channels.isEmpty
                    ? AppEmptyState(
                        icon: Icons.tag,
                        title: 'No subgroups yet',
                        subtitle: 'Create a subgroup for this clinical team.',
                        action: FilledButton.icon(
                          onPressed: _createSubgroup,
                          icon: const Icon(Icons.add),
                          label: const Text('New subgroup'),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(AppGaps.screenH),
                          itemCount: channels.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppGaps.itemGap),
                          itemBuilder: (context, index) {
                            final channel = channels[index];
                            final preview = channel.lastMessage;
                            final hasDraft = _draftIds.contains(channel.id);
                            final previewText = hasDraft
                                ? 'Draft awaiting'
                                : _subgroupPreviewText(preview);

                            return SubgroupRow(
                              name: channel.displayName,
                              preview: previewText,
                              type: channel.type,
                              timestamp: hasDraft
                                  ? null
                                  : _formatTimestamp(preview?.sentAt),
                              hasDraft: hasDraft,
                              onTap: () => _openChannel(channel),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  String _subgroupPreviewText(LastMessagePreview? preview) {
    if (preview == null) return 'No new messages';
    final text = preview.text;
    if (text == null || text.isEmpty) return 'No new messages';
    final sender = (preview.senderName ?? '').trim();
    if (sender.isEmpty) return text;
    return '$sender: $text';
  }
}

class _DirectTab extends StatelessWidget {
  const _DirectTab({
    required this.dmsFuture,
    required this.draftIdsFuture,
    required this.onReload,
  });

  final Future<List<ChannelModel>> dmsFuture;
  final Future<Set<String>> draftIdsFuture;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Object>>(
      future: Future.wait([dmsFuture, draftIdsFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppListSkeleton();
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppGaps.screenH),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ErrorBanner(
                    message: 'Could not load direct messages.',
                  ),
                  const SizedBox(height: AppGaps.sectionGap),
                  FilledButton(
                    onPressed: () => context.push(AppRoutes.startDm),
                    child: const Text('Find a colleague'),
                  ),
                ],
              ),
            ),
          );
        }

        final dms = snapshot.data![0] as List<ChannelModel>;
        final draftIds = snapshot.data![1] as Set<String>;

        if (dms.isEmpty) {
          return AppEmptyState(
            icon: Icons.chat_bubble_outline,
            title: 'No direct messages yet',
            subtitle:
                'Start a private chat with a colleague who shares a group '
                'with you — useful for quick clinical questions.',
            action: FilledButton.icon(
              onPressed: () => context.push(AppRoutes.startDm),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('New message'),
            ),
          );
        }

        return BlocBuilder<PresenceCubit, Map<String, PresenceInfo>>(
          builder: (context, presence) {
            return RefreshIndicator(
              onRefresh: () async => onReload(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppGaps.screenH),
                itemCount: dms.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppGaps.itemGap),
                itemBuilder: (context, index) {
                  final dm = dms[index];
                  final preview = dm.lastMessage;
                  final hasDraft = draftIds.contains(dm.id);
                  final peer = dm.peer;
                  // Green dot = socket presence only — not duty "Available".
                  final isOnline = peer != null &&
                      (presence[peer.id]?.isOnline ?? false);

                  final previewText = hasDraft
                      ? 'Draft awaiting'
                      : (preview?.text?.trim().isNotEmpty == true
                          ? preview!.text!
                          : 'No messages yet');

                  return DMRow(
                    name: dm.displayName,
                    preview: previewText,
                    timestamp: hasDraft
                        ? null
                        : _formatTimestamp(preview?.sentAt),
                    isOnline: isOnline,
                    onTap: () async {
                      await openDmChat(
                        context,
                        channelId: dm.id,
                        channel: dm,
                      );
                      onReload();
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

String? _formatTimestamp(DateTime? sentAt) {
  if (sentAt == null) return null;
  final local = sentAt.toLocal();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  if (day == today) return DateFormat.jm().format(local);
  if (day == today.subtract(const Duration(days: 1))) return 'Yesterday';
  if (now.difference(local).inDays < 7) return DateFormat.E().format(local);
  return DateFormat.MMMd().format(local);
}
