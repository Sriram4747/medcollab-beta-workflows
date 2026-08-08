import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medcollab_app/core/router/app_routes.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_spacing.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/core/utils/phone_utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Join via camera QR scan, or by typing/pasting invite code or link.
class ScanInviteQrPage extends StatefulWidget {
  const ScanInviteQrPage({super.key});

  @override
  State<ScanInviteQrPage> createState() => _ScanInviteQrPageState();
}

class _ScanInviteQrPageState extends State<ScanInviteQrPage> {
  final _controller = TextEditingController();
  final _picker = ImagePicker();
  MobileScannerController? _scanner;
  String? _error;
  bool _cameraOn = false;
  bool _handlingCode = false;

  @override
  void dispose() {
    _scanner?.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startCamera() async {
    setState(() {
      _error = null;
      _cameraOn = true;
      _scanner ??= MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        autoStart: true,
      );
    });
  }

  Future<void> _stopCamera() async {
    await _scanner?.stop();
    setState(() => _cameraOn = false);
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handlingCode) return;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue?.trim();
      if (raw == null || raw.isEmpty) continue;
      _tryOpenCode(raw);
      return;
    }
  }

  Future<void> _scanFromGallery() async {
    setState(() => _error = null);
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null || !mounted) return;
    try {
      final ctrl = MobileScannerController();
      final result = await ctrl.analyzeImage(file.path);
      await ctrl.dispose();
      final raw = result?.barcodes
          .map((b) => b.rawValue)
          .whereType<String>()
          .firstWhere((s) => s.trim().isNotEmpty, orElse: () => '');
      if (raw == null || raw.isEmpty) {
        setState(() => _error = 'No QR code found in that image');
        return;
      }
      _tryOpenCode(raw);
    } catch (_) {
      setState(() => _error = 'Could not read that image');
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
    _handlingCode = true;
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
      appBar: AppBar(
        title: const Text('Join with invite'),
        actions: [
          if (_cameraOn)
            TextButton(
              onPressed: _stopCamera,
              child: const Text('Stop cam'),
            ),
        ],
      ),
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
              'Point your camera at a Vocle group QR, or pick a screenshot.',
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            if (_cameraOn && _scanner != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: MobileScanner(
                    controller: _scanner!,
                    onDetect: _onDetect,
                  ),
                ),
              )
            else
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.surfaceInput,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                alignment: Alignment.center,
                child: const Icon(
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
                    onPressed: _cameraOn ? null : _startCamera,
                    icon: const Icon(Icons.photo_camera_outlined, size: 18),
                    label: Text(_cameraOn ? 'Scanning…' : 'Start camera'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _scanFromGallery,
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
              onPressed: _continueManual,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
