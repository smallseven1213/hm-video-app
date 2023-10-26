import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/actor_controller.dart';

class ActorProvider extends StatefulWidget {
  final int id;
  final Widget child;
  const ActorProvider({
    Key? key,
    required this.child,
    required this.id,
  }) : super(key: key);

  @override
  ActorPageState createState() => ActorPageState();
}

class ActorPageState extends State<ActorProvider> {
  late ActorController actorController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    actorController = Get.put(ActorController(actorId: widget.id),
        tag: 'actor-${widget.id}', permanent: true);
  }

  @override
  void dispose() {
    // actorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
