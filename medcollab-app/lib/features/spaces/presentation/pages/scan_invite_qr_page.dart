import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:medcollab_app/core/router/app_routes.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_spacing.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/core/utils/phone_utils.dart';

/// Join via invite code / link pasted from a QR share (camera ML kit deferred).
class ScanInviteQrPage extends StatefulWidget {
  const ScanInviteQrPage({super.key});

  @override
  State<ScanInviteQrPage> createState() => _ScanInviteQrPageState();
}

class _ScanInviteQrPageState extends State<ScanInviteQrPage> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) {
      setState(() => _error = 'Clipboard is empty — copy the invite link first');
      return;
    }
    _controller.text = text;
    setState(() => _error = null);
  }

  void _continue() {
    final code = PhoneUtils.extractInviteCode(_controller.text);
    if (code == null || code.length < 4) {
      setState(
        () => _error =
            'Enter a valid invite code or paste the full Vocle join link',
      );
      return;
    }
    context.pushReplacement(AppRoutes.joinInvitePath(code));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApp,
      appBar: AppBar(title: const Text('Join with invite')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Paste invite link or code',
                style: AppTextStyles.doctorName.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Open the QR on another phone, share/copy the Vocle join link, '
                'then paste it here. Camera QR scan ships in a follow-up build.',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Invite code or link',
                  hintText: 'https://medcollab.up.railway.app/join/…',
                ),
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                onSubmitted: (_) => _continue(),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: const TextStyle(color: AppColors.statusError, fontSize: 13),
                ),
              ],
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pasteFromClipboard,
                icon: const Icon(Icons.content_paste),
                label: const Text('Paste from clipboard'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _continue,
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
