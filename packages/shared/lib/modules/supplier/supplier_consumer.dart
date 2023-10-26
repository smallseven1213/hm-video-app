import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/supplier_controller.dart';
import '../../models/supplier.dart';

class SupplierConsumer extends StatefulWidget {
  final int id;
  final Widget Function(Supplier supplier) child;
  const SupplierConsumer({
    Key? key,
    required this.child,
    required this.id,
  }) : super(key: key);

  @override
  SupplierPageState createState() => SupplierPageState();
}

class SupplierPageState extends State<SupplierConsumer> {
  late SupplierController supplierController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    supplierController =
        Get.find<SupplierController>(tag: 'supplier-${widget.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(supplierController.supplier.value));
  }
}
