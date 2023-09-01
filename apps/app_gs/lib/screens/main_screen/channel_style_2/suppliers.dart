import 'package:app_gs/widgets/actor_avatar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_recommends_controller.dart';
import 'package:shared/controllers/user_favorites_supplier_controller.dart';
import 'package:shared/widgets/sid_image.dart';

class ChannelStyle2Suppliers extends StatelessWidget {
  ChannelStyle2Suppliers({Key? key}) : super(key: key);

  final controller = Get.put(SupplierRecommendsController());
  var userFavoritesSupplierController =
      Get.find<UserFavoritesSupplierController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Center(
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: false,
            viewportFraction: 0.6,
            aspectRatio: 1.32,
            enlargeCenterPage: true,
            initialPage: 1,
          ),
          items: controller.suppliers
              .map((supplier) => Container(
                    key: ValueKey(supplier.id),
                    width: 280,
                    height: 370,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20), // 设置圆角
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SidImage(
                            sid: supplier.coverVertical ?? "",
                            width: 280,
                            height: 370,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // delete button to exec removeSupplierById
                        Positioned(
                          top: 15,
                          right: 15,
                          child: InkWell(
                            onTap: () {
                              controller.removeSupplierById(supplier.id ?? 0);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter, // 由下往上（置底）
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // 使用最小的空间
                            mainAxisAlignment: MainAxisAlignment.center, // 居中对齐
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
                                },
                                child: Container(
                                  width: 175,
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFfe2c55),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: const Text(
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
                  ))
              .toList(),
        ),
      );
    });
  }
}
