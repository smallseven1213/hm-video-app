import 'package:app_wl_id1/localization/i18n.dart';
import 'package:app_wl_id1/widgets/random_game_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'slider.dart';

class ChannelStyle6Suppliers extends StatelessWidget {
  const ChannelStyle6Suppliers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var safeAreaTop = MediaQuery.of(context).padding.top;
    return CustomScrollView(
      slivers: [
        // height 60
        SliverToBoxAdapter(
          child: SizedBox(
            height: 60 + safeAreaTop,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
              // padding x 20
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                I18n.selectedUp,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              )),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 7,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
              // padding x 20
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                I18n.followedUpUserSeeMoreVideo,
                style: const TextStyle(
                  color: Color(0xFFcfcece),
                  fontSize: 14,
                ),
              )),
        ),
        SliverToBoxAdapter(
          child: const SizedBox(
            height: 20,
          ),
        ),
        SliverToBoxAdapter(
          child: const SupplierSlider(),
        ),
        SliverToBoxAdapter(
          child: const SizedBox(
            height: 20,
          ),
        ),
        SliverToBoxAdapter(
          child: const RandomGameArea(),
        ),
      ],
    );
  }
}
