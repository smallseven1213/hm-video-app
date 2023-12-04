import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/commands_controller.dart';

class Resize extends StatelessWidget {
  const Resize({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
              child: Commands(),
            );
          },
        );
      },
      child: Image.asset(
          'packages/live_ui_basic/assets/images/resize_button.webp',
          width: 33,
          height: 33),
    );
  }
}

// TESTING
class Commands extends StatelessWidget {
  const Commands({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final commandsController = Get.put(CommandsController());
    return Container(
      height: 200,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: commandsController.commands.value.length,
          itemBuilder: (context, index) {
            var command = commandsController.commands.value[index];
            return SizedBox(
              width: 100,
              height: 100,
              child: Column(
                children: [
                  Text(command.name),
                  // price
                  Text(command.price.toString()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
