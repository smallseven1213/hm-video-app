import 'package:flutter/material.dart';
import 'package:live_core/models/streamer.dart';
import 'package:live_core/models/streamer_profile.dart';
import '../../pages/search.dart';
import 'package:live_core/widgets/fans_recommend_provider.dart';

import 'streamer_profile_card.dart';

class FanRecommendationWidget extends StatelessWidget {
  const FanRecommendationWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return FansRecommendProvider(
      child: (List<StreamerProfile> streamer) {
        if (streamer.isEmpty) {
          return const SliverToBoxAdapter(
              child: SizedBox.shrink()); // 或者顯示一個加載中的指示器
        }
        return SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 每行顯示兩個項目
            childAspectRatio: 1, // 正方形項目
            crossAxisSpacing: 10, // 水平間隔
            mainAxisSpacing: 10, // 垂直間隔
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => StreamerProfileCard(
              profile: streamer[index],
              showFollowButton: true,
              showFansCount: true,
            ),
            childCount: streamer.length,
          ),
        );
      },
    );
  }
}
