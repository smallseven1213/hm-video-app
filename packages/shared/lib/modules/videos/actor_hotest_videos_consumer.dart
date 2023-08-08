import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/actor_hottest_vod_controller.dart';

import '../../models/vod.dart';

final logger = Logger();

class ActorHottestVideosConsumer extends StatefulWidget {
  final int id;
  final Widget Function(List<Vod> vodList, bool displayLoading,
      bool displayNoMoreData, bool isListEmpty, Function() onLoadMore) child;
  const ActorHottestVideosConsumer({
    Key? key,
    required this.id,
    required this.child,
  }) : super(key: key);

  @override
  ActorHottestVideosConsumerState createState() =>
      ActorHottestVideosConsumerState();
}

class ActorHottestVideosConsumerState
    extends State<ActorHottestVideosConsumer> {
  late ActorHottestVodController actorHottestVodController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();

    actorHottestVodController = ActorHottestVodController(actorId: widget.id);
  }

  @override
  void dispose() {
    actorHottestVodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return widget.child(
        actorHottestVodController.vodList,
        actorHottestVodController.displayLoading.value,
        actorHottestVodController.displayNoMoreData.value,
        actorHottestVodController.vodList.isEmpty,
        actorHottestVodController.loadMoreData,
      );
    });
  }
}
