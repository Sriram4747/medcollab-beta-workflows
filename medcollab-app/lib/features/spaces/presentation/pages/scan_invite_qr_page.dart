import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:medcollab_app/core/router/app_routes.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_spacing.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/core/utils/phone_utils.dart';
import 'package:zxing2/qrcode.dart';

/// Join via camera / photo QR capture, or by typing invite code / link.
/// Pure-Dart QR decode (zxing2) — no ML Kit dependency.
class ScanInviteQrPage extends StatefulWidget {
  const ScanInviteQrPage({super.key});

  @override
  State<ScanInviteQrPage> createState() => _ScanInviteQrPageState();
}

class _ScanInviteQrPageState extends State<ScanInviteQrPage> {
  final _controller = TextEditingController();
  final _picker = ImagePicker();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureAndDecode(ImageSource source) async {
    setState(() {
      _error = null;
      _busy = true;
    });
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: 90,
        maxWidth: 1600,
      );
      if (file == null || !mounted) return;
      final bytes = await file.readAsBytes();
      final raw = _decodeQr(bytes);
      if (raw == null || raw.isEmpty) {
        setState(
          () => _error =
              'No QR found. Fill the frame with the Vocle invite QR and try again.',
        );
        return;
      }
      _tryOpenCode(raw);
    } catch (_) {
      setState(() => _error = 'Could not read that image');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String? _decodeQr(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return null;
    final sample = decoded.width > 1000
        ? img.copyResize(decoded, width: 1000)
        : decoded;
    final pixels = sample
        .convert(numChannels: 4)
        .getBytes(order: img.ChannelOrder.abgr)
        .buffer
        .asInt32List();
    final source = RGBLuminanceSource(sample.width, sample.height, pixels);
    final reader = QRCodeReader();
    try {
      return reader
          .decode(BinaryBitmap(GlobalHistogramBinarizer(source)))
          .text;
    } catch (_) {
      try {
        return reader.decode(BinaryBitmap(HybridBinarizer(source))).text;
      } catch (_) {
        return null;
      }
    }
  }

  void _tryOpenCode(String raw) {
    final code = PhoneUtils.extractInviteCode(raw);
    if (code == null || code.length < 4) {
      setState(
        () => _error =
            'QR did not contain a Vocle invite. Enter the code manually below.',
      );
      return;
    }
    context.pushReplacement(AppRoutes.joinInvitePath(code));
  }

  void _continueManual() {
    final code = PhoneUtils.extractInviteCode(_controller.text);
    if (code == null || code.length < 4) {
      setState(
        () => _error =
            'Enter a valid invite code or full Vocle join link',
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
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Scan QR code',
              style: AppTextStyles.doctorName.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Take a photo of the Vocle group QR, or choose a screenshot. '
              'You can also type the invite code / link.',
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.surfaceInput,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderDefault),
              ),
              alignment: Alignment.center,
              child: _busy
                  ? const CircularProgressIndicator()
                  : const Icon(
                      Icons.qr_code_scanner,
                      size: 48,
                      color: AppColors.tealDark,
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _busy
                        ? null
                        : () => _captureAndDecode(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined, size: 18),
                    label: const Text('Scan with camera'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _busy
                        ? null
                        : () => _captureAndDecode(ImageSource.gallery),
                    icon: const Icon(Icons.image_outlined, size: 18),
                    label: const Text('From photo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Or enter invite code / link',
              style: AppTextStyles.cardTitle,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Invite code or link',
                hintText: 'https://…/join/… or code',
              ),
              textCapitalization: TextCapitalization.characters,
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) => _continueManual(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(
                  color: AppColors.statusError,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _busy ? null : _continueManual,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
