import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../../config/colors.dart';

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
                      color: AppColors.colors[ColorKeys.buttonBgPrimary],
                    ),
              Center(
                child: Text(
                  name,
                  style: TextStyle(
                    color: AppColors.colors[ColorKeys.buttonTextPrimary],
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
