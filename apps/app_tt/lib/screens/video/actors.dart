import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/actor.dart';
import 'package:shared/navigator/delegate.dart';

import '../../widgets/actor_avatar.dart';
import '../../widgets/title_header.dart';

class Actors extends StatelessWidget {
  final List<Actor> actors;

  const Actors({super.key, required this.actors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
            padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
            child: TitleHeader(text: '同演員')),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 44.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actors.length,
            itemBuilder: (context, index) {
              Actor actor = actors[index];
              return GestureDetector(
                onTap: () {
                  MyRouteDelegate.of(context).push(
                    AppRoutes.actor,
                    args: {
                      'id': actor.id,
                      'title': actor.name,
                    },
                    removeSamePath: true,
                  );
                },
                child: Row(
                  children: <Widget>[
                    ActorAvatar(
                      photoSid: actor.photoSid,
                      width: 44,
                      height: 44,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      actor.name,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF939393),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
