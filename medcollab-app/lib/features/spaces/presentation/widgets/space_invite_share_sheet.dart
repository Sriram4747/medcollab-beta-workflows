import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_spacing.dart';

/// Bottom sheet to share a space invite link via QR, copy, WhatsApp, or system share.
class SpaceInviteShareSheet extends StatelessWidget {
  const SpaceInviteShareSheet({
    required this.spaceName,
    required this.inviteCode,
    this.joinUrl,
    super.key,
  });

  final String spaceName;
  final String inviteCode;
  final String? joinUrl;

  String get _joinUrl =>
      joinUrl ??
      'https://medcollab.up.railway.app/join/${inviteCode.trim().toUpperCase()}';

  static Future<void> show(
    BuildContext context, {
    required String spaceName,
    required String inviteCode,
    String? joinUrl,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => SpaceInviteShareSheet(
        spaceName: spaceName,
        inviteCode: inviteCode,
        joinUrl: joinUrl,
      ),
    );
  }

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _joinUrl));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invite link copied')),
      );
    }
  }

  Future<void> _shareWhatsApp(BuildContext context) async {
    final text = Uri.encodeComponent(
      'Join $spaceName on Vocle: $_joinUrl',
    );
    final waUri = Uri.parse('https://wa.me/?text=$text');
    final launched = await launchUrl(waUri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open WhatsApp')),
      );
    }
  }

  Future<void> _shareSystem() async {
    await Share.share('Join $spaceName on Vocle: $_joinUrl');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Invite to $spaceName',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Code: ${inviteCode.toUpperCase()}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: QrImageView(
                  data: _joinUrl,
                  version: QrVersions.auto,
                  size: 180,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _joinUrl,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: () => _copyLink(context),
              icon: const Icon(Icons.link),
              label: const Text('Copy link'),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () => _shareWhatsApp(context),
              icon: const Icon(Icons.chat_outlined),
              label: const Text('Share via WhatsApp'),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: _shareSystem,
              icon: const Icon(Icons.share_outlined),
              label: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}
