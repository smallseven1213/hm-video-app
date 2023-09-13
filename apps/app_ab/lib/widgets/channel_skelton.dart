import 'package:app_ab/config/colors.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shimmer/shimmer.dart';

class ChannelSkeleton extends StatelessWidget {
  const ChannelSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color baseColor =
        AppColors.colors[ColorKeys.videoPreviewBg] ?? Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          kIsWeb
              ? AspectRatio(
                  aspectRatio: 374 / 180,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              : Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: Colors.white,
                  child: AspectRatio(
                    aspectRatio: 374 / 180,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 16),
          Expanded(
            child: kIsWeb
                ? GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: baseColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 12,
                            color: baseColor,
                          ),
                        ],
                      );
                    },
                  )
                : Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: Colors.white,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 4,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: 12,
                              color: Colors.grey,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
