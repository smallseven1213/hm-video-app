import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/supplier_controller.dart';
import '../../controllers/user_favorites_supplier_controller.dart';
import '../../models/supplier.dart';

class UserFavoritesSupplierConsumer extends StatelessWidget {
  final Widget Function(bool isLike, VoidCallback handleLike) child;
  final Supplier info;
  final int id;
  final String actionType; // 'follow' or 'collect'

  const UserFavoritesSupplierConsumer({
    Key? key,
    required this.child,
    required this.info,
    required this.id,
    required this.actionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supplierController =
        Get.put(SupplierController(supplierId: id), tag: id.toString());
    final userFavoritesSupplierController =
        Get.find<UserFavoritesSupplierController>();

    return Obx(() {
      final isLiked =
          userFavoritesSupplierController.suppliers.any((e) => e.id == id);

      void handleLike() {
        if (isLiked) {
          userFavoritesSupplierController.removeSupplier([id]);
          supplierController.decrementTotal(actionType);
        } else {
          userFavoritesSupplierController.addSupplier(info);
          supplierController.incrementTotal(actionType);
        }
      }

      return child(isLiked, handleLike);
    });
  }
}
