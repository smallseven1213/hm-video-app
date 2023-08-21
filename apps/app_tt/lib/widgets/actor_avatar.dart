import 'package:app_tt/config/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
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
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: kIsWeb
            ? null
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00B2FF),
                  Color(0xFFCCEAFF),
                  Color(0xFF00B2FF),
                ],
              ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Stack(
            children: [
              Container(
                width: width,
                height: height,
                color: const Color(0xfff0f0f0),
                child: const Center(
                  child: Icon(
                    Icons.face_3,
                    size: 54,
                    color: Color(0xfff3a0a9),
                  ),
                ),
              ),
              if (photoSid != null && photoSid != '')
                SidImage(
                    key: ValueKey(photoSid),
                    sid: photoSid!,
                    width: width,
                    height: height,
                    fit: BoxFit.cover)
            ],
          ),
        ),
      ),
    );
  }
}
