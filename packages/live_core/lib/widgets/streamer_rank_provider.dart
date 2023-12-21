import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/streamer_rank_controller.dart';
import '../models/streamer_rank.dart';

class StreamerRankProvider extends StatefulWidget {
  final RankType rankType;
  final TimeType timeType;
  final Widget Function(
    List<StreamerRank> streamerRank,
    Function(RankType, TimeType) updateCallback,
  ) child;

  const StreamerRankProvider({
    Key? key,
    required this.child,
    required this.rankType,
    required this.timeType,
  }) : super(key: key);

  @override
  StreamerRankState createState() => StreamerRankState();
}

class StreamerRankState extends State<StreamerRankProvider> {
  late StreamerRankController streamerRankController;

  @override
  void initState() {
    super.initState();
    print('@@@: initState ${widget.rankType}, ${widget.timeType}');
    streamerRankController = Get.put(
      StreamerRankController(
        rankType: widget.rankType,
        timeType: widget.timeType,
      ),
      tag: 'StreamerRank_${widget.rankType.index}_${widget.timeType.index}',
    );
  }

  void updateRanking(RankType rankType, TimeType timeType) {
    streamerRankController = Get.put(
      StreamerRankController(
        rankType: rankType,
        timeType: timeType,
      ),
      tag: 'StreamerRank_${rankType.index}_${timeType.index}',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(
          streamerRankController.streamerRanks.value,
          updateRanking,
        ));
  }
}
