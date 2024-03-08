import 'dart:collection';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:live_core/controllers/gifts_controller.dart';
import 'package:live_core/models/chat_message.dart';
import 'package:live_core/socket/live_web_socket_manager.dart';

class ChatResultController extends GetxController {
  final LiveSocketIOManager socketManager = LiveSocketIOManager();
  final GiftsController giftsController = Get.find<GiftsController>();
  var giftCenterMessagesQueue = <ChatMessage<ChatGiftMessageObjChatData>>[].obs;
  var giftLeftSideMessagesQueue =
      <ChatMessage<ChatGiftMessageObjChatData>>[].obs;
  var commonMessages = <ChatMessage>[].obs;
  Queue<ChatMessage<ChatGiftMessageObjChatData>> centerGiftAnimationQueue =
      Queue();

  @override
  void onInit() {
    socketManager.socket!.on('chatresult', (data) => handleChatResult(data));
    super.onInit();
  }

  void handleChatResult(dynamic data) {
    var decodedData = jsonDecode(data);
    List<ChatMessage> newMessages = (decodedData as List).map((item) {
      if (item['objChat']['ntype'] == 3) {
        return ChatMessage<ChatGiftMessageObjChatData>.fromJson(item);
      } else {
        return ChatMessage<String>.fromJson(item);
      }
    }).toList();

    for (var message in newMessages) {
      if (message.objChat.ntype == MessageType.gift) {
        var giftMesssage = message as ChatMessage<ChatGiftMessageObjChatData>;
        if (giftMesssage.objChat.data.animationLayout == 2 ||
            giftMesssage.objChat.data.animationLayout == 3) {
          giftCenterMessagesQueue.value = [
            ...giftCenterMessagesQueue.value,
            giftMesssage
          ];
        } else if (giftMesssage.objChat.data.animationLayout == 1) {
          giftLeftSideMessagesQueue.value = [
            ...giftLeftSideMessagesQueue.value,
            giftMesssage
          ];
          // for (var i = 0; i < message.objChat.data.quantity; i++) {
          //   giftLeftSideMessagesQueue.value = [
          //     ...giftLeftSideMessagesQueue.value,
          //     giftMesssage..objChat.data.currentQuantity = i + 1
          //   ];
          // }
        }
      }

      commonMessages.value = [...commonMessages, message];
    }
  }

  @override
  void onClose() {
    socketManager.socket!.off('chatresult');
    super.onClose();
  }

  ChatMessage<ChatGiftMessageObjChatData>?
      removeGiftLeftSideMessagesQueueByIndex(int index) {
    try {
      var giftMessage = giftLeftSideMessagesQueue.value.removeAt(index);
      giftLeftSideMessagesQueue.refresh();
      return giftMessage;
    } catch (e) {
      return null;
    }
  }

  // removeGiftCenterMessagesQueue by index
  void removeGiftCenterMessagesQueueByIndex(int index) {
    try {
      giftCenterMessagesQueue.value.removeAt(index);
      giftCenterMessagesQueue.refresh();
    } catch (e) {}
  }
}
