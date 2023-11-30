import 'package:flutter/material.dart';
import 'package:live_core/models/room_rank.dart';
import 'package:live_core/widgets/rank_provider.dart';

import 'top_controllers/rank_data.dart';
import 'top_controllers/rank_list.dart';

class TopControllers extends StatelessWidget {
  const TopControllers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RankProvider(
      child: (RoomRank? roomRank) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Column(
          // align left
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Room Info
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black,
                    ),
                    width: 135,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                            child: Column(
                          // vertical center
                          mainAxisAlignment: MainAxisAlignment.center,
                          // horizal left
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("用戶ID",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 10,
                                )),
                            Text("112,142",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                ))
                          ],
                        )),
                        Container(
                          width: 30,
                          height: 30,
                          child: Center(
                            child: Container(
                              width: 25,
                              height: 25,
                              child: Image(
                                image: AssetImage(
                                    "packages/live_ui_basic/assets/images/room_add_icon.webp"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: RankList(
                      roomRank: roomRank,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const SizedBox(
                      width: 30,
                      height: 30,
                      child: Center(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: Image(
                            image: AssetImage(
                                "packages/live_ui_basic/assets/images/room_close.webp"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // width 7
                  const SizedBox(width: 7),
                ],
              ),
            ),
            // height 10
            const SizedBox(height: 10),
            RankData(
              roomRank: roomRank,
            )
          ],
        ),
      ),
    );
  }
}
