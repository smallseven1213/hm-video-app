import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/supplier_controller.dart';

class SupplierProvider extends StatefulWidget {
  final int id;
  final Widget child;
  const SupplierProvider({
    Key? key,
    required this.child,
    required this.id,
  }) : super(key: key);

  @override
  SupplierPageState createState() => SupplierPageState();
}

class SupplierPageState extends State<SupplierProvider> {
  late SupplierController supplierController;

  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    supplierController =
        Get.put(SupplierController(supplierId: widget.id), tag: 'supplier-${widget.id}');
  }

  @override
  void dispose() {
    supplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
