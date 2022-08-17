import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

import '../models/user_promote.dart';
import '../models/user_promote_record.dart';
import '../providers/user_provider.dart';

class ShareHistoryPage extends StatefulWidget {
  const ShareHistoryPage({Key? key}) : super(key: key);

  @override
  _ShareHistoryPageState createState() => _ShareHistoryPageState();
}

class _ShareHistoryPageState extends State<ShareHistoryPage> {

  int page = 1;
  int limit = 10;
  int total = 0;
  bool loading = false;
  List<UserPromoteRecord> searchedRecord = [];
  List<Widget> recordList = [];
  double width2 = (gs().width) / 2.51;
  double width1 = (gs().width) - ((gs().width) / 2.51) *2;
  var dateFormat = DateFormat('yyyy/MM/dd HH:mm');
  @override
  void initState() {
    recordList.add(SizedBox(
      height: 42,
        child: Row(
          children: [
            buildC("暱稱", width2, color7),
            buildC("類型", width1, color7),
            buildC("加入時間", width2, color7),
          ],
        )
    ));
    recordList.add(
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Center(
            child: Text(
              '沒有更多了',
              style: TextStyle(color: color5),
            ),
          ),
        )
    );
    recordList.add(
        Align(
            child:
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color7,
                borderRadius: BorderRadius.circular(8.0),
              ),
              width: (gs().width) -32,
              child: Column(
                children: const [
                  SizedBox(height: 12,),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "溫馨提示",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),)
                  ),
                  SizedBox(height: 8,),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "1.邀請 1 好友成功並且註冊會員，就送 1 天免費觀看，無限累積！",
                          style:  TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: color2)
                      ),
                  ),

                  SizedBox(height: 4,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child:  Text(
                        "2.同一裝置僅計算一次成功註冊，重複註冊無法獲得獎勵。",
                        style:  TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: color2)
                    ),
                  ),
                  SizedBox(height: 12,),
                ],
              ),
            )
        ));
    loadShareRecord();
    super.initState();
  }

  void loadShareRecord() {
    setState(() {
      if (!loading) {
        // loading = true;
        Get.find<UserProvider>()
            .getPromoteRecord(
          page: page,
          limit: limit,
        ) .then((value) {
          if (searchedRecord.length < page) {
            setState(() {
              searchedRecord.addAll(value.record);
              total = value.total;
              value.record.asMap().forEach((index, e) => {
                recordList.insert(recordList.length -2 ,SizedBox(
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        buildC(e.nickname, width2, Colors.transparent),
                        buildC(e.roles[0].toString() == "member" ? "會員" : "訪客", width1, Colors.transparent),
                        buildC(dateFormat.format(DateTime.parse(e.createdAt)).toString(), width2, Colors.transparent),
                      ],
                    ),
                  )
                )),
              });

              loading = false;
            });
          }

          return value;
        });
      }
    });
  }

  Container buildC(String text, double  width, Color color) {
   return Container(
     width: width,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: color,
        border: const Border(
          bottom: BorderSide(width: 1.5,
              color: color7),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
      ),
    );
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
            gto('/member');
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
              child: Center(
                child: Text(
                  '推廣紀錄',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
            future: Get.find<UserProvider>().getUserPromote(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Container();
              }
              UserPromote userPromote = snapshot.data;
              String promotedMembers = userPromote.promotedMembers.toString();
              String changed = userPromote.changed.toString();
              return IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 18,
                          bottom: 19,
                        ),
                        child: Column(
                          children:  [
                            Text(
                              "$promotedMembers人",
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text(
                              '已推廣',
                              style: TextStyle(
                                fontSize: 13,
                                color: color4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 1,
                      indent: 27,
                      endIndent: 27,
                      color: color23,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 18,
                          bottom: 19,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "$changed天",
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            const Text(
                              '已獲得免費看',
                              style: TextStyle(
                                fontSize: 13,
                                color: color4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Expanded(
              child:
              Padding(
              padding: const EdgeInsets.only(
                bottom: 19,
              ),
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo is ScrollEndNotification &&
                      scrollInfo.metrics.extentAfter == 0) {
                    setState(() {
                      if (!loading) {
                        if (total >=
                            searchedRecord.length) {
                          page = page + 1;
                        }
                        loadShareRecord();
                      }
                    });
                    // print(scrollInfo);
                    return true;
                  }
                  return false;
                },
                child: ListView.builder(
                  cacheExtent: 55,
                  primary: false,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (_bctx, idx) {
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Wrap(
                            spacing: 15,
                            runSpacing: 2,
                            children: recordList,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            ),

          ],
        )
      ),
    );
  }
}
