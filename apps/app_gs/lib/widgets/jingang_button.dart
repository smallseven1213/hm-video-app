import 'package:flutter/material.dart';
import 'package:shared/apis/jingang_api.dart';
import 'package:shared/models/jingang_detail.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:url_launcher/url_launcher.dart';

import 'circle_sidimage_text_item.dart';

enum OuterFrame {
  border(true),
  noBorder(false);

  final bool value;
  const OuterFrame(this.value);
}

enum OuterFrameStyle {
  unused,
  circle,
  square,
}

enum JingangStyle {
  unused,
  single,
  multiLine,
}

class JingangButton extends StatelessWidget {
  final JinGangDetail? item;
  final bool outerFrame;
  final int outerFrameStyle;
  final JingangApi jingangApi = JingangApi();

  JingangButton({
    super.key,
    required this.item,
    this.outerFrame = false,
    this.outerFrameStyle = 1,
  });

  @override
  Widget build(BuildContext context) {
    bool hasBorder = outerFrame == OuterFrame.border.value;
    bool isRounded = outerFrameStyle == OuterFrameStyle.circle.index;
    final Size size = MediaQuery.of(context).size;

    return CircleTextItem(
        text: item?.name ?? '',
        photoSid: item?.photoSid ?? '',
        imageWidth: size.width * 0.15,
        imageHeight: size.width * 0.15,
        isRounded: isRounded,
        hasBorder: hasBorder,
        onTap: () async {
          jingangApi.recordJingangClick(item?.id ?? 0);
          if (item!.url!.startsWith('http://') ||
              item!.url!.startsWith('https://')) {
            launch(item!.url ?? '', webOnlyWindowName: '_blank');
          } else {
            List<String> parts = item!.url!.split('/');

            // 從列表中獲取所需的字串和數字
            String path = '/${parts[1]}';
            int id = int.parse(parts[2]);

            // 創建一個 Object，包含 id
            var args = {'id': id};

            MyRouteDelegate.of(context).push(path, args: args);
          }
        });
  }
}
