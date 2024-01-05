import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/live_search_controller.dart';
import '../models/streamer_profile.dart';

class FansRecommendProvider extends StatefulWidget {
  final Widget Function(List<StreamerProfile> streamer) child;
  const FansRecommendProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  FansRecommendState createState() => FansRecommendState();
}

class FansRecommendState extends State<FansRecommendProvider> {
  final LiveSearchController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(controller.fansRecommend));
  }
}
