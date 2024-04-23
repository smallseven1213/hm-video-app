import 'package:app_wl_ph1/localization/i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';

class VideoEmbeddedAdWidget extends StatelessWidget {
  final Vod detail;
  final double imageRatio;
  final bool displayCoverVertical;
  const VideoEmbeddedAdWidget({
    Key? key,
    required this.detail,
    required this.imageRatio,
    this.displayCoverVertical = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BannerLink(
      url: detail.adUrl ?? '',
      id: detail.id,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 廣告封麵
          AspectRatio(
            aspectRatio: imageRatio,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius:
                    kIsWeb ? null : BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              foregroundDecoration: BoxDecoration(
                gradient: kIsWeb
                    ? null
                    : LinearGradient(
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
                sid: displayCoverVertical
                    ? detail.coverVertical ?? ''
                    : detail.coverHorizontal ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Icon
              if (imageRatio == 374 / 198) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SidImage(
                    sid: detail.appIcon ?? '',
                    width: 35,
                    height: 35,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              // 主標+副標
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 主標
                    Text(
                      detail.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                    // 副標
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
                ),
              ),
              if (imageRatio == 374 / 198) ...[
                // 下載按鈕
                const SizedBox(width: 8),
                Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.download, color: Colors.black, size: 10),
                      const SizedBox(width: 1),
                      Text(
                        I18n.downloadNow,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
