import 'package:flutter/material.dart';
import 'package:shared/widgets/sid_image.dart';

/**
 * 給金剛區與角色選擇用的圓形按鈕+文字
 */
class CircleTextItem extends StatelessWidget {
  final String text;
  final double imageWidth;
  final double imageHeight;
  final bool isRounded;
  final bool hasBorder;
  final String photoSid;
  final Function()? onTap;

  const CircleTextItem({
    Key? key,
    required this.text,
    this.imageWidth = 60,
    this.imageHeight = 60,
    this.isRounded = true,
    this.hasBorder = true,
    required this.photoSid,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: imageWidth,
        height: imageHeight,
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
              onTap: onTap,
              child: SidImage(
                sid: photoSid,
              ),
            )),
      ),
      Text(text,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 255, 255, 255),
          )),
    ]);
  }
}
