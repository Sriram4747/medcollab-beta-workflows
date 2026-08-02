import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/core/presence/presence_cubit.dart';
import 'package:medcollab_app/core/router/app_routes.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_spacing.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/core/utils/clinical_formatters.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/features/bookmarks/presentation/pages/bookmarks_page.dart';
import 'package:medcollab_app/features/channels/data/models/channel_detail_model.dart';
import 'package:medcollab_app/features/media/data/services/media_picker_service.dart';
import 'package:medcollab_app/features/messages/data/models/message_model.dart';
import 'package:medcollab_app/features/messages/presentation/cubit/channel_chat_cubit.dart';
import 'package:medcollab_app/features/messages/presentation/pages/thread_page.dart';
import 'package:medcollab_app/features/messages/presentation/utils/message_list_utils.dart';
import 'package:medcollab_app/features/messages/presentation/widgets/mention_composer.dart';
import 'package:medcollab_app/features/messages/presentation/widgets/message_widgets.dart';
import 'package:medcollab_app/features/messages/presentation/widgets/peer_profile_card.dart';
import 'package:medcollab_app/features/spaces/data/models/channel_model.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_avatar.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_empty_state.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_skeleton.dart';
import 'package:medcollab_app/shared/presentation/widgets/error_banner.dart';

class ChannelChatPage extends StatefulWidget {
  const ChannelChatPage({
    required this.channelId,
    this.spaceId,
    this.channel,
    super.key,
  });

  /// Null or empty means a direct message channel.
  final String? spaceId;
  final String channelId;
  final ChannelModel? channel;

  bool get isDm => spaceId == null || spaceId!.isEmpty;

  @override
  State<ChannelChatPage> createState() => _ChannelChatPageState();
}

class _ChannelChatPageState extends State<ChannelChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _mediaPicker = MediaPickerService();
  int _lastMessageCount = 0;
  bool _userNearBottom = true;
  List<UserModel> _mentionCandidates = const [];
  List<UserModel> _spaceMembers = const [];
  List<PinnedMessageEntry> _pinnedMessages = const [];
  ChannelModel? _resolvedChannel;
  Timer? _draftDebounce;
  Timer? _typingStopDebounce;
  bool _isTyping = false;

  bool get _isDm => widget.isDm;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _textController.addListener(_onDraftChanged);
    _loadChannelContext();
    _loadDraft();
  }

  void _onDraftChanged() {
    final text = _textController.text;
    _draftDebounce?.cancel();
    _draftDebounce = Timer(const Duration(milliseconds: 400), () {
      AppDependencies.instance.draftMessageService.saveDraft(
        widget.channelId,
        text,
      );
    });
  }

  Future<void> _loadDraft() async {
    final draft = await AppDependencies.instance.draftMessageService
        .getDraft(widget.channelId);
    if (!mounted || draft == null || draft.isEmpty) return;
    _textController.text = draft;
    _textController.selection = TextSelection.collapsed(
      offset: draft.length,
    );
  }

  void _handleTyping(ChannelChatCubit cubit) {
    final text = _textController.text;
    if (text.trim().isEmpty) {
      if (_isTyping) {
        _isTyping = false;
        cubit.emitTypingStop();
      }
      _typingStopDebounce?.cancel();
      return;
    }

    if (!_isTyping) {
      _isTyping = true;
      cubit.emitTypingStart();
    }
    _typingStopDebounce?.cancel();
    _typingStopDebounce = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      _isTyping = false;
      cubit.emitTypingStop();
    });
  }

  Future<void> _loadChannelContext() async {
    final deps = AppDependencies.instance;

    try {
      if (_isDm) {
        final members =
            await deps.channelRepository.getChannelMembers(widget.channelId);
        if (mounted) {
          setState(() {
            _mentionCandidates = members;
            _spaceMembers = members;
          });
        }
      } else {
        final members =
            await deps.memberRepository.getSpaceMembers(widget.spaceId!);
        if (mounted) {
          setState(() {
            _mentionCandidates = members.map((m) => m.user).toList();
            _spaceMembers = _mentionCandidates;
          });
        }
      }
    } catch (_) {}

    try {
      final detail =
          await deps.channelRepository.getChannelById(widget.channelId);
      if (!_isDm) {
        final spaces = await deps.spaceRepository.getMySpaces();
        final space =
            spaces.where((s) => s.id == widget.spaceId).firstOrNull;
        final spaceName = space?.name ?? '';
        if (spaceName.isNotEmpty) {
          await deps.recentItemsService.recordChannelVisit(
            spaceId: widget.spaceId!,
            channelId: widget.channelId,
            channelName: widget.channel?.name ?? detail.channel.name,
            spaceName: spaceName,
          );
        }
        if (mounted) {
          setState(() {
            _pinnedMessages = detail.pinnedMessages;
            _resolvedChannel = widget.channel ?? detail.channel;
          });
        }
      } else if (mounted) {
        setState(() {
          _pinnedMessages = detail.pinnedMessages;
          _resolvedChannel = widget.channel ?? detail.channel;
        });
      }
    } catch (_) {
      if (mounted && widget.channel != null) {
        setState(() => _resolvedChannel = widget.channel);
      }
    }
  }

  @override
  void dispose() {
    _draftDebounce?.cancel();
    _typingStopDebounce?.cancel();
    // Flush latest draft before leaving so the parent list sees it immediately.
    unawaited(
      AppDependencies.instance.draftMessageService.saveDraft(
        widget.channelId,
        _textController.text,
      ),
    );
    _scrollController.removeListener(_onScroll);
    _textController.removeListener(_onDraftChanged);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showDmPeerCard(
    BuildContext context,
    ChannelModel? channel,
  ) async {
    final selfId = context.read<AuthBloc>().state.user?.id ?? '';
    UserModel? peer = channel?.peer;
    peer ??= channel?.members.where((m) => m.id != selfId).firstOrNull;
    peer ??= _spaceMembers.where((m) => m.id != selfId).firstOrNull;

    if (peer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load colleague profile')),
      );
      return;
    }

    try {
      final fresh = await AppDependencies.instance.memberRepository
          .getUserById(peer.id);
      if (!context.mounted) return;
      await showPeerProfileCard(context, user: fresh);
    } catch (_) {
      if (!context.mounted) return;
      await showPeerProfileCard(context, user: peer);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    _userNearBottom = max - offset < 120;
  }

  void _scrollToBottom({bool force = false}) {
    if (!force && !_userNearBottom) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _openThread(BuildContext context, MessageModel message) {
    final channel = _resolvedChannel ?? widget.channel;
    final args = ThreadRouteArgs(
      rootMessage: message,
      channel: channel,
    );
    if (_isDm) {
      context.push(
        AppRoutes.dmThreadPath(widget.channelId, message.id),
        extra: args,
      );
    } else {
      context.push(
        AppRoutes.threadPath(widget.spaceId!, widget.channelId, message.id),
        extra: args,
      );
    }
  }

  Future<void> _sendAttachment(
    BuildContext context,
    Future<PickedAttachment?> Function() pick,
  ) async {
    final picked = await pick();
    if (picked == null || !context.mounted) return;
    await context.read<ChannelChatCubit>().sendAttachment(
          bytes: picked.bytes,
          fileName: picked.fileName,
          mimeType: picked.mimeType,
        );
    _scrollToBottom(force: true);
  }

  Future<void> _confirmDeleteMessage(
    BuildContext context,
    MessageModel message,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete message?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<ChannelChatCubit>().deleteMessage(message.id);
    }
  }

  Future<void> _editMessage(BuildContext context, MessageModel message) async {
    final controller = TextEditingController(text: message.content.text ?? '');
    final updated = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit message'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'Message'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (updated != null && updated.isNotEmpty && context.mounted) {
      await context.read<ChannelChatCubit>().editMessage(message.id, updated);
    }
  }

  Future<void> _clearDraft() async {
    await AppDependencies.instance.draftMessageService
        .clearDraft(widget.channelId);
  }

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.instance;
    final currentUserId =
        context.read<AuthBloc>().state.user?.id ?? '';

    return BlocProvider(
      create: (_) => ChannelChatCubit(
        messageRepository: deps.messageRepository,
        mediaRepository: deps.mediaRepository,
        socketClient: deps.socketClient,
        channelId: widget.channelId,
        currentUserId: currentUserId,
      ),
      child: Builder(
        builder: (context) {
          final channel = _resolvedChannel ?? widget.channel;
          final title = channel?.displayName ?? 'Channel';
          final subtitle = _isDm
              ? _dmPresenceSubtitle(context, channel)
              : channel?.description;
          final peer = _dmPeer(channel, currentUserId);
          final peerOnline = peer != null &&
              (context.watch<PresenceCubit>().state[peer.id]?.isOnline ??
                  false);

          return Scaffold(
            backgroundColor: AppColors.backgroundApp,
            appBar: AppBar(
              backgroundColor: AppColors.navyPrimary,
              foregroundColor: AppColors.textOnDark,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.tealPrimary,
                ),
                tooltip: 'Back',
                onPressed: () async {
                  await AppDependencies.instance.draftMessageService.saveDraft(
                    widget.channelId,
                    _textController.text,
                  );
                  if (!context.mounted) return;
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.messages);
                  }
                },
              ),
              titleSpacing: 0,
              title: InkWell(
                onTap: _isDm
                    ? () => _showDmPeerCard(context, channel)
                    : null,
                borderRadius: AppRadius.button,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isDm && peerOnline
                              ? AppColors.tealPrimary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: AppAvatar(
                        name: peer?.displayName ?? title,
                        imageUrl: peer?.avatarUrl,
                        size: 36,
                        showPresence: _isDm,
                        isOnline: peerOnline,
                        backgroundColor: AppColors.tealPrimary,
                        foregroundColor: AppColors.navyPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.cardTitle.copyWith(
                              color: AppColors.textOnDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          if (subtitle != null && subtitle.isNotEmpty)
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: _isDm && peerOnline
                                    ? AppColors.tealPrimary
                                    : AppColors.textOnDarkMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.textOnDark,
                  ),
                  color: AppColors.surfaceCard,
                  onSelected: (value) async {
                    switch (value) {
                      case 'peer':
                        await _showDmPeerCard(context, channel);
                        return;
                      case 'members':
                        final spaceId = widget.spaceId;
                        if (spaceId != null && spaceId.isNotEmpty) {
                          context.push(AppRoutes.spaceMembersPath(spaceId));
                        }
                        return;
                      case 'search':
                        context.push(AppRoutes.search);
                        return;
                      case 'pinned':
                        if (_pinnedMessages.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No pinned messages yet'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${_pinnedMessages.length} pinned message'
                                '${_pinnedMessages.length == 1 ? '' : 's'} '
                                'shown above',
                              ),
                            ),
                          );
                        }
                        return;
                      case 'info':
                        final name = channel?.displayName ?? title;
                        final desc = channel?.description.trim();
                        await showModalBottomSheet<void>(
                          context: context,
                          showDragHandle: true,
                          backgroundColor: AppColors.surfaceCard,
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.sheet,
                          ),
                          builder: (sheetContext) {
                            return SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  4,
                                  20,
                                  20,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: AppTextStyles.screenTitle
                                          .copyWith(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      desc?.isNotEmpty == true
                                          ? desc!
                                          : (_isDm
                                              ? 'Direct message'
                                              : 'Clinical subgroup chat'),
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    if (!_isDm &&
                                        widget.spaceId != null) ...[
                                      const SizedBox(height: 16),
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(
                                          Icons.people_outline,
                                          color: AppColors.tealDark,
                                        ),
                                        title: const Text('View members'),
                                        onTap: () {
                                          Navigator.pop(sheetContext);
                                          context.push(
                                            AppRoutes.spaceMembersPath(
                                              widget.spaceId!,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          minimumSize: const Size(0, 44),
                                          backgroundColor:
                                              AppColors.navyPrimary,
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(sheetContext),
                                        child: const Text('Done'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        return;
                    }
                  },
                  itemBuilder: (ctx) {
                    if (_isDm) {
                      return const [
                        PopupMenuItem(
                          value: 'peer',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.person_outline),
                            title: Text('View profile'),
                            dense: true,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'search',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.search),
                            title: Text('Search'),
                            dense: true,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'info',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.info_outline),
                            title: Text('Chat info'),
                            dense: true,
                          ),
                        ),
                      ];
                    }
                    return const [
                      PopupMenuItem(
                        value: 'info',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.info_outline),
                          title: Text('Channel info'),
                          dense: true,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'members',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.people_outline),
                          title: Text('Members'),
                          dense: true,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'search',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.search),
                          title: Text('Search'),
                          dense: true,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'pinned',
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.push_pin_outlined),
                          title: Text('Pinned messages'),
                          dense: true,
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                if (_pinnedMessages.isNotEmpty)
                  _PinnedMessagesBar(entries: _pinnedMessages),
                Expanded(
                  child: BlocConsumer<ChannelChatCubit, ChannelChatState>(
                    listenWhen: (prev, next) =>
                        prev.messages.length != next.messages.length ||
                        prev.messages != next.messages,
                    listener: (_, state) {
                      final grew = state.messages.length > _lastMessageCount;
                      _lastMessageCount = state.messages.length;
                      if (grew) _scrollToBottom();
                    },
                    builder: (context, state) {
                      if (state.isLoading && state.messages.isEmpty) {
                        return const AppMessageSkeleton();
                      }

                      final listItems = buildMessageListItems(
                        messages: state.messages,
                        currentUserId: currentUserId,
                      );

                      return Column(
                        children: [
                          if (state.error != null)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: ErrorBanner(message: state.error!),
                            ),
                          Expanded(
                            child: state.messages.isEmpty
                                ? _EmptyChatState(isDm: _isDm)
                                : ListView.builder(
                                    controller: _scrollController,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    itemCount: listItems.length,
                                    itemBuilder: (context, index) {
                                      final item = listItems[index];
                                      return switch (item) {
                                        DateSeparatorItem(:final label) =>
                                          DateSeparatorChip(label: label),
                                        ChatMessageItem(
                                          :final message,
                                          :final showSender,
                                          :final isMine,
                                        ) =>
                                          MessageBubble(
                                            message: message,
                                            isMine: isMine,
                                            // Sender name only in group chats.
                                            showSender:
                                                !_isDm && showSender,
                                            currentUserId: currentUserId,
                                            seenByMembers:
                                                _seenByForMessage(message),
                                            onOpenThread: () =>
                                                _openThread(context, message),
                                            onEdit: isMine &&
                                                    message.type ==
                                                        MessageType.text
                                                ? () => _editMessage(
                                                      context,
                                                      message,
                                                    )
                                                : null,
                                            onDelete: isMine
                                                ? () => _confirmDeleteMessage(
                                                      context,
                                                      message,
                                                    )
                                                : null,
                                            onBookmark: () => _bookmarkMessage(
                                              message,
                                              channel,
                                            ),
                                            onPin: () => _pinMessage(message),
                                          ),
                                      };
                                    },
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                BlocBuilder<ChannelChatCubit, ChannelChatState>(
                  buildWhen: (p, n) =>
                      p.isSending != n.isSending ||
                      p.isUploading != n.isUploading ||
                      p.typingUserNames != n.typingUserNames,
                  builder: (context, state) {
                    final cubit = context.read<ChannelChatCubit>();
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state.typingLabel.isNotEmpty)
                          _TypingIndicator(label: state.typingLabel),
                        _TypingBinder(
                          controller: _textController,
                          cubit: cubit,
                          onTyping: _handleTyping,
                          child: MentionAwareComposer(
                          controller: _textController,
                          mentionCandidates: _mentionCandidates,
                          excludeSelfId: currentUserId,
                          isBusy: state.isSending || state.isUploading,
                          onSend: (text, mentions) async {
                            cubit.sendMessage(text, mentions: mentions);
                            _textController.clear();
                            await _clearDraft();
                            _isTyping = false;
                            cubit.emitTypingStop();
                            _scrollToBottom(force: true);
                          },
                          onPickGallery: () => _sendAttachment(
                            context,
                            _mediaPicker.pickFromGallery,
                          ),
                          onPickCamera: () => _sendAttachment(
                            context,
                            _mediaPicker.captureFromCamera,
                          ),
                          onPickDocument: () => _sendAttachment(
                            context,
                            _mediaPicker.pickDocument,
                          ),
                          onEmojiSelected: (emoji) {
                            _textController.text =
                                '${_textController.text}$emoji';
                            _textController.selection =
                                TextSelection.collapsed(
                              offset: _textController.text.length,
                            );
                            _handleTyping(cubit);
                          },
                        ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  UserModel? _dmPeer(ChannelModel? channel, String selfId) {
    UserModel? peer = channel?.peer;
    peer ??= channel?.members.where((m) => m.id != selfId).firstOrNull;
    peer ??= _spaceMembers.where((m) => m.id != selfId).firstOrNull;
    return peer;
  }

  /// Presence (socket online) and duty availability are separate.
  /// Online → "Online · On call". Not connected → always "Offline" (never "Available").
  String? _dmPresenceSubtitle(BuildContext context, ChannelModel? channel) {
    final selfId = context.read<AuthBloc>().state.user?.id ?? '';
    final peer = _dmPeer(channel, selfId);
    final peerId = peer?.id;
    if (peerId == null || peerId.isEmpty) return null;
    final presence = context.watch<PresenceCubit>().state[peerId];
    final isOnline = presence?.isOnline ?? false;
    final status = presence?.status ?? peer?.availability.status;
    final duty = status != null ? availabilityLabel(status) : null;

    if (isOnline) {
      if (duty != null &&
          status != AvailabilityStatus.offline &&
          status != AvailabilityStatus.available) {
        return 'Online · $duty';
      }
      if (duty != null && status == AvailabilityStatus.available) {
        return 'Online · Available';
      }
      return 'Online';
    }
    // Socket offline wins over stale "Available" duty status.
    if (duty != null &&
        status != AvailabilityStatus.available &&
        status != AvailabilityStatus.offline) {
      return 'Offline · $duty';
    }
    return 'Offline';
  }

  Future<void> _pinMessage(MessageModel message) async {
    try {
      await AppDependencies.instance.channelRepository.pinMessage(
        widget.channelId,
        message.id,
      );
      await _loadChannelContext();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message pinned')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not pin message')),
        );
      }
    }
  }

  Future<void> _bookmarkMessage(
    MessageModel message,
    ChannelModel? channel,
  ) async {
    await saveMessageBookmark(
      messageId: message.id,
      channelId: widget.channelId,
      spaceId: widget.spaceId ?? '',
      title: channel?.displayName ?? 'Channel',
      subtitle: message.displayText,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved to bookmarks')),
      );
    }
  }

  List<UserModel> _seenByForMessage(MessageModel message) {
    final created = message.createdAt;
    if (created == null) return const [];
    return _spaceMembers.where((u) {
      final seen = u.lastSeenAt;
      return seen != null && !seen.isBefore(created);
    }).toList();
  }
}

class _TypingBinder extends StatefulWidget {
  const _TypingBinder({
    required this.controller,
    required this.cubit,
    required this.onTyping,
    required this.child,
  });

  final TextEditingController controller;
  final ChannelChatCubit cubit;
  final void Function(ChannelChatCubit cubit) onTyping;
  final Widget child;

  @override
  State<_TypingBinder> createState() => _TypingBinderState();
}

class _TypingBinderState extends State<_TypingBinder> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant _TypingBinder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => widget.onTyping(widget.cubit);

  @override
  Widget build(BuildContext context) => widget.child;
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppGaps.screenH,
        vertical: 4,
      ),
      color: AppColors.surfaceInput,
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _PinnedMessagesBar extends StatelessWidget {
  const _PinnedMessagesBar({required this.entries});

  final List<PinnedMessageEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.push_pin, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Pinned',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.onPrimaryContainer,
                    ),
              ),
            ],
          ),
          ...entries.take(3).map(
                (e) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    e.message.displayText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  const _EmptyChatState({required this.isDm});

  final bool isDm;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.chat_bubble_outline,
      title: 'No messages yet',
      subtitle: isDm
          ? 'Send a message to start the conversation.'
          : 'Start a topic — share images, PDFs, or text.\nUse threads to discuss each patient.',
    );
  }
}
