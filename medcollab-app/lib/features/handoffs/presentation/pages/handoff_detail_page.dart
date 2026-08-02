import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/core/error/app_exception.dart';
import 'package:medcollab_app/core/router/app_routes.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medcollab_app/features/handoffs/data/models/handoff_model.dart';
import 'package:medcollab_app/features/handoffs/presentation/utils/handoff_priority_colors.dart';
import 'package:medcollab_app/features/handoffs/presentation/widgets/handoff_card.dart';
import 'package:medcollab_app/features/handoffs/presentation/widgets/handoff_widgets.dart';
import 'package:medcollab_app/shared/presentation/widgets/error_banner.dart';

class HandoffDetailPage extends StatefulWidget {
  const HandoffDetailPage({
    required this.spaceId,
    required this.handoffId,
    super.key,
  });

  final String spaceId;
  final String handoffId;

  @override
  State<HandoffDetailPage> createState() => _HandoffDetailPageState();
}

class _HandoffDetailPageState extends State<HandoffDetailPage> {
  final _repository = AppDependencies.instance.handoffRepository;
  late Future<HandoffModel> _handoffFuture;
  bool _isBusy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _handoffFuture = _repository.getHandoffById(widget.handoffId);
    });
  }

  Future<void> _acknowledge(HandoffModel handoff) async {
    setState(() {
      _isBusy = true;
      _error = null;
    });
    try {
      final updated = await _repository.acknowledgeHandoff(handoff.id);
      if (mounted) context.pop(updated);
    } on AppException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _deleteDraft(HandoffModel handoff) async {
    setState(() {
      _isBusy = true;
      _error = null;
    });
    try {
      await _repository.deleteHandoff(handoff.id);
      if (mounted) context.pop();
    } on AppException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthBloc>().state.user?.id ?? '';

    return FutureBuilder<HandoffModel>(
      future: _handoffFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.backgroundApp,
            appBar: AppBar(
              backgroundColor: AppColors.navyPrimary,
              foregroundColor: AppColors.textOnDark,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.textOnDark,
                ),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          final message = snapshot.error is AppException
              ? (snapshot.error as AppException).message
              : 'Handoff not found';
          return Scaffold(
            backgroundColor: AppColors.backgroundApp,
            appBar: AppBar(
              backgroundColor: AppColors.navyPrimary,
              foregroundColor: AppColors.textOnDark,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.textOnDark,
                ),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(child: Text(message)),
          );
        }

        final handoff = snapshot.data!;
        final isSender = handoff.fromUser.id == currentUserId;
        final isReceiver = handoff.toUser.id == currentUserId;
        final canEdit = handoff.isDraft && isSender;
        final canAcknowledge =
            handoff.status == HandoffStatus.submitted && isReceiver;
        final updated = handoff.lastUpdated;
        final shiftTitle =
            '${_capitalize(handoff.shiftType.value)} shift';
        final dateLabel = handoff.shiftDate != null
            ? DateFormat.yMMMd().format(handoff.shiftDate!.toLocal())
            : '';

        return Scaffold(
          backgroundColor: AppColors.backgroundApp,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                color: AppColors.navyPrimary,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 16, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppColors.textOnDark,
                          ),
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shiftTitle,
                                  style: AppTextStyles.doctorName,
                                ),
                                if (dateLabel.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    dateLabel,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textOnDarkMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ErrorBanner(message: _error!),
                ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppGaps.screenH,
                    AppGaps.sectionGap,
                    AppGaps.screenH,
                    AppGaps.sectionGap,
                  ),
                  children: [
                    _MetaCard(handoff: handoff),
                    const SizedBox(height: AppGaps.sectionGap),
                    Text(
                      '${handoff.patients.length} PATIENT${handoff.patients.length == 1 ? '' : 'S'}'
                          .toUpperCase(),
                      style: AppTextStyles.sectionLabel,
                    ),
                    const SizedBox(height: 8),
                    ...handoff.patients.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: AppGaps.itemGap),
                        child: HandoffPatientCard(patient: p),
                      ),
                    ),
                    if (updated != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Last updated ${DateFormat('d MMM yyyy, h:mm a').format(updated.toLocal())}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                    if (handoff.acknowledgementNote.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Acknowledgement: ${handoff.acknowledgementNote}',
                        style: AppTextStyles.body,
                      ),
                    ],
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              if (canEdit || canAcknowledge)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppGaps.screenH,
                      8,
                      AppGaps.screenH,
                      12,
                    ),
                    child: Row(
                      children: [
                        if (canEdit) ...[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isBusy
                                  ? null
                                  : () => context.push(
                                        AppRoutes.spaceHandoffEditPath(
                                          widget.spaceId,
                                          handoff.id,
                                        ),
                                      ),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Edit'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed:
                                  _isBusy ? null : () => _deleteDraft(handoff),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Delete'),
                            ),
                          ),
                        ],
                        if (canAcknowledge)
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.tealPrimary,
                                  foregroundColor: AppColors.textOnDark,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: AppRadius.card,
                                  ),
                                ),
                                onPressed: _isBusy
                                    ? null
                                    : () => _acknowledge(handoff),
                                child: _isBusy
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Acknowledge Handoff',
                                        style: AppTextStyles.labelLarge
                                            .copyWith(
                                          color: AppColors.textOnDark,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  static String _capitalize(String raw) {
    if (raw.isEmpty) return raw;
    return '${raw[0].toUpperCase()}${raw.substring(1)}';
  }
}

class _MetaCard extends StatelessWidget {
  const _MetaCard({required this.handoff});

  final HandoffModel handoff;

  @override
  Widget build(BuildContext context) {
    final token = handoffStatusToken(handoff);
    final badge = handoffBadgeColors(token);
    final badgeLabel = handoff.lifecycleLabel == 'Completed'
        ? 'Done'
        : handoff.lifecycleLabel == 'Active'
            ? 'Active'
            : HandoffPriorityColors.handoffLifecycleLabel(handoff);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppRadius.card,
        border: Border.all(color: AppColors.borderDefault, width: 0.5),
      ),
      child: Column(
        children: [
          _MetaRow(label: 'From', value: handoff.fromUser.displayName),
          const Divider(height: 1, color: AppColors.borderLight),
          _MetaRow(
            label: 'Assigned to',
            value: handoff.toUser.displayName,
            valueColor: AppColors.tealPrimary,
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppGaps.cardH,
              vertical: AppGaps.cardV,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    'Status',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badge.bg,
                    borderRadius: AppRadius.pill,
                  ),
                  child: Text(
                    badgeLabel,
                    style: AppTextStyles.badge.copyWith(
                      color: badge.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (handoff.shiftSummary.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.borderLight),
            _MetaRow(label: 'Summary', value: handoff.shiftSummary),
          ],
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppGaps.cardH,
        vertical: AppGaps.cardV,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.cardTitle.copyWith(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
