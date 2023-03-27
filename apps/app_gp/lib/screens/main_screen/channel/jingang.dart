// JingangList
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_data_controller.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/apis/jingang_api.dart';
import 'package:url_launcher/url_launcher.dart';

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

    return Column(children: [
      Container(
        width: size.width * 0.15,
        height: size.width * 0.13,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            borderRadius: isRounded
                ? BorderRadius.circular(40)
                : BorderRadius.circular(5),
            boxShadow: hasBorder
                ? [
                    BoxShadow(
                      color: const Color.fromRGBO(69, 110, 255, 1),
                      blurRadius: isRounded ? 10 : 8,
                    ),
                  ]
                : null,
            gradient: hasBorder
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isRounded
                        ? const [
                            Color(0xff00B2FF),
                            Color(0xffCCEAFF),
                            Color(0xff0075FF),
                          ]
                        : const [
                            Color(0xff000000),
                            Color(0xff00145B),
                            Color(0xff000000),
                          ],
                    stops: isRounded ? null : [0, 0.99, 1.0])
                : null),
        child: Container(
            margin: isRounded ? const EdgeInsets.all(1) : null,
            decoration: BoxDecoration(
              borderRadius: isRounded
                  ? BorderRadius.circular(40)
                  : BorderRadius.circular(5),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                print('item: ${item?.id}   ${item?.url}${item?.toJson()}');
                jingangApi.recordJingangClick(item?.id ?? 0);
                if (item!.url!.startsWith('http://') ||
                    item!.url!.startsWith('https://')) {
                  launch(item!.url ?? '', webOnlyWindowName: '_blank');
                } else {
                  MyRouteDelegate.of(context).push(item!.url ?? '');
                }
              },
              child: SidImage(
                sid: item?.photoSid ?? '',
              ),
            )),
      ),
      Text(item?.name ?? '',
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 255, 255, 255),
          )),
    ]);
  }
}

class JingangList extends StatelessWidget {
  final int channelId;
  JingangList({Key? key, required this.channelId}) : super(key: key);
  final ChannelDataController channelDataController =
      Get.find<ChannelDataController>();

  @override
  Widget build(BuildContext context) {
    if (channelDataController.channelData[channelId] == null) {
      return const SliverToBoxAdapter(child: SizedBox());
    }
    return Obx(() {
      Jingang? jingang = channelDataController.channelData[channelId]!.jingang;
      // print('channelId $channelId jingang: $jingang');
      if (jingang == null ||
          jingang.jingangDetail == null ||
          jingang.jingangDetail!.isEmpty) {
        return const SliverToBoxAdapter(child: SizedBox());
      }
      return SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 30,
            childAspectRatio: 0.95,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return JingangButton(
                item: jingang.jingangDetail![index],
                outerFrame: jingang.outerFrame ?? OuterFrame.border.value,
                outerFrameStyle:
                    jingang.outerFrameStyle ?? OuterFrameStyle.circle.index,
              );
            },
            childCount: jingang.jingangDetail!.length,
          ),
        ),
      );
    });
  }
}
