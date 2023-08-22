import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';

class TagWidget extends StatelessWidget {
  final int id;
  final String name;
  final bool outerFrame;
  final String? photoSid;
  final int film;
  final int channelId;

  const TagWidget({
    super.key,
    required this.id,
    required this.name,
    required this.outerFrame,
    required this.film,
    required this.channelId,
    this.photoSid,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyRouteDelegate.of(context).push(
          AppRoutes.videoByBlock,
          args: {
            'blockId': id,
            'title': '#$name',
            'channelId': channelId,
            'film': film,
          },
        );
      },
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              photoSid != null && outerFrame == false
                  ? SidImage(sid: photoSid!)
                  : Container(
                      color: const Color(0xFFf9f9f9),
                    ),
              // outerFrame == false
              //     ? Container(
              //         width: 100, // 你可以根据需要设置宽度
              //         height: 100, // 你可以根据需要设置高度
              //         decoration: BoxDecoration(
              //           color:
              //               const Color.fromRGBO(0, 0, 0, 0.7), // 设置背景颜色为半透明的黑色
              //           borderRadius:
              //               BorderRadius.circular(10), // 如果需要圆角，你可以设置这个属性
              //         ),
              //       )
              //     : Container(),
              Center(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF50525a),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
