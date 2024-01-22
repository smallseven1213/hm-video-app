import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChannelSkeleton extends StatelessWidget {
  const ChannelSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color baseColor = Color(0xFF003068);

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
                  highlightColor: const Color(0xFF00234d),
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
                            decoration: const BoxDecoration(
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
                    highlightColor: const Color(0xFF00234d),
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
