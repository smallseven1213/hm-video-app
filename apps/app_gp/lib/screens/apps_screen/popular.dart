import 'package:flutter/material.dart';
import 'package:shared/apis/ads_api.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:url_launcher/url_launcher.dart';

class PopularWidget extends StatelessWidget {
  const PopularWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AdsApi().getRecommendBy(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // var newList 是 snapshot.data 重複100次
          final List newList = [];
          for (var i = 0; i < 10000; i++) {
            newList.addAll(snapshot.data);
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        AdsApi().addBannerClickRecord(snapshot.data[index].id);
                        launchUrl(snapshot.data[index].url);
                      },
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SidImage(
                                // sid: snapshot.data[index].photoSid,
                                sid: newList[index].photoSid,
                                width: 60,
                                height: 60,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  // snapshot.data[index].name,
                                  newList[index].name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            // 按鈕
                            Container(
                              width: 52,
                              height: 23,
                              margin: const EdgeInsets.only(top: 20),
                              decoration: const BoxDecoration(
                                color: Color(0xffFFC700),
                                // 左右邊都是圓角15
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.file_download,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      '下載',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index != snapshot.data.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Divider(
                          height: 1,
                          color: Color(0xFF7AA2C8),
                        ),
                      ),
                  ],
                );
              },
              // childCount: snapshot.data.length,
              childCount: newList.length,
            ),
          );
        } else {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
