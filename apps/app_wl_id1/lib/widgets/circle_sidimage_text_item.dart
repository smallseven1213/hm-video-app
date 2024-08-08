import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/widgets/sid_image.dart';

class CircleTextItem extends StatelessWidget {
  final String text;
  final double imageWidth;
  final double imageHeight;
  final bool isRounded;
  final bool hasBorder;
  final String photoSid;
  final Function()? onTap;
  final int? maxLines;

  const CircleTextItem({
    Key? key,
    required this.text,
    this.imageWidth = 60,
    this.imageHeight = 60,
    this.isRounded = true,
    this.hasBorder = true,
    required this.photoSid,
    this.maxLines = 2,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: imageWidth,
        height: imageHeight,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: kIsWeb
            ? BoxDecoration(
                borderRadius: isRounded
                    ? BorderRadius.circular(40)
                    : BorderRadius.circular(5),
                color: hasBorder ? const Color(0xFF00b2ff) : null,
              )
            : BoxDecoration(
                borderRadius: isRounded
                    ? BorderRadius.circular(40)
                    : BorderRadius.circular(5),
                gradient: !kIsWeb && hasBorder
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
            child: GestureDetector(
              onTap: onTap,
              child: SidImage(
                key: ValueKey(photoSid),
                sid: photoSid,
              ),
            )),
      ),
      Text(text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 255, 255, 255),
          )),
    ]);
  }
}
