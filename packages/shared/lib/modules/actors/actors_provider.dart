import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/actors_controller.dart';

final logger = Logger();

class ActorsProvider extends StatefulWidget {
  final Widget child;
  const ActorsProvider({Key? key, required this.child}) : super(key: key);
  @override
  ActorsProviderState createState() => ActorsProviderState();
}

class ActorsProviderState extends State<ActorsProvider> {
  late ActorsController actorsController;

  @override
  void initState() {
    super.initState();
    actorsController = Get.put(ActorsController());
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
