import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/supplier_controller.dart';
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

    late SupplierController supplierController;

    bool isExists = Get.isRegistered<SupplierController>(tag: 'supplier-${id}');
    if (isExists) {
      supplierController = Get.find<SupplierController>(tag: 'supplier-${id}');
    } else {
      supplierController =
          Get.put(SupplierController(supplierId: id), tag: 'supplier-${id}');
    }

    return Obx(() {
      var isLiked =
          userFavoritesSupplierController.suppliers.any((e) => e.id == id);

      handleLike() {
        if (isLiked) {
          userFavoritesSupplierController.removeSupplier([id]);
          supplierController.decrementTotal('follow');
          return;
        } else {
          userFavoritesSupplierController.addSupplier(info);
          supplierController.incrementTotal('follow');
        }
      }

      return child(isLiked, handleLike);
    });
  }
}
