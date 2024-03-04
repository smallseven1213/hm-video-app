import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_controller.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/supplier.dart';
import 'package:shared/modules/supplier/supplier_consumer.dart';
import 'package:shared/modules/user/user_favorites_supplier_consumer.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../../config/colors.dart';
import '../../widgets/float_page_search_button.dart';
import '../../widgets/header_follow_button.dart';
import '../../widgets/header_info.dart';
import '../../widgets/search_button.dart';

class SupplierHeader extends SliverPersistentHeaderDelegate {
  final BuildContext context;
  final int id;

  SupplierHeader({
    required this.context,
    required this.id,
  });

  @override
  double get minExtent {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return kToolbarHeight + statusBarHeight;
  }

  @override
  double get maxExtent =>
      100 + kToolbarHeight + MediaQuery.of(context).padding.top;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final shouldShowAppBar = shrinkOffset >= 100;
    final double percentage = shrinkOffset / maxExtent;
    final double imageSize = lerpDouble(80, kToolbarHeight - 20, percentage)!;
    SupplierController supplierController =
        Get.find<SupplierController>(tag: 'supplier-$id');

    return shouldShowAppBar
        ? SupplierConsumer(
            id: id,
            child: (Supplier info) => AppBar(
              backgroundColor: AppColors.colors[ColorKeys.background],
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              elevation: 0,
              title: UserFavoritesSupplierConsumer(
                id: id,
                info: info,
                child: (isLiked, handleLike) => HeaderFollowButton(
                  isLiked: isLiked,
                  handleLike: () {
                    handleLike!();
                    if (isLiked) {
                      supplierController.decrementTotal('follow');
                      return;
                    } else {
                      supplierController.incrementTotal('follow');
                    }
                  },
                  photoSid: info.photoSid ?? '',
                ),
              ),
              centerTitle: false,
              // actions: const <Widget>[SearchButton()],
            ),
          )
        : SizedBox(
            height: maxExtent - shrinkOffset,
            child: SupplierConsumer(
              id: id,
              child: (Supplier info) => Container(
                  padding: EdgeInsets.only(
                      top: kIsWeb ? 10 : MediaQuery.of(context).padding.top),
                  child: Stack(
                    children: [
                      ActorHeaderInfo(
                        name: info.aliasName ?? '',
                        id: info.id ?? 0,
                        photoSid: info.photoSid ?? '',
                        percentage: percentage,
                        imageSize: imageSize,
                      ),
                      // const FloatPageBackButton(),
                      // const FloatPageSearchButton()
                    ],
                  )),
            ),
          );
  }

  @override
  bool shouldRebuild(covariant SupplierHeader oldDelegate) {
    return false;
  }
}
