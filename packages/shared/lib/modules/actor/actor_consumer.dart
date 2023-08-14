import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/actor_controller.dart';
import '../../models/actor.dart';

class ActorConsumer extends StatefulWidget {
  final int id;
  final Widget Function(Actor actor) child;
  const ActorConsumer({
    Key? key,
    required this.child,
    required this.id,
  }) : super(key: key);

  @override
  ActorPageState createState() => ActorPageState();
}

class ActorPageState extends State<ActorConsumer> {
  late ActorController actorController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    actorController = Get.find<ActorController>(tag: 'actor-${widget.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(actorController.actor.value));
  }
}
