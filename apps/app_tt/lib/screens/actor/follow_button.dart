import 'package:app_tt/screens/actor/profile_cards.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/actor.dart';
import 'package:shared/modules/user/user_favorites_actor_consumer.dart';


class FollowButton extends StatefulWidget {
  final int id;
  final Actor actor;

  const FollowButton({
    super.key,
    required this.id,
    required this.actor,
  });

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onTap: handleLike,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
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
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                  size: 24.0,
                ),
                onPressed: _toggleExpand,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_isExpanded)
          const AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '你可能感興趣',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color(0xff73747b), fontSize: 13),
                ),
                SizedBox(height: 10),
                ProfileCards()
              ],
            ),
          ),
      ],
    );
  }
}

