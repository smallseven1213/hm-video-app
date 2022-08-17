import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/event.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../providers/envent_provider.dart';
import '../shard.dart';

class MessageCenterPage extends StatefulWidget {
  const MessageCenterPage({Key? key}) : super(key: key);

  @override
  _MessageCenterPageState createState() => _MessageCenterPageState();
}

class _MessageCenterPageState extends State<MessageCenterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final VTabCollection _tabCollection = VMemberMessageTabs();
  int _currentIndex = 0;
  bool isEditing = false;
  List<int> editingVods = [];
  List<Notice> notices = [];
  List<Event> events = [];
  List<Event> checkedEvents = [];

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      initialIndex: _currentIndex,
      length: _tabCollection.getTabs().length,
    );
    _tabController.addListener(_handleTabChanged);
    Get.find<NoticeProvider>().getMany().then((value) {
      setState(() {
        notices = value;
      });
    });

    Get.find<EventProvider>().getMany().then((value) {
      setState(() {
        events = value;
      });
    });
    SharedPreferencesUtil.setEventLatest([]);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  void changeEditMode(bool editing) {
    setState(() {
      isEditing = editing;
      editingVods = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
        backgroundColor: color1,
        shadowColor: Colors.transparent,
        toolbarHeight: 48,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: color1,
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
                  '消息中心',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              pinned: true,
              delegate: VDStickyTabBarDelegate(
                backgroundColor: color7,
                child: VDStickyTabBar(
                  tabController: _tabController,
                  currentIndex: _currentIndex,
                  controller: _tabCollection,
                  tabBarType: 2,
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: _tabCollection
              .getTabs()
              .map(
                (key, value) => MapEntry(
                  key,
                  key == 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: notices.length + 1,
                          itemBuilder: (_ctx, idx) {
                            var notice = idx > notices.length - 1
                                ? Notice(0, '')
                                : notices[idx];
                            return idx == notices.length
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Center(
                                      child: Text(
                                        '沒有更多紀錄',
                                        style: TextStyle(color: color5),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 10,
                                      left: 15,
                                      right: 0,
                                    ),
                                    child: VDExpandableBlock(
                                      header: Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 20),
                                        decoration: const BoxDecoration(
                                            color: Colors.transparent),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notice.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              DateFormat('yyyy/MM/dd HH:mm')
                                                  .format(DateTime.parse(notice
                                                      .startedAt
                                                      .toString())),
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: color5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      body: Column(
                                        children: [
                                          SingleChildScrollView(
                                            child: HtmlWidget(
                                              notice.content ?? '',
                                            ),
                                          ),
                                          // const Divider(),
                                        ],
                                      ),
                                    ),
                                  );
                          },
                        )
                      :  ListView.builder(
                    shrinkWrap: true,
                    itemCount: events.length + 1,
                    itemBuilder: (_ctx, idx) {
                      Event event = idx > events.length - 1
                          ? Event(0, '','','')
                          : events[idx];
                      return idx == events.length
                          ? const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: Text(
                            '沒有更多紀錄',
                            style: TextStyle(color: color5),
                          ),
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 13,
                          left: 24,
                          right: 24,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.transparent),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    event.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ), Spacer(),
                                  Checkbox(
                                      value: checkedEvents.contains(event),
                                      onChanged: (val) {
                                        if (checkedEvents.contains(event)) {
                                          checkedEvents.remove(event);
                                        } else {
                                          checkedEvents.add(event);
                                        }

                                        setState(() {

                                        });
                                      }),
                                ],
                              )
                              ,
                              const SizedBox(
                                height: 8,
                              ),Text(
                                event.content,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                DateFormat('yyyy/MM/dd HH:mm')
                                    .format(DateTime.parse(event
                                    .createdAt
                                    .toString())),
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: color5,
                                ),
                              ),
                            ],
                          ),
                        )
                      );
                    },
                  )
                ),
              )
              .values
              .toList(),
        ),
      )),
      bottomSheet: _tabController.index == 1
          ? Container(
        height: 90,
        alignment: Alignment.center,
        decoration:
        const BoxDecoration(color: Color.fromRGBO(0, 0, 0, .65)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  checkedEvents.clear();
                  checkedEvents.addAll(events);
                });
              },
              child: Container(
                width: (gs().width - 48) / 2,
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: color7,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Text(
                  '全選',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (checkedEvents.isNotEmpty) {
                  checkedEvents.forEach((element) {
                    events.remove(element);
                  });
                  await Get.find<EventProvider>()
                      .deleteEvent(checkedEvents.map((e) => e.id).toList());
                  checkedEvents.clear();
                }

                setState(() {});
              },
              child: Container(
                width: (gs().width - 48) / 2,
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: color1,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Text(
                  '刪除',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      )
          : null,
    );
  }
}
