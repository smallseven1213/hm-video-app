import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class ChannelSettingPage extends StatefulWidget {
  const ChannelSettingPage({Key? key}) : super(key: key);

  @override
  _ChannelSettingPageState createState() => _ChannelSettingPageState();
}

class _ChannelSettingPageState extends State<ChannelSettingPage> {
  List<int> selectedIds = [];
  final box = gss();
  bool isEditing = false;
  List<int> editingChannels = [];

  @override
  void initState() {
    int layoutId = int.parse(Get.parameters['layoutId'] as String);
    String saved = box.hasData("layout-$layoutId-channels")
        ? box.read("layout-$layoutId-channels")
        : '';
    selectedIds = saved.isEmpty
        ? selectedIds
        : saved.split(',').map((e) => int.parse(e)).toList();
    super.initState();
  }

  void clear() {
    setState(() {
      selectedIds = [];
    });
  }

  void changeEditMode(bool editing) {
    setState(() {
      isEditing = editing;
      editingChannels = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    int layoutId = int.parse(Get.parameters['layoutId'] as String);
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          // title: Text(widget.title),
          backgroundColor: mainBgColor,
          shadowColor: Colors.transparent,
          toolbarHeight: 48,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: mainBgColor,
          ),
          leading: InkWell(
            onTap: () {
              back();
            },
            enableFeedback: true,
            child: const Icon(
              Icons.arrow_back_ios,
              size: 14,
            ),
          ),
          title: Stack(
            children: [
              Transform(
                transform: Matrix4.translationValues(-26, 0, 0),
                child: const Center(
                  child: Text(
                    '自訂頻道設置',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.translationValues(0, 0, 0),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          if (!isEditing) {
                            vdModals(
                              context: context,
                              title: '還原預設',
                              content: '是否還原系統預設頻道',
                              actions: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: gs().width,
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: color6,
                                      ),
                                      child: const Text('取消'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        selectedIds = [];
                                        String channels = selectedIds.join(',');
                                        box.write("layout-$layoutId-channels",
                                            selectedIds.join(','));
                                        box.save();
                                        Get.find<VChannelController>()
                                            .setCustomChannels(channels);
                                        back();
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: color1,
                                      ),
                                      child: const Text('確認'),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 20,
                          alignment: Alignment.center,
                          // decoration: BoxDecoration(color: Colors.red),
                          child: Text(
                            '預設',
                            style: TextStyle(
                              fontSize: 14,
                              color: isEditing ? color5 : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 1,
                        indent: 5,
                        endIndent: 5,
                      ),
                      InkWell(
                        onTap: () {
                          changeEditMode(!isEditing);
                        },
                        child: Container(
                          width: 40,
                          height: 20,
                          alignment: Alignment.center,
                          // decoration: BoxDecoration(color: Colors.red),
                          child: const Text(
                            '編輯',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
      body: SafeArea(
        child: FutureBuilder<List<Channel>>(
          future: Get.find<ChannelProvider>().getManyByLayout(layoutId),
          builder: (context, snapshot) {
            List<List<Channel>> recursiveItems = [[]];
            List<Channel> originChannels = [];
            if (snapshot.hasData) {
              List<Channel> channels = snapshot.data ?? [];
              // print(channels);
              originChannels = channels;
              if (selectedIds.isNotEmpty) {
                channels = channels
                    .where((element) => selectedIds.contains(element.id))
                    .toList();
              } else {
                selectedIds = channels.map((e) => e.id).toList();
              }
              int i = 0;
              for (var item in channels) {
                if (recursiveItems[i].length >= 4) {
                  i++;
                  recursiveItems.add([]);
                }
                recursiveItems[i].add(item);
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: Text('我的頻道'),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: recursiveItems
                                    .asMap()
                                    .map(
                                      (idx, epl) => MapEntry(
                                        idx,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: epl
                                              .map(
                                                (e) => GestureDetector(
                                                  onTap: () {
                                                    if (isEditing && idx > 0) {
                                                      setState(() {
                                                        selectedIds.removeWhere(
                                                            (element) =>
                                                                element ==
                                                                e.id);
                                                      });
                                                    }
                                                  },
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                          top: 5,
                                                          bottom: 5,
                                                          left: 4,
                                                          right: 4,
                                                        ),
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 12,
                                                          right: isEditing &&
                                                                  idx > 0
                                                              ? 16
                                                              : 12,
                                                          top: 4,
                                                          bottom: 4,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: isEditing &&
                                                                  idx > 0
                                                              ? color7
                                                              : Colors
                                                                  .transparent,
                                                          border: Border.all(
                                                            color: color7,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      6.0),
                                                        ),
                                                        child: Text(e.name),
                                                      ),
                                                      !isEditing || idx == 0
                                                          ? const SizedBox
                                                              .shrink()
                                                          : const Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: SizedBox(
                                                                width: 22,
                                                                height: 22,
                                                                child: VDIcon(
                                                                  VIcons.delete,
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    )
                                    .values
                                    .toList(),
                              )),
                        ),
                      ],
                    ),
                    ...(!isEditing
                        ? []
                        : [
                            VDExpandablePanel(
                              title: '更多頻道',
                              selectedIds: [],
                              expandable: false,
                              recursiveCount: 4,
                              onSelected: (v) {
                                if (isEditing) {
                                  setState(() {
                                    selectedIds.addAll(v);
                                  });
                                }
                              },
                              request: (s) => Future.value(originChannels
                                  .where((element) =>
                                      !selectedIds.contains(element.id))
                                  .map((e) => VDExpandableItem(
                                        id: e.id,
                                        name: '+ ${e.name}',
                                      ))
                                  .toList()),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            !isEditing
                                ? const SizedBox.shrink()
                                : InkWell(
                                    onTap: () {
                                      String channels = selectedIds.join(',');
                                      box.write("layout-$layoutId-channels",
                                          selectedIds.join(','));
                                      box.save();
                                      Get.find<VChannelController>()
                                          .setCustomChannels(channels);
                                      gato('/default');
                                    },
                                    enableFeedback: true,
                                    child: Container(
                                      width: gs().width - 30,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        color: color1,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        '設置完成',
                                        style: TextStyle(),
                                      ),
                                    ),
                                  ),
                          ])
                  ],
                ),
              );
            }
            return const VDLoading();
          },
        ),
      ),
    );
  }
}
