import 'package:flutter/material.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/core/error/app_exception.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';

/// Shared dialog: send a DM request (used from Start DM + group member sheet).
Future<bool> promptAndSendMessageRequest(
  BuildContext context, {
  required String toUserId,
  String? peerName,
}) async {
  final introController = TextEditingController();
  final intro = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        peerName == null || peerName.isEmpty
            ? 'Send message request'
            : 'Message request to $peerName',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'You share a Vocle network with them, but chat still needs their '
            'approval. They will see your name and this note.',
            style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: introController,
            maxLength: 140,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Optional — e.g. from our ward group, need a consult',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, introController.text.trim()),
          child: const Text('Send request'),
        ),
      ],
    ),
  );
  introController.dispose();
  if (intro == null || !context.mounted) return false;

  try {
    await AppDependencies.instance.messageRequestRepository.sendRequest(
      toUserId: toUserId,
      introMessage: intro.isEmpty ? null : intro,
    );
    if (!context.mounted) return true;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request sent — waiting for them to accept'),
      ),
    );
    return true;
  } on AppException catch (e) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)),
    );
    return false;
  } catch (_) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not send request')),
    );
    return false;
  }
}
