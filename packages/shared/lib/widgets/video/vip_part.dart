import 'package:flutter/material.dart';
import 'package:shared/localization/shared_localization_delegate.dart';
import 'package:shared/utils/navigate_to_vip.dart';
import 'package:shared/utils/video_info_formatter.dart';

import '../purchase/purchase_button.dart';

class VipPart extends StatelessWidget {
  final int timeLength;
  final bool? useGameDeposit;

  const VipPart({
    super.key,
    required this.timeLength,
    this.useGameDeposit = false,
  });

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // todo : 標題：試看結束，升級觀看完整版
            const Text(
              '試看結束，升級觀看完整版',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '片長：${getTimeString(timeLength)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            // todo : 內容：解鎖後可完整播放
            Text(
              '解鎖後可完整播放',
              style: const TextStyle(fontSize: 12, color: Colors.yellow),
            ),
          ],
        ),
        const SizedBox(width: 15),
        // 開通VIP按鈕
        SizedBox(
          width: 87,
          height: 35,
          child: PurchaseButton(
            text: localizations.translate('become_vip'),
            onPressed: () {
              VipNavigationHandler.navigateToPage(
                context,
                useGameDeposit,
              );
            },
          ),
        ),
      ],
    );
  }
}
