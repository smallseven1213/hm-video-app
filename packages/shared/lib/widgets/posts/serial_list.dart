import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/post_detail.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/posts/post_stats.dart';
import '../../../localization/shared_localization_delegate.dart';

class SerialListWidget extends StatelessWidget {
  final List<Series> series;
  final int totalChapter;

  const SerialListWidget({
    Key? key,
    required this.series,
    required this.totalChapter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      SharedLocalizations localizations = SharedLocalizations.of(context)!;
    if (series.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xfff4cdca),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                localizations.translate('serialization'),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                '${localizations.translate('serializing_to_number')}$totalChapter${localizations.translate('episode')}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff919bb3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  ...series.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final Series serial = entry.value;
                    return InkWell(
                      onTap: () {
                        MyRouteDelegate.of(context).push(
                          AppRoutes.post,
                          args: {'id': serial.id},
                          removeSamePath: true,
                        );
                      },
                      child: Container(
                        width: 156,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xff1c202f),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        margin: const EdgeInsets.only(right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${localizations.translate('number')}${serial.currentChapter}${localizations.translate('episode')}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.darkText,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              serial.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.darkText,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
