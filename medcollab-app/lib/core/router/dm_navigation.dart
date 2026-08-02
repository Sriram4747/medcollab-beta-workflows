import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:medcollab_app/core/router/app_routes.dart';
import 'package:medcollab_app/features/spaces/data/models/channel_model.dart';

/// Opens a DM without stacking duplicate routes for the same channel.
Future<void> openDmChat(
  BuildContext context, {
  required String channelId,
  ChannelModel? channel,
  bool replace = false,
}) async {
  final path = AppRoutes.dmPath(channelId);
  final current = GoRouterState.of(context).uri.path;
  if (current == path) return;

  if (replace) {
    context.pushReplacement(path, extra: channel);
  } else {
    await context.push(path, extra: channel);
  }
}
