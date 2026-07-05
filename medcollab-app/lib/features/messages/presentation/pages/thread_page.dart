import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/features/media/data/services/media_picker_service.dart';
import 'package:medcollab_app/features/messages/data/models/message_model.dart';
import 'package:medcollab_app/features/messages/presentation/cubit/thread_cubit.dart';
import 'package:medcollab_app/features/messages/presentation/widgets/message_widgets.dart';
import 'package:medcollab_app/features/spaces/data/models/channel_model.dart';
import 'package:medcollab_app/shared/presentation/widgets/error_banner.dart';

/// Navigation payload for [ThreadPage].
class ThreadRouteArgs {
  const ThreadRouteArgs({required this.rootMessage, this.channel});

  final MessageModel rootMessage;
  final ChannelModel? channel;
}

/// Focused thread view — parent message + replies for one discussion topic.
class ThreadPage extends StatefulWidget {
  const ThreadPage({
    required this.spaceId,
    required this.channelId,
    required this.rootMessageId,
    this.channel,
    this.initialRoot,
    super.key,
  });

  final String spaceId;
  final String channelId;
  final String rootMessageId;
  final ChannelModel? channel;
  final MessageModel? initialRoot;

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _mediaPicker = MediaPickerService();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendAttachment(
    BuildContext context,
    Future<PickedAttachment?> Function() pick,
  ) async {
    final picked = await pick();
    if (picked == null || !context.mounted) return;
    await context.read<ThreadCubit>().sendAttachment(
          bytes: picked.bytes,
          fileName: picked.fileName,
          mimeType: picked.mimeType,
        );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.instance;
    final currentUserId =
        context.read<AuthBloc>().state.user?.id ?? '';

    return BlocProvider(
      create: (_) => ThreadCubit(
        threadRepository: deps.threadRepository,
        mediaRepository: deps.mediaRepository,
        socketClient: deps.socketClient,
        channelId: widget.channelId,
        rootMessageId: widget.rootMessageId,
        currentUserId: currentUserId,
        initialRoot: widget.initialRoot,
      ),
      child: Builder(
        builder: (context) {
          final channelName = widget.channel?.displayName ?? 'Channel';
          return Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thread'),
                  Text(
                    channelName,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: BlocConsumer<ThreadCubit, ThreadState>(
                    listenWhen: (prev, next) =>
                        prev.replies.length != next.replies.length,
                    listener: (_, __) => _scrollToBottom(),
                    builder: (context, state) {
                      if (state.isLoading && state.rootMessage == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final root = state.rootMessage ?? widget.initialRoot;
                      if (root == null) {
                        return const Center(child: Text('Thread not found'));
                      }

                      return ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 8),
                        children: [
                          if (state.error != null)
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: ErrorBanner(message: state.error!),
                            ),
                          ParentMessagePreview(
                            message: root,
                            isMine: root.sender.id == currentUserId,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Text(
                              state.replies.isEmpty
                                  ? 'Replies'
                                  : '${state.replies.length} ${state.replies.length == 1 ? 'reply' : 'replies'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          if (state.replies.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'No replies yet. Start the discussion.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary),
                              ),
                            )
                          else
                            ...state.replies.map(
                              (reply) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: ThreadReplyBubble(
                                  message: reply,
                                  isMine: reply.sender.id == currentUserId,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                BlocBuilder<ThreadCubit, ThreadState>(
                  buildWhen: (p, n) =>
                      p.isSending != n.isSending ||
                      p.isUploading != n.isUploading,
                  builder: (context, state) {
                    return MessageComposer(
                      controller: _textController,
                      hintText: 'Reply in thread…',
                      isBusy: state.isSending || state.isUploading,
                      onSend: (text) {
                        context.read<ThreadCubit>().sendReply(text);
                        _textController.clear();
                        _scrollToBottom();
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
                        _textController.selection = TextSelection.collapsed(
                          offset: _textController.text.length,
                        );
                      },
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
}
