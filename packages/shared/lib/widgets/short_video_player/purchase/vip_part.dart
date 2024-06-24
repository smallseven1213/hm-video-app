import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/video_info_formatter.dart';

import '../../../localization/shared_localization_delegate.dart';
import 'purchase_button.dart';

enum Direction {
  horizontal,
  vertical,
}

class VipPart extends StatelessWidget {
  final int timeLength;
  final Direction direction;

  const VipPart({
    Key? key,
    required this.timeLength,
    this.direction = Direction.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    if (direction == Direction.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildContent(context, localizations),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildContent(context, localizations),
      );
    }
  }

  List<Widget> _buildContent(context, SharedLocalizations localizations) {
    return [
      Text(
        localizations.translate('try_watching_ends'),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        '${localizations.translate('duration')}${getTimeString(timeLength)}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        localizations.translate('unlock_for_full_playback'),
        style: const TextStyle(fontSize: 12, color: Colors.yellow),
      ),
      const SizedBox(height: 15),
      PurchaseButton(
        text: localizations.translate('become_vip'),
        onPressed: () => MyRouteDelegate.of(context).push(AppRoutes.vip),
      ),
    ];
  }
}
