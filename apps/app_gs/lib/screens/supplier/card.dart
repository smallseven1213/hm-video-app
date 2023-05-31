import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_controller.dart';
import 'package:shared/models/supplier.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../widgets/actor_avatar.dart';

class SupplierCard extends StatelessWidget {
  final int id;
  const SupplierCard({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supplierController = SupplierController(
      supplierId: id,
    );
    return Obx(() {
      if (supplierController.supplier.value.id == null) {
        return SliverToBoxAdapter(
          child: SizedBox.shrink(),
        );
      }
      return SliverPersistentHeader(
          delegate: SupplierHeaderDelegate(
              supplier: supplierController.supplier.value, context: context),
          pinned: true);
    });
  }
}

class SupplierHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Supplier supplier;
  final BuildContext context;

  SupplierHeaderDelegate({
    required this.supplier,
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
    // final UserFavoritesActorController userFavoritesActorController =
    // Get.find<UserFavoritesActorController>();

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

    return Container(
      color: const Color(0xFF001a40).withOpacity(1 - opacity),
      child: Stack(
        children: [
          const Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/supplier_card_bg.webp'),
              fit: BoxFit.fill,
            ),
          ),
          if (opacity > 0)
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(67, 120, 220, 0.65),
                    Color(0xFF001C46),
                  ],
                  stops: [
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
                120,
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
              top: 148,
              left: 107,
              child: SizedBox(
                  width: screenWidth - 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(supplier.shortVideoTotal.toString(),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(supplier.collectTotal.toString(),
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(supplier.followTotal.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  )),
                              const SizedBox(width: 5),
                              const Text('點讚',
                                  style: TextStyle(
                                    color: Color(0xFFD4D4D4),
                                    fontSize: 12,
                                  ))
                            ],
                          ))
                    ],
                  ))),
          // Positioned(
          //   top: lerpDouble(
          //       105, (kToolbarHeight - 12) / 2 + fontSize, percentage),
          //   right: 8,
          //   child: Obx(() {
          //     // var isLiked = userFavoritesActorController.actors
          //     //     .any((e) => e.id == actor.id);
          //     var isLiked = false;
          //     IconData iconData =
          //         isLiked ? Icons.favorite_sharp : Icons.favorite_outline;
          //     return Opacity(
          //       opacity: opacity,
          //       child: InkWell(
          //         onTap: () {
          //           // if (isLiked) {
          //           //   userFavoritesActorController.removeActor([actor.id]);
          //           //   return;
          //           // } else {
          //           //   userFavoritesActorController.addActor(actor);
          //           // }
          //         },
          //         child: Row(
          //           children: [
          //             Icon(
          //               iconData,
          //               size: 20,
          //               color: const Color(0xFF21AFFF),
          //             ),
          //             const SizedBox(width: 6),
          //             Text(
          //               supplier.followTotal.toString(),
          //               style: const TextStyle(
          //                 fontSize: 12,
          //                 color: Colors.white,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   }),
          // ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SupplierHeaderDelegate oldDelegate) {
    return oldDelegate.supplier != supplier || oldDelegate.context != context;
  }
}
