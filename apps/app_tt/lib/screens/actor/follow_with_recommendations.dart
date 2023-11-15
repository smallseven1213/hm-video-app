import 'package:app_tt/screens/actor/profile_cards.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/actor_controller.dart';
import 'package:shared/controllers/actors_controller.dart';
import 'package:shared/models/actor.dart';
import 'package:shared/modules/user/user_favorites_actor_consumer.dart';

class FollowWithRecommendations extends StatefulWidget {
  final int id;
  final Actor actor;

  const FollowWithRecommendations({
    super.key,
    required this.id,
    required this.actor,
  });

  @override
  _FollowWithRecommendationsState createState() =>
      _FollowWithRecommendationsState();
}

class _FollowWithRecommendationsState extends State<FollowWithRecommendations> {
  late ActorsController actorsController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // 在這裡創建 ActorsController 的實例
    actorsController = Get.put(
      ActorsController(
        initialIsRecommend: true,
        initialLimit: 20,
        initialRegion: widget.actor.regionId,
      ),
      tag: 'actor-${widget.id}',
    );
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        actorsController.fetchUnfollowedActors();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ActorController actorController =
        Get.put(ActorController(actorId: widget.id), tag: 'actor-${widget.id}');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: UserFavoritesActorConsumer(
                id: widget.id,
                info: widget.actor,
                child: (isLiked, handleLike) => InkWell(
                  onTap: () {
                    handleLike!();
                    if (isLiked) {
                      actorController.decrementActorCollectTimes();
                      return;
                    } else {
                      actorController.incrementActorCollectTimes();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 36,
                    decoration: BoxDecoration(
                      color: isLiked
                          ? const Color(0xfff1f1f2)
                          : const Color(0xfffe2c55),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isLiked ? '已關注' : '+ 關注',
                      style: TextStyle(
                        fontSize: 13,
                        color: isLiked ? const Color(0xff161823) : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFf1f1f2),
                borderRadius: BorderRadius.circular(4.0),
              ),
              width: 36,
              height: 36,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                    _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                color: Colors.black,
                onPressed: _toggleExpand,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_isExpanded)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '你可能感興趣',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color(0xff73747b), fontSize: 13),
                ),
                const SizedBox(height: 10),
                ProfileCards(regionId: widget.actor.regionId, id: widget.id)
              ],
            ),
          ),
      ],
    );
  }
}
