import 'package:flutter/material.dart';

import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/actor.dart';
import 'package:shared/navigator/delegate.dart';

import '../../../widgets/circle_sidimage_text_item.dart';

class VideoActor extends StatefulWidget {
  final List<Actor>? actors;
  const VideoActor({super.key, required this.actors});

  @override
  State<VideoActor> createState() => _VideoActorState();
}

class _VideoActorState extends State<VideoActor> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.26,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.actors?.length ?? 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              MyRouteDelegate.of(context).push(
                AppRoutes.actor,
                args: {
                  'id': widget.actors![index].id,
                  'title': widget.actors![index].name,
                },
                removeSamePath: true,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
              child: CircleTextItem(
                text: widget.actors![index].name,
                photoSid: widget.actors![index].photoSid,
                imageWidth: 60,
                imageHeight: 60,
                isRounded: true,
                hasBorder: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
