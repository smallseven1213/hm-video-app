import 'package:app_gs/widgets/actor_avatar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_recommends_controller.dart';
import 'package:shared/controllers/user_favorites_supplier_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/widgets/sid_image.dart';

class ChannelStyle6Suppliers extends StatelessWidget {
  ChannelStyle6Suppliers({Key? key}) : super(key: key);

  final controller = Get.put(SupplierRecommendsController());
  var userFavoritesSupplierController =
      Get.find<UserFavoritesSupplierController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
            crossAxisAlignment: CrossAxisAlignment.center, // 水平居中
            children: [
              const Text("精選UP主",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  )),
              // height 7
              const SizedBox(
                height: 7,
              ),
              const Text("關注某個UP主，以查看其最新影片。",
                  style: TextStyle(
                    color: Color(0xFFcfcece),
                    fontSize: 14,
                  )),
              const SizedBox(
                height: 20,
              ),
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: false,
                  viewportFraction: 0.6,
                  aspectRatio: 1.2,
                  enlargeCenterPage: true,
                  initialPage: 1,
                ),
                items: controller.suppliers
                    .map((supplier) => Container(
                          key: ValueKey(supplier.id),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20), // 设置圆角
                          ),
                          child: InkWell(
                            onTap: () {
                              MyRouteDelegate.of(context)
                                  .push(AppRoutes.supplier, args: {
                                'id': supplier.id,
                              });
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SidImage(
                                    sid: supplier.coverVertical ?? "",
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.5, 1.25],
                                        colors: [
                                          Colors.transparent,
                                          Colors.black,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 15,
                                  right: 15,
                                  child: InkWell(
                                    onTap: () {
                                      controller
                                          .removeSupplierById(supplier.id ?? 0);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter, // 由下往上（置底）
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min, // 使用最小的空间
                                    mainAxisAlignment:
                                        MainAxisAlignment.center, // 居中对齐
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center, // 居中对齐
                                    children: [
                                      ActorAvatar(
                                        photoSid: supplier.photoSid ?? "",
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        supplier.name ?? "",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   height: 3,
                                      // ),
                                      // Text(
                                      //   supplier.description ?? "",
                                      //   style: const TextStyle(
                                      //     color: Colors.white,
                                      //     fontSize: 16,
                                      //   ),
                                      // ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          userFavoritesSupplierController
                                              .addSupplier(supplier);
                                          controller.removeSupplierById(
                                              supplier.id ?? 0);
                                        },
                                        child: Container(
                                          width: 175,
                                          height: 44,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment
                                                  .topLeft, // 这里可以根据需要进行调整
                                              end: Alignment
                                                  .bottomRight, // 这里可以根据需要进行调整
                                              stops: [
                                                0.0,
                                                0.56
                                              ], // 对应于 CSS 的 0% 和 56%
                                              colors: [
                                                Color(
                                                    0xFFff6988), // 对应于 CSS 的 #ff6988
                                                Color(
                                                    0xFFf52c55), // 对应于 CSS 的 #f52c55
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '關注',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
        ));
  }
}
