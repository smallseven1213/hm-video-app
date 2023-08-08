import 'package:flutter/material.dart';
import 'package:app_gs/widgets/carousel.dart';
import 'package:shared/modules/channel/channel_banners_consumer.dart';

class ChannelBanners extends StatelessWidget {
  final int channelId;
  const ChannelBanners({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChannelBannersConsumer(
      channelId: channelId,
      child: (banners) => banners.isEmpty
          ? const SliverToBoxAdapter(child: SizedBox.shrink())
          : SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Carousel(
                  images: banners,
                  ratio: 359 / 170,
                ),
              ),
            ),
    );
  }
}
