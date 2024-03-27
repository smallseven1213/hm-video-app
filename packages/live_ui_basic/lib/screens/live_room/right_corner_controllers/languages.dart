import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        height: MediaQuery.of(context).padding.bottom + 500,
        width: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
        // child is listview, from liveRoomController.liveRoom.trans
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 18),
                Text(
                  localizations.translate('language'),
                  style: const TextStyle(color: Colors.white),
                ),
                // close button
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Image(
                        image: AssetImage(
                            "packages/live_ui_basic/assets/images/room_close.webp"),
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (liveRoomController.liveRoom.value?.trans == null) {
                  return const SizedBox();
                }

                var trans = liveRoomController.liveRoom.value!.trans;
                var currentTranslate =
                    liveRoomController.currentTranslate.value;

                return ListView.separated(
                  itemCount: trans.length + 1,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 1,
                      color: Colors.white,
                    );
                  },
                  padding: const EdgeInsets.only(left: 23, right: 23),
                  itemBuilder: (BuildContext context, int index) {
                    var tran = index > 0 ? trans[index - 1] : null;
                    var isSelected = false;
                    if (index == 0) {
                      isSelected = currentTranslate == null;
                    } else {
                      isSelected = currentTranslate?.code == tran?.code;
                    }
                    return InkWell(
                      onTap: () {
                        if (index == 0) {
                          liveRoomController.setCurrentTranslate(null);
                          return;
                        }
                        liveRoomController.setCurrentTranslate(tran);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 15, bottom: 15),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              index == 0
                                  ? localizations.translate('close')
                                  : tran!.name,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.purple : Colors.white,
                              ),
                            ),
                            isSelected
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Image(
                                        image: AssetImage(
                                            "packages/live_ui_basic/assets/images/room_is_followed_icon.webp"),
                                        width: 12,
                                        height: 12),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ));
  }
}
