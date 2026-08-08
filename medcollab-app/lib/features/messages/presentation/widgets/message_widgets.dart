import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_decorations.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_spacing.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/features/messages/data/models/message_delivery_state.dart';
import 'package:medcollab_app/features/messages/data/models/message_model.dart';
import 'package:medcollab_app/features/messages/presentation/utils/message_list_utils.dart';
import 'package:medcollab_app/features/messages/presentation/widgets/read_receipt_footer.dart';
import 'package:medcollab_app/shared/presentation/widgets/mention_rich_text.dart';
import 'package:url_launcher/url_launcher.dart';

/// Text input bar with attach menu — gallery, camera, document.
/// Emoji lives on the system keyboard (WhatsApp-style), not a separate tray.
class MessageComposer extends StatelessWidget {
  const MessageComposer({
    required this.controller,
    required this.onSend,
    this.onPickGallery,
    this.onPickCamera,
    this.onPickDocument,
    this.hintText = 'Message… @ to mention',
    this.isBusy = false,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSend;
  final VoidCallback? onPickGallery;
  final VoidCallback? onPickCamera;
  final VoidCallback? onPickDocument;
  final String hintText;
  final bool isBusy;

  void _showAttachMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                onPickGallery?.call();
              },
            ),
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(ctx);
                  onPickCamera?.call();
                },
              ),
            ListTile(
              leading: const Icon(Icons.attach_file_outlined),
              title: const Text('Document / PDF'),
              onTap: () {
                Navigator.pop(ctx);
                onPickDocument?.call();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canAttach = onPickGallery != null ||
        onPickDocument != null ||
        onPickCamera != null;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        border: Border(
          top: BorderSide(color: AppColors.borderDefault, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (canAttach)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2, right: 8),
                  child: Material(
                    color: AppColors.surfaceInput,
                    borderRadius: AppRadius.button,
                    child: InkWell(
                      onTap: isBusy ? null : () => _showAttachMenu(context),
                      borderRadius: AppRadius.button,
                      child: const SizedBox(
                        width: 36,
                        height: 36,
                        child: Icon(
                          Icons.add,
                          size: 22,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  enabled: !isBusy,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: AppTextStyles.body.copyWith(
                      color: AppColors.textMuted,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceInput,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      borderSide: BorderSide(
                        color: AppColors.tealPrimary,
                        width: 1.5,
                      ),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: Material(
                  color: isBusy
                      ? AppColors.navyPrimary.withValues(alpha: 0.5)
                      : AppColors.navyPrimary,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: isBusy ? null : () => onSend(controller.text),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: isBusy
                          ? const Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Date separator chip between message groups.
class DateSeparatorChip extends StatelessWidget {
  const DateSeparatorChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppGaps.cardV),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: const BoxDecoration(
            color: AppColors.borderDefault,
            borderRadius: AppRadius.pill,
          ),
          child: Text(label, style: AppTextStyles.timestamp),
        ),
      ),
    );
  }
}

/// Root message pinned at the top of a thread screen.
class ParentMessagePreview extends StatelessWidget {
  const ParentMessagePreview({
    required this.message,
    required this.isMine,
    super.key,
  });

  final MessageModel message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryMuted,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Original message',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            MessageBubbleContent(
              message: message,
              isMine: isMine,
              showSender: true,
              showTimestamp: true,
              onImageTap: (url) => _openImage(context, url, message),
              onDocumentTap: (url) => _openUrl(context, url),
            ),
          ],
        ),
      ),
    );
  }
}

/// Channel message bubble with grouping, media, delivery state, threads.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.isMine,
    this.showSender = true,
    this.showTimestamp = true,
    this.onOpenThread,
    this.onImageTap,
    this.onEdit,
    this.onDelete,
    this.onBookmark,
    this.onPin,
    this.onReact,
    this.currentUserId,
    this.seenByMembers = const [],
    super.key,
  });

  final MessageModel message;
  final bool isMine;
  final bool showSender;
  final bool showTimestamp;
  final VoidCallback? onOpenThread;
  final void Function(String url)? onImageTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onBookmark;
  final VoidCallback? onPin;
  final ValueChanged<String>? onReact;
  final String? currentUserId;
  final List<UserModel> seenByMembers;

  static const quickReactions = ['👍', '❤️', '😂', '🙏', '✅', '👏'];

  Future<void> _showActions(BuildContext context) async {
    if (message.isDeleted || message.localOnly) return;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onReact != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: quickReactions
                      .map(
                        (e) => InkWell(
                          onTap: () => Navigator.pop(ctx, 'react:$e'),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(e, style: const TextStyle(fontSize: 26)),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const Divider(height: 1),
            ],
            if (isMine &&
                message.type == MessageType.text &&
                onEdit != null)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit message'),
                onTap: () => Navigator.pop(ctx, 'edit'),
              ),
            if (isMine && onDelete != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.error),
                title: const Text('Delete message'),
                onTap: () => Navigator.pop(ctx, 'delete'),
              ),
            if (onBookmark != null)
              ListTile(
                leading: const Icon(Icons.bookmark_outline),
                title: const Text('Bookmark'),
                onTap: () => Navigator.pop(ctx, 'bookmark'),
              ),
            if (onPin != null)
              ListTile(
                leading: const Icon(Icons.push_pin_outlined),
                title: const Text('Pin message'),
                onTap: () => Navigator.pop(ctx, 'pin'),
              ),
          ],
        ),
      ),
    );
    if (!context.mounted || action == null) return;
    if (action.startsWith('react:')) {
      onReact?.call(action.substring(6));
    } else if (action == 'edit') {
      onEdit?.call();
    } else if (action == 'delete') {
      onDelete?.call();
    } else if (action == 'bookmark') {
      onBookmark?.call();
    } else if (action == 'pin') {
      onPin?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showActions(context),
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(
            top: showSender ? 8 : 2,
            bottom: 2,
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (showSender && !isMine)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 4),
                  child: Text(
                    message.sender.displayName,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.tealDark,
                    ),
                  ),
                ),
              MessageBubbleContent(
                message: message,
                isMine: isMine,
                showSender: false,
                showTimestamp: showTimestamp,
                currentUserId: currentUserId,
                onImageTap:
                    onImageTap ?? (url) => _openImage(context, url, message),
                onDocumentTap: (url) => _openUrl(context, url),
              ),
              if (message.reactions.isNotEmpty) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: message.reactions
                      .where((r) => r.emoji.isNotEmpty && r.count > 0)
                      .map(
                        (r) {
                          final mine = currentUserId != null &&
                              r.reactedBy(currentUserId!);
                          return InkWell(
                            onTap: onReact == null
                                ? null
                                : () => onReact!(r.emoji),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: mine
                                    ? AppColors.tealPrimary
                                        .withValues(alpha: 0.15)
                                    : AppColors.surfaceInput,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: mine
                                      ? AppColors.tealPrimary
                                      : AppColors.borderDefault,
                                ),
                              ),
                              child: Text(
                                '${r.emoji} ${r.count}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          );
                        },
                      )
                      .toList(),
                ),
              ],
              if (message.replyCount > 0) ...[
                const SizedBox(height: 4),
                ThreadCountBadge(
                  replyCount: message.replyCount,
                  onTap: onOpenThread,
                ),
              ],
              if (isMine && !message.localOnly)
                ReadReceiptFooter(
                  message: message,
                  seenByMembers: seenByMembers,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubbleContent extends StatelessWidget {
  const MessageBubbleContent({
    required this.message,
    required this.isMine,
    required this.showSender,
    required this.showTimestamp,
    required this.onImageTap,
    required this.onDocumentTap,
    this.currentUserId,
    super.key,
  });

  final MessageModel message;
  final bool isMine;
  final bool showSender;
  final bool showTimestamp;
  final void Function(String url) onImageTap;
  final void Function(String url) onDocumentTap;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    final time = message.createdAt != null
        ? DateFormat.jm().format(message.createdAt!.toLocal())
        : '';
    final textColor =
        isMine ? AppColors.textOnDark : AppColors.textPrimary;
    final timestampColor =
        isMine ? AppColors.textOnDarkMuted : AppColors.textMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: AppDecorations.bubble(isMine: isMine),
      child: Column(
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showSender && !isMine)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                message.sender.displayName,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.tealDark,
                ),
              ),
            ),
          _MessageBody(
            message: message,
            isMine: isMine,
            textColor: textColor,
            currentUserId: currentUserId,
            onImageTap: onImageTap,
            onDocumentTap: onDocumentTap,
          ),
          if (showTimestamp ||
              (isMine &&
                  message.deliveryState == MessageDeliveryState.failed))
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (time.isNotEmpty)
                    Text(
                      message.isEdited ? '$time · edited' : time,
                      style: AppTextStyles.timestamp.copyWith(
                        color: timestampColor,
                      ),
                    ),
                  if (isMine &&
                      message.deliveryState ==
                          MessageDeliveryState.failed) ...[
                    if (time.isNotEmpty) const SizedBox(width: 6),
                    const Icon(
                      Icons.error_outline,
                      size: 14,
                      color: AppColors.statusError,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Failed to send',
                      style: AppTextStyles.timestamp.copyWith(
                        color: AppColors.statusError,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MessageBody extends StatelessWidget {
  const _MessageBody({
    required this.message,
    required this.isMine,
    required this.textColor,
    required this.onImageTap,
    required this.onDocumentTap,
    this.currentUserId,
  });

  final MessageModel message;
  final bool isMine;
  final Color textColor;
  final void Function(String url) onImageTap;
  final void Function(String url) onDocumentTap;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    if (message.isDeleted) {
      return Text(
        'This message was deleted',
        style: (isMine ? AppTextStyles.bubbleMine : AppTextStyles.bubbleTheirs)
            .copyWith(
          fontStyle: FontStyle.italic,
          color: isMine
              ? AppColors.textOnDarkMuted
              : AppColors.textSecondary,
        ),
      );
    }

    if (message.type == MessageType.image && message.content.hasMedia) {
      final url = message.content.mediaUrl!;
      final thumb = message.content.thumbnailUrl ?? url;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: message.localOnly ? null : () => onImageTap(url),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: message.localOnly
                  ? Container(
                      width: 200,
                      height: 140,
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: thumb,
                      width: 220,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 200,
                        height: 140,
                        color: AppColors.surfaceVariant,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                    ),
            ),
          ),
          if (message.content.text != null &&
              message.content.text!.trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            MentionRichText(
              text: message.content.text!,
              mentionIds: message.mentions,
              currentUserId: currentUserId,
              style: (isMine
                      ? AppTextStyles.bubbleMine
                      : AppTextStyles.bubbleTheirs)
                  .copyWith(color: textColor),
            ),
          ],
        ],
      );
    }

    if (message.type == MessageType.document) {
      final name = message.content.fileName ?? 'Document';
      final url = message.content.mediaUrl;
      return InkWell(
        onTap: url != null && !message.localOnly ? () => onDocumentTap(url) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                name.toLowerCase().endsWith('.pdf')
                    ? Icons.picture_as_pdf_outlined
                    : Icons.insert_drive_file_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (message.localOnly)
                      Text(
                        'Uploading…',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      )
                    else
                      Text(
                        'Tap to open',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return MentionRichText(
      text: message.displayText,
      mentionIds: message.mentions,
      currentUserId: currentUserId,
      style: (isMine ? AppTextStyles.bubbleMine : AppTextStyles.bubbleTheirs)
          .copyWith(color: textColor),
    );
  }
}

/// Compact reply count under a channel message — opens the thread.
/// Only rendered when [replyCount] > 0 (never a generic "Reply in thread").
class ThreadCountBadge extends StatelessWidget {
  const ThreadCountBadge({
    required this.replyCount,
    this.onTap,
    super.key,
  });

  final int replyCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (replyCount <= 0) return const SizedBox.shrink();
    final label = replyCount == 1 ? '1 reply →' : '$replyCount replies →';

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.button,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.tealDark,
          ),
        ),
      ),
    );
  }
}

/// Compact bubble for replies inside a thread screen.
class ThreadReplyBubble extends StatelessWidget {
  const ThreadReplyBubble({
    required this.message,
    required this.isMine,
    super.key,
  });

  final MessageModel message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.85,
        ),
        child: MessageBubbleContent(
          message: message,
          isMine: isMine,
          showSender: !isMine,
          showTimestamp: true,
          onImageTap: (url) => _openImage(context, url, message),
          onDocumentTap: (url) => _openUrl(context, url),
        ),
      ),
    );
  }
}

/// Builds list items with date separators and grouped senders.
class MessageListView extends StatelessWidget {
  const MessageListView({
    required this.items,
    required this.currentUserId,
    required this.onOpenThread,
    this.onImageTap,
    super.key,
  });

  final List<MessageListItem> items;
  final String currentUserId;
  final void Function(MessageModel message) onOpenThread;
  final void Function(String url, MessageModel message)? onImageTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return switch (item) {
          DateSeparatorItem(:final label) => DateSeparatorChip(label: label),
          ChatMessageItem(:final message, :final showSender, :final isMine) =>
            MessageBubble(
              message: message,
              isMine: isMine,
              showSender: showSender,
              onOpenThread: () => onOpenThread(message),
              onImageTap: onImageTap != null
                  ? (url) => onImageTap!(url, message)
                  : null,
            ),
        };
      },
    );
  }
}

Future<void> _openUrl(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    _showOpenError(context, 'Invalid document link');
    return;
  }

  try {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      final inApp = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      if (!inApp && context.mounted) {
        _showOpenError(context, 'No app found to open this file');
      }
    }
  } catch (_) {
    if (context.mounted) {
      _showOpenError(context, 'Could not open document');
    }
  }
}

void _showOpenError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

void _openImage(BuildContext context, String url, MessageModel message) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => _ImagePreviewRoute(
        imageUrl: url,
        title: message.sender.displayName,
      ),
    ),
  );
}

class _ImagePreviewRoute extends StatelessWidget {
  const _ImagePreviewRoute({required this.imageUrl, this.title});

  final String imageUrl;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: title != null
            ? Text(
                title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (_, __) => const CircularProgressIndicator(
              color: Colors.white54,
            ),
            errorWidget: (_, __, ___) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }
}
