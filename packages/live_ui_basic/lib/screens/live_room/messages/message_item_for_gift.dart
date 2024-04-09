import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/models/chat_message.dart';
import '../../../localization/live_localization_delegate.dart';

class MessageItemForGift extends StatelessWidget {
  final ChatMessage<ChatGiftMessageObjChatData> message;

  const MessageItemForGift({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;

    final giftsController = Get.find<GiftsController>();
    var gifts = giftsController.gifts.value
        .where((element) => element.id == message.objChat.data.gid)
        .toList();

    if (gifts.isEmpty) {
      return Container();
    }
    var giftName = gifts.first.name;
    var messageText =
        "${localizations.translate('send_gift')} $giftName x${message.objChat.data.quantity}";
    var animationLayout = message.objChat.data.animationLayout;
    var textColor = animationLayout == 3
        ? const Color(0xFFffa900)
        : const Color(0xFFcc706a);
    var containerBackgroundColor = animationLayout == 3
        ? const Color(0x4dffa700)
        : const Color(0x65242a3d);

    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // vertical top
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ClipOval(
          //     child: Container(
          //         width: 25.0,
          //         height: 25.0,
          //         color: Colors.black,
          //         child: message.objChat.avatar == ""
          //             ? SvgPicture.asset(
          //                 'packages/live_ui_basic/assets/svgs/default_avatar.svg',
          //                 fit: BoxFit.cover,
          //               )
          //             : // message.objChat.avatar use Image remote
          //             Image.network(
          //                 message.objChat.avatar,
          //                 fit: BoxFit.cover,
          //               ))),
          // const SizedBox(width: 6),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 120,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: containerBackgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(5),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: message.objChat.name!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                    const WidgetSpan(
                      child: SizedBox(width: 10), // 提供固定的 10 單位空間
                    ),
                    TextSpan(
                      text: messageText,
                      style: TextStyle(color: textColor, fontSize: 12),
                    ),
                    // const WidgetSpan(
                    //   child: SizedBox(width: 10), // 提供固定的 10 單位空間
                    // ),
                    // TextSpan(
                    //   text: formatTimestamp(message.timestamp),
                    //   style: TextStyle(color: textColor, fontSize: 12),
                    // ),
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
