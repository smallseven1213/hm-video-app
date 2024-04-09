import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:clipboard/clipboard.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_room_controller.dart';
import 'package:live_core/models/live_room.dart';

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

class LanguagesView extends StatefulWidget {
  final int pid;

  const LanguagesView({Key? key, required this.pid}) : super(key: key);

  @override
  _LanguagesViewState createState() => _LanguagesViewState();
}

class _LanguagesViewState extends State<LanguagesView> {
  Language? selectedLanguage;

  @override
  void initState() {
    super.initState();
    final LiveRoomController liveRoomController =
        Get.find<LiveRoomController>(tag: widget.pid.toString());
    selectedLanguage = liveRoomController
        .currentTranslate.value; // 假设currentTranslate是Language类型
  }

  @override
  Widget build(BuildContext context) {
    final LiveLocalizations localizations = LiveLocalizations.of(context)!;
    final LiveRoomController liveRoomController =
        Get.find<LiveRoomController>(tag: widget.pid.toString());

    return Container(
        height: MediaQuery.of(context).padding.bottom + 500,
        width: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
        child: Column(
          children: [
            // height 20
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 18),
                Text(
                  localizations.translate('language'),
                  style: const TextStyle(color: Colors.white),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        liveRoomController
                            .setCurrentTranslate(selectedLanguage);
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
                return ListView.separated(
                  itemCount: trans.length + 1,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(height: 1, color: Colors.white);
                  },
                  padding: const EdgeInsets.only(left: 23, right: 23),
                  itemBuilder: (BuildContext context, int index) {
                    var tran = index > 0 ? trans[index - 1] : null;
                    var isSelected = (index == 0 && selectedLanguage == null) ||
                        (tran != null && selectedLanguage?.code == tran.code);

                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (index == 0) {
                            selectedLanguage = null;
                          } else {
                            selectedLanguage = tran;
                          }
                        });
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
            ),
          ],
        ));
  }
}
