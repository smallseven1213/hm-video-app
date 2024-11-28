import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../models/product.dart';

enum ProductType {
  none,
  coin,
  vip,
}

class SupplierSubscription extends StatefulWidget {
  final int type;
  final Widget Function(List<Product> subscription) child;
  const SupplierSubscription({
    Key? key,
    required this.child,
    required this.type,
  }) : super(key: key);

  @override
  SubscriptionPageState createState() => SubscriptionPageState();
}

class SubscriptionPageState extends State<SupplierSubscription> {
  late ProductController productController;

  @override
  void initState() {
    super.initState();
    productController = Get.put(ProductController(type: widget.type),
        tag: 'product-${widget.type}');
    //要記得改成判斷是否是第一次put

    //     if (!Get.isRegistered<ProductController>()) {
    //   Get.put(ProductController(),
    //       tag: 'product-${widget.type}');
    // }
    // productController = Get.find<ProductController>(
    //     tag: 'product-${widget.type}');
    // productController.initCollection(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(productController.products));
  }
}
