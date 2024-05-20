import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shimmer/shimmer.dart';

class LiveSkeleton extends StatelessWidget {
  const LiveSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color baseColor = Colors.white.withOpacity(0.2);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            kIsWeb
                ? AspectRatio(
                    aspectRatio: 341 / 143,
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
                      aspectRatio: 341 / 143,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(6, (index) {
                  return kIsWeb
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: 80,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: baseColor, // 使用您的 baseColor 代替
                          ),
                        )
                      : Shimmer.fromColors(
                          baseColor: baseColor, // 使用您的 baseColor 代替
                          highlightColor: Colors.white,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: 80,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue, // 使用您的 baseColor 代替
                            ),
                          ),
                        );
                }),
              ),
            ),
            const SizedBox(height: 10),
            // GridView.builder(
            //   padding: const EdgeInsets.all(10),
            //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2, // 每行顯示兩個項目
            //     childAspectRatio: 1, // 正方形項目
            //     crossAxisSpacing: 10, // 水平間隔
            //     mainAxisSpacing: 10, // 垂直間隔
            //   ),
            //   itemCount: 4, // 只顯示4個項目
            //   itemBuilder: (context, index) {
            //     if (kIsWeb) {
            //       return Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           color: baseColor,
            //         ),
            //       );
            //     }
            //     return Shimmer.fromColors(
            //       baseColor: baseColor,
            //       highlightColor: Colors.white,
            //       child: Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           color: baseColor,
            //         ),
            //       ),
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
