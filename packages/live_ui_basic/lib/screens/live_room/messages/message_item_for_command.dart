import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/commands_controller.dart';
import 'package:live_core/models/chat_message.dart';

class MessageItemForCommand extends StatelessWidget {
  final ChatMessage<String> message;

  const MessageItemForCommand({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commandsController = Get.find<CommandsController>();
    var commandText = commandsController.commands.value
        .firstWhere((element) => element.id == int.parse(message.objChat.data))
        .name;
    var messageText = "${message.objChat.name} 發送指令 : $commandText";

    return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 120,
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          height: 25,
          // radius 12.5
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.5),
            color: const Color(0x65ae57ff),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipOval(
                  child: Container(
                      width: 25.0,
                      height: 25.0,
                      color: Colors.black,
                      child: message.objChat.avatar == ""
                          ? SvgPicture.asset(
                              'packages/live_ui_basic/assets/svgs/default_avatar.svg',
                              fit: BoxFit.cover,
                            )
                          : // message.objChat.avatar use Image remote
                          Image.network(
                              message.objChat.avatar,
                              fit: BoxFit.cover,
                            ))),
              const SizedBox(width: 6),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: messageText,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )); // Placeholder for actual UI
  }
}
