import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../models/product.dart';

enum ProductType {
  none,
  coin,
  vip,
}

class ProductConsumer extends StatefulWidget {
  final int type;
  final Widget Function(List<Product> product) child;
  const ProductConsumer({
    Key? key,
    required this.child,
    required this.type,
  }) : super(key: key);

  @override
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductConsumer> {
  late ProductController productController;

  @override
  void initState() {
    super.initState();
    productController = Get.put(ProductController(type: widget.type),
        tag: 'product-${widget.type}');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(productController.products));
  }
}
