import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/actor_latest_vod_controller.dart';

import '../../models/vod.dart';

final logger = Logger();

class ActorLatestVideosConsumer extends StatefulWidget {
  final int id;
  final Widget Function(List<Vod> vodList, bool displayLoading,
      bool displayNoMoreData, bool isListEmpty, Function() onLoadMore) child;
  const ActorLatestVideosConsumer({
    Key? key,
    required this.id,
    required this.child,
  }) : super(key: key);

  @override
  ActorLatestVideosConsumerState createState() =>
      ActorLatestVideosConsumerState();
}

class ActorLatestVideosConsumerState extends State<ActorLatestVideosConsumer> {
  late ActorLatestVodController actorLatestVodController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();

    actorLatestVodController = ActorLatestVodController(actorId: widget.id);
  }

  @override
  void dispose() {
    actorLatestVodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return widget.child(
        actorLatestVodController.vodList,
        actorLatestVodController.displayLoading.value,
        actorLatestVodController.displayNoMoreData.value,
        actorLatestVodController.vodList.isEmpty,
        actorLatestVodController.loadMoreData,
      );
    });
  }
}
