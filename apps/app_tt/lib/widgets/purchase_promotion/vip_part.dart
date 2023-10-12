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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '試看結束，升級觀看完整版',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '片長：${getTimeString(timeLength)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          '解鎖後可完整播放',
          style: TextStyle(
            color: Color(0xffffd900),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 15),
        // 開通VIP按鈕
        SizedBox(
          width: 120,
          height: 35,
          child: Button(
            text: '立即升級解鎖',
            size: 'small',
            onPressed: () => MyRouteDelegate.of(context).push(AppRoutes.vip),
          ),
        ),
      ],
    );
  }
}
