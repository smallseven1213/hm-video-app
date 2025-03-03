import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/video_info_formatter.dart';

import '../../config/colors.dart';
import '../button.dart';

class VipPart extends StatelessWidget {
  final int timeLength;
  const VipPart({
    super.key,
    required this.timeLength,
  });

  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(
                color: AppColors.colors[ColorKeys.secondary],
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),
        // 開通VIP按鈕
        SizedBox(
          width: 87,
          height: 35,
          child: Button(
            text: '開通VIP',
            size: 'small',
            onPressed: () => MyRouteDelegate.of(context).push(AppRoutes.vip),
          ),
        ),
      ],
    );
  }
}
