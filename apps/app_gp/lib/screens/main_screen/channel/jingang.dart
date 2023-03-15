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

    return Column(children: [
      Container(
        width: 65,
        height: 65,
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
                print('JingangButton onTap');
                // todo
                // record jingang click item?.id
                // open jingang link
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
      return const SizedBox();
    }
    return Obx(() {
      Jingang? jingang = channelDataController.channelData[channelId]!.jingang;
      print('channelId $channelId jingang: $jingang');
      if (jingang == null ||
          jingang.jingangDetail == null ||
          jingang.jingangDetail!.isEmpty) {
        return const SizedBox();
      }
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(jingang.title ?? '',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                )),
            jingang.jingangStyle == JingangStyle.multiLine.index
                ? GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    crossAxisSpacing: 30,
                    // mainAxisSpacing: jingang.quantity == 4 ? 16 : 24,
                    physics: NeverScrollableScrollPhysics(),
                    childAspectRatio: 1,
                    children: List.generate(
                      jingang.jingangDetail!.length,
                      (index) {
                        return JingangButton(
                          item: jingang.jingangDetail![index],
                          outerFrame:
                              jingang.outerFrame ?? OuterFrame.border.value,
                          outerFrameStyle: jingang.outerFrameStyle ??
                              OuterFrameStyle.circle.index,
                        );
                      },
                    ),
                  )
                : Container(
                    height: 100,
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(children: [
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: jingang.jingangDetail!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: index == 0
                                    ? const EdgeInsets.only(left: 8, right: 12)
                                    : index == jingang.jingangDetail!.length - 1
                                        ? const EdgeInsets.only(
                                            left: 12, right: 8)
                                        : const EdgeInsets.symmetric(
                                            horizontal: 12),
                                child: JingangButton(
                                  item: jingang.jingangDetail![index],
                                  outerFrame: jingang.outerFrame ??
                                      OuterFrame.border.value,
                                  outerFrameStyle: jingang.outerFrameStyle ??
                                      OuterFrameStyle.circle.index,
                                ));
                          },
                        ),
                      ),
                    ]),
                  ),
          ],
        ),
      );
    });
  }
}
