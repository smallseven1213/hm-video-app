import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/ad_banner.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';

class VideoEmbeddedAdWidget extends StatelessWidget {
  final Data detail;
  final double? imageRatio;
  const VideoEmbeddedAdWidget({
    Key? key,
    required this.detail,
    this.imageRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BannerLink(
          url: detail.adUrl ?? '',
          id: detail.id ?? 0,
          child: Column(
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: imageRatio ?? 182 / 101.93,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      foregroundDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.3),
                          ],
                          stops: const [0.9, 1.0],
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: SidImage(
                        width: double.infinity,
                        height: double.infinity,
                        sid: detail.coverHorizontal ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: SidImage(
                            sid: detail.appIcon ?? '',
                            width: 35,
                            height: 35,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                detail.title ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              detail.titleSub ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFC700),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.shade700.withOpacity(0.6),
                          blurRadius: 5,
                        ),
                      ], // 圓角大小
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.download,
                          color: Colors.black,
                          size: 10,
                        ),
                        SizedBox(width: 1),
                        Text(
                          '立刻下載',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
