import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_favorites_supplier_controller.dart';
import '../../models/supplier.dart';

class UserFavoritesSupplierConsumer extends StatelessWidget {
  final Widget Function(bool isLike, void Function()? handleLike) child;
  final Supplier info;
  final int id;

  const UserFavoritesSupplierConsumer({
    Key? key,
    required this.child,
    required this.info,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserFavoritesSupplierController userFavoritesSupplierController =
        Get.find<UserFavoritesSupplierController>();

    return Obx(() {
      var isLiked =
          userFavoritesSupplierController.suppliers.any((e) => e.id == id);

      handleLike() {
        if (isLiked) {
          userFavoritesSupplierController.removeSupplier([id]);
          return;
        } else {
          userFavoritesSupplierController.addSupplier(info);
        }
      }

      return child(isLiked, handleLike);
    });
  }
}
