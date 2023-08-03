import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/widgets/sid_image.dart';

class ActorAvatar extends StatelessWidget {
  final double width;
  final double height;
  const ActorAvatar({
    Key? key,
    this.photoSid,
    this.width = 60,
    this.height = 60,
  }) : super(key: key);

  final String? photoSid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      width: width,
      height: height,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: kIsWeb
              ? [Color(0xFF00B2FF)]
              : [
                  Color(0xFF00B2FF),
                  Color(0xFFCCEAFF),
                  Color(0xFF00B2FF),
                ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: photoSid != null && photoSid != ''
            ? SidImage(
                key: ValueKey(photoSid),
                sid: photoSid!,
                fit: BoxFit.cover,
                width: width,
                height: height,
              )
            : Image(
                image: const AssetImage('assets/images/empty_avatar.png'),
                fit: BoxFit.cover,
                width: width,
                height: height,
              ),
      ),
    );
  }
}
