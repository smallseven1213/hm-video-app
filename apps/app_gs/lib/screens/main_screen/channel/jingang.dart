// JingangList
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/channel_data_controller.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/apis/jingang_api.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/circle_sidimage_text_item.dart';

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

final logger = Logger();

class JingangButton extends StatelessWidget {
  final JingangDetail? item;
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

class JingangList extends StatelessWidget {
  final int channelId;
  JingangList({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChannelDataController channelDataController =
        Get.find<ChannelDataController>(
            tag: 'channelId-${channelId.toString()}');

    if (channelDataController.channelData.value == null) {
      return const SliverToBoxAdapter(child: SizedBox());
    }
    return Obx(() {
      Jingang? jingang = channelDataController.channelData.value!.jingang;
      // print('channelId $channelId jingang: $jingang');
      if (jingang == null ||
          jingang.jingangDetail == null ||
          jingang.jingangDetail!.isEmpty) {
        return const SliverToBoxAdapter(child: SizedBox());
      }
      return SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        sliver: SliverAlignedGrid.count(
          crossAxisCount: 4,
          itemCount: jingang.jingangDetail?.length ?? 0,
          itemBuilder: (BuildContext context, int index) => JingangButton(
            item: jingang.jingangDetail![index],
            outerFrame: jingang.outerFrame ?? OuterFrame.border.value,
            outerFrameStyle:
                jingang.outerFrameStyle ?? OuterFrameStyle.circle.index,
          ),
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 10.0,
        ),
      );
    });
  }
}
