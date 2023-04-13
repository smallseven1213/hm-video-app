// HotWidget is a stateless widget, has FutureBuilder to get AdsApi.getManyBy

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/apis/ads_api.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:url_launcher/url_launcher.dart';

final logger = Logger();

class HotWidget extends StatelessWidget {
  const HotWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AdsApi().getManyBy(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              // mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return InkWell(
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
                  child: Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SidImage(
                            sid: snapshot.data[index].photoSid,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          snapshot.data[index].name,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
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
// 上方code, 改為statefull, 並在init call AdsApi().getManyBy()
// 並在build中, 用setState()更新snapshot.data


