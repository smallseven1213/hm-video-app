import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/actor_controller.dart';

import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/actor.dart';
import 'package:shared/modules/actor/actor_consumer.dart';
import 'package:shared/modules/user/user_favorites_actor_consumer.dart';
import 'package:shared/navigator/delegate.dart';

import '../../widgets/actor/header_follow_button.dart';
import '../../widgets/actor/rounded_search_button.dart';
import '../../widgets/actor/search_button.dart';
import '../../widgets/actor_avatar.dart';
import '../../widgets/actor/header_info.dart';

class ActorHeader extends SliverPersistentHeaderDelegate {
  final BuildContext context;
  final int id;

  ActorHeader({
    required this.context,
    required this.id,
  });

  @override
  double get minExtent {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return kToolbarHeight + statusBarHeight;
  }

  @override
  double get maxExtent =>
      164 + kToolbarHeight + MediaQuery.of(context).padding.top;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final shouldShowAppBar = shrinkOffset >= 164;
    final double percentage = shrinkOffset / maxExtent;
    final double imageSize = lerpDouble(80, kToolbarHeight - 20, percentage)!;

    ActorController actorController =
        Get.find<ActorController>(tag: 'actor-${id}');

    return shouldShowAppBar
        ? ActorConsumer(
            id: id,
            child: (Actor info) => AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => MyRouteDelegate.of(context).pop(),
              ),
              elevation: 0,
              title: UserFavoritesActorConsumer(
                id: id,
                info: info,
                child: (isLiked, handleLike) => HeaderFollowButton(
                  isLiked: isLiked,
                  handleLike: () {
                    handleLike!();
                    if (isLiked) {
                      actorController.decrementActorCollectTimes();
                      return;
                    } else {
                      actorController.incrementActorCollectTimes();
                    }
                  },
                  photoSid: info.photoSid,
                ),
              ),
              centerTitle: false, // This will center the title
              actions: const <Widget>[SearchButton()],
            ),
          )
        : SizedBox(
            height: maxExtent - shrinkOffset,
            child: ActorConsumer(
              id: id,
              child: (Actor info) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Stack(
                    children: [
                      ActorHeaderInfo(
                        name: info.name,
                        id: info.id,
                        photoSid: info.photoSid,
                        percentage: percentage,
                        imageSize: imageSize,
                      ),
                      const RoundedSearchButton(),
                    ],
                  )),
            ),
          );
  }

  @override
  bool shouldRebuild(covariant ActorHeader oldDelegate) {
    return false;
  }
}
