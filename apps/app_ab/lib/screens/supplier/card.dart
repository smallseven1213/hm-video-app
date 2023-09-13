import 'dart:ui';

import 'package:app_ab/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_controller.dart';
import 'package:shared/controllers/user_favorites_supplier_controller.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/supplier.dart';
import 'package:shared/utils/video_info_formatter.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../widgets/actor_avatar.dart';

class SupplierCard extends StatefulWidget {
  final int id;

  const SupplierCard({Key? key, required this.id}) : super(key: key);

  @override
  SupplierCardState createState() => SupplierCardState();
}

class SupplierCardState extends State<SupplierCard> {
  late final SupplierController supplierController;

  @override
  void initState() {
    super.initState();
    supplierController = Get.put(SupplierController(supplierId: widget.id),
        tag: widget.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (supplierController.supplier.value.id == null) {
        return const SliverToBoxAdapter(
          child: SizedBox.shrink(),
        );
      }
      return SliverPersistentHeader(
          delegate: SupplierHeaderDelegate(
            supplierController: supplierController,
            context: context,
          ),
          pinned: true);
    });
  }
}

class SupplierHeaderDelegate extends SliverPersistentHeaderDelegate {
  final SupplierController supplierController;
  final BuildContext context;
  final userFavoritesSupplierController =
      Get.find<UserFavoritesSupplierController>();

  SupplierHeaderDelegate({
    required this.supplierController,
    required this.context,
  });

  @override
  double get minExtent {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return kToolbarHeight + statusBarHeight;
  }

  @override
  double get maxExtent =>
      200; // You can adjust this value for the initial height of the ActorCard

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Supplier supplier = supplierController.supplier.value;

    final double opacity = 1 - shrinkOffset / maxExtent;
    final double percentage = shrinkOffset / maxExtent;

    final double imageSize = lerpDouble(80, kToolbarHeight - 20, percentage)!;
    final double fontSize = lerpDouble(18, 15, percentage)!;

    final screenWidth = MediaQuery.of(context).size.width;
    final textPainter = TextPainter(
      text: TextSpan(
        text: supplier.aliasName ?? '--',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textWidth = textPainter.width;
    final systemTopBarHeight = MediaQuery.of(context).padding.top;
    final leftPadding = (screenWidth - imageSize - textWidth - 8) / 2;
    final bool hasDescription =
        supplier.description != null && supplier.description!.isNotEmpty;

    return Container(
      color: AppColors.colors[ColorKeys.primary],
      child: Stack(
        children: [
          // const Positioned.fill(
          //   child: Image(
          //     image: AssetImage('assets/images/supplier_card_bg.webp'),
          //     fit: BoxFit.fill,
          //   ),
          // ),
          if (supplier.coverVertical != null)
            Opacity(
              opacity: opacity,
              child: SidImage(
                key: ValueKey(supplier.coverVertical),
                sid: supplier.coverVertical!,
                width: 500,
                height: 500,
                fit: BoxFit.cover,
              ),
            ),
          if (opacity > 0)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xff46454a).withOpacity(0.65),
                    const Color(0xff1c1c1c),
                  ],
                  stops: const [
                    -0.06,
                    1.0,
                  ],
                ),
              ),
            ),
          Positioned(
            top: lerpDouble(
                100,
                ((kToolbarHeight - imageSize) / 2) + systemTopBarHeight,
                percentage),
            left: lerpDouble(17, leftPadding, percentage)!,
            child: ActorAvatar(
              photoSid: supplier.photoSid,
              width: imageSize,
              height: imageSize,
            ),
          ),
          Positioned(
            top: lerpDouble(
                108,
                ((kToolbarHeight - fontSize) / 2) + systemTopBarHeight,
                percentage),
            left: lerpDouble(107, leftPadding + imageSize + 8, percentage)!,
            child: Text(
              '@${supplier.aliasName}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: Colors.white),
            ),
          ),
          Positioned(
              top: 135,
              left: 90,
              child: SizedBox(
                  width: screenWidth - 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasDescription)
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 8),
                          child: Text(
                            supplier.description ?? '',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      formatNumberToUnit(
                                          supplier.videoCount ?? 0),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 5),
                                  const Text('長視頻',
                                      style: TextStyle(
                                        color: Color(0xFFD4D4D4),
                                        fontSize: 12,
                                      ))
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      formatNumberToUnit(
                                          supplier.shortVideoTotal ?? 0),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 5),
                                  const Text('短視頻',
                                      style: TextStyle(
                                        color: Color(0xFFD4D4D4),
                                        fontSize: 12,
                                      ))
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      formatNumberToUnit(
                                          supplier.collectTotal ?? 0),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 5),
                                  const Text('收藏',
                                      style: TextStyle(
                                        color: Color(0xFFD4D4D4),
                                        fontSize: 12,
                                      ))
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Text(supplier.followTotal.toString(),
                                  //     style: const TextStyle(
                                  //       color: Colors.white,
                                  //       fontWeight: FontWeight.w500,
                                  //       fontSize: 15,
                                  //     )),
                                  Obx(() => Text(
                                      formatNumberToUnit(supplierController
                                              .supplier.value.followTotal ??
                                          0),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ))),
                                  const SizedBox(width: 5),
                                  const Text('點讚',
                                      style: TextStyle(
                                        color: Color(0xFFD4D4D4),
                                        fontSize: 12,
                                      ))
                                ],
                              ))
                        ],
                      ),
                    ],
                  ))),
          Positioned(
            top: lerpDouble(
                114, (kToolbarHeight - 12) / 2 + fontSize, percentage),
            right: 8,
            child: Obx(() {
              var isLiked = userFavoritesSupplierController.suppliers
                  .any((e) => e.id == supplier.id);
              IconData iconData =
                  isLiked ? Icons.favorite_sharp : Icons.favorite_outline;
              return Opacity(
                opacity: opacity,
                child: GestureDetector(
                  onTap: () {
                    if (isLiked) {
                      userFavoritesSupplierController
                          .removeSupplier([supplier.id!]);
                      supplierController.decrementTotal('follow');
                      return;
                    } else {
                      userFavoritesSupplierController.addSupplier(supplier);
                      supplierController.incrementTotal('follow');
                    }
                  },
                  child: Row(
                    children: [
                      Opacity(
                        opacity: 0,
                        child: Text(
                          supplier.followTotal.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Icon(
                        iconData,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SupplierHeaderDelegate oldDelegate) {
    return oldDelegate.context != context;
  }
}
