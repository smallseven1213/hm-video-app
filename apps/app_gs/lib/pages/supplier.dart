import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_controller.dart';

class SupplierPage extends StatelessWidget {
  final int id;
  const SupplierPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supplierController = SupplierController(
      supplierId: id,
    );
    return Container(
        child: Text(
      'id: $id',
      style: const TextStyle(fontSize: 50, color: Colors.white),
    ));

    // return Container(
    //   child: Obx(() => Text(
    //         supplierController.supplier.value.account ?? '==',
    //         style: const TextStyle(fontSize: 15, color: Colors.white),
    //       )),
    // );
  }
}
