import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_spacing.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/features/messages/data/models/message_model.dart';

/// Compact read-receipt row — tap to expand full list.
class ReadReceiptFooter extends StatelessWidget {
  const ReadReceiptFooter({
    required this.message,
    this.seenByMembers = const [],
    super.key,
  });

  final MessageModel message;
  final List<UserModel> seenByMembers;

  List<String> get _seenNames {
    if (message.readBy.isNotEmpty) {
      return message.readBy.map((r) => r.displayName).toList();
    }
    return seenByMembers.map((u) => u.displayName).toList();
  }

  @override
  Widget build(BuildContext context) {
    final names = _seenNames;
    if (names.isEmpty) return const SizedBox.shrink();

    final preview = names.length <= 2
        ? names.join(', ')
        : '${names.take(2).join(', ')} +${names.length - 2}';

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxs, left: AppSpacing.xxs),
      child: InkWell(
        onTap: () => _showSheet(context, names),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxs,
            vertical: 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.done_all,
                size: 14,
                color: message.readBy.isNotEmpty
                    ? AppColors.primary
                    : AppColors.textTertiary,
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
