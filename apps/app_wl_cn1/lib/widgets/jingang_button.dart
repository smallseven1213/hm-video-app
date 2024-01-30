import 'package:flutter/material.dart';
import 'package:shared/apis/jingang_api.dart';
import 'package:shared/enums/jingang.dart';
import 'package:shared/models/jingang_detail.dart';
import 'package:shared/widgets/jingang_link_button.dart';

import 'circle_sidimage_text_item.dart';

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
    final Size size = MediaQuery.sizeOf(context);

    return JingangLinkButton(
      item: item,
      child: CircleTextItem(
        text: item?.name ?? '',
        photoSid: item?.photoSid ?? '',
        imageWidth: size.width * 0.15,
        imageHeight: size.width * 0.15,
        isRounded: isRounded,
        hasBorder: hasBorder,
      ),
    );
  }
}
