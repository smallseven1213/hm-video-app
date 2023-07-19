import 'package:flutter/material.dart';
import 'package:shared/apis/ads_api.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:url_launcher/url_launcher.dart';

class PopularWidget extends StatelessWidget {
  const PopularWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AdsApi().getManyBy(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        dynamic idDynamic = snapshot.data[index].id;
                        int id;

                        if (idDynamic is String) {
                          id = int.parse(idDynamic);
                        } else if (idDynamic is int) {
                          id = idDynamic;
                        } else {
                          throw 'Invalid data type for id';
                        }
                        AdsApi().addBannerClickRecord(id);
                        String urlString = snapshot.data[index].url;
                        Uri url = Uri.parse(urlString);
                        launchUrl(url);
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
                                sid: snapshot.data[index].photoSid,
                                width: 60,
                                height: 60,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data[index].name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        snapshot.data[index].description,
                                        style: const TextStyle(
                                          color: Color(0xff7AA2C8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )),
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
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          'assets/images/apps_download.png'),
                                      height: 11.0,
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
              childCount: snapshot.data.length,
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
