import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/models/chat_message.dart';
import 'package:shared/models/gift_message_data.dart';

import '../../../libs/format_timestamp.dart';

class MessageItemForGift extends StatelessWidget {
  final ChatMessage<ChatGiftMessageObjChatData> message;

  const MessageItemForGift({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final giftsController = Get.find<GiftsController>();
    var giftName = giftsController.gifts.value
        .firstWhere((element) => element.id == message.objChat.data.gid)
        .name;
    var messageText = "${message.objChat.name} 贈送禮物 $giftName";

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // vertical top
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
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 120,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x65242a3d),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(5),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: messageText,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    WidgetSpan(
                      child: SizedBox(width: 10), // 提供固定的 10 單位空間
                    ),
                    TextSpan(
                      text: formatTimestamp(message.timestamp),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ); // Placeholder for actual UI
  }
}
