import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_spacing.dart';
import 'package:medcollab_app/features/messages/data/models/message_model.dart';

/// Compact read-receipt row — tap to expand full list.
class ReadReceiptFooter extends StatelessWidget {
  const ReadReceiptFooter({
    required this.message,
    this.nameByUserId = const {},
    super.key,
  });

  final MessageModel message;
  /// Resolves user ids → display names when `readBy.user` is not populated.
  final Map<String, String> nameByUserId;

  List<String> get _seenNames {
    return message.readBy
        .map((r) {
          final mapped = nameByUserId[r.userId]?.trim();
          if (mapped != null && mapped.isNotEmpty) return mapped;
          return r.displayName;
        })
        .where((n) => n.isNotEmpty && n != 'Colleague')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final names = _seenNames;
    // If only "Colleague" was available, still show that we have receipts after
    // name resolution failed — prefer real names; show Colleague as last resort.
    final display = names.isNotEmpty
        ? names
        : message.readBy
            .map((r) {
              final mapped = nameByUserId[r.userId]?.trim();
              if (mapped != null && mapped.isNotEmpty) return mapped;
              return r.displayName;
            })
            .where((n) => n.isNotEmpty)
            .toList();
    if (display.isEmpty) return const SizedBox.shrink();

    final preview = display.length <= 2
        ? display.join(', ')
        : '${display.take(2).join(', ')} +${display.length - 2}';

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxs, left: AppSpacing.xxs),
      child: InkWell(
        onTap: () => _showSheet(context, display),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxs,
            vertical: 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.done_all,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Seen by $preview',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSheet(BuildContext context, List<String> names) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seen by',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              ...names.map(
                (name) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.visibility_outlined, size: 20),
                  title: Text(name),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
