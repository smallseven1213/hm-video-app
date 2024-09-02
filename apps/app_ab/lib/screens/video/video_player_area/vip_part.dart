import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/video_info_formatter.dart';

import '../../../config/colors.dart';
import '../../../widgets/button.dart';

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
            // todo : 标题：试看结束，升级观看完整版
            const Text(
              '试看结束，升级观看完整版',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '片长：${getTimeString(timeLength)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            // todo : 内容：解锁后可完整播放
            Text(
              '解锁后可完整播放',
              style: TextStyle(
                color: AppColors.colors[ColorKeys.secondary],
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(width: 15),
        // 开通VIP按钮
        SizedBox(
          width: 87,
          height: 35,
          child: Button(
            text: '开通VIP',
            size: 'small',
            onPressed: () => MyRouteDelegate.of(context).push(AppRoutes.vip),
          ),
        ),
      ],
    );
  }
}
