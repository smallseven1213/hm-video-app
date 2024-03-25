import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clipboard/clipboard.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';

import '../../../localization/live_localization_delegate.dart';

class Languages extends StatelessWidget {
  final int pid;
  const Languages({super.key, required this.pid});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return LanguagesView(pid: pid);
          },
        );
      },
      child: Image.asset(
          'packages/live_ui_basic/assets/images/language_button.webp',
          width: 33,
          height: 33),
    );
  }
}

class LanguagesView extends StatelessWidget {
  final int pid;
  const LanguagesView({super.key, required this.pid});

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;
    final LiveRoomController liveRoomController =
        Get.find<LiveRoomController>(tag: pid.toString());

    return Container(
        height: MediaQuery.of(context).padding.bottom + 200,
        width: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
        // child is listview, from liveRoomController.liveRoom.trans
        child: Obx(() {
          if (liveRoomController.liveRoom.value?.trans == null) {
            return const SizedBox();
          }

          var trans = liveRoomController.liveRoom.value!.trans;

          // list from languages
          return ListView.builder(
            itemCount: trans.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  FlutterClipboard.copy(trans[index].code).then((value) {
                    Fluttertoast.showToast(
                      msg: "ok",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black.withOpacity(0.8),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    trans[index].name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          );
        }));
  }
}
