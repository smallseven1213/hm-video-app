import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/live_search_controller.dart';
import '../models/streamer_profile.dart';

class PopularStreamersProvider extends StatefulWidget {
  final Widget Function(List<StreamerProfile> streamer) child;
  const PopularStreamersProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  PopularStreamersState createState() => PopularStreamersState();
}

class PopularStreamersState extends State<PopularStreamersProvider> {
  final LiveSearchController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(controller.popularStreamers));
  }
}
