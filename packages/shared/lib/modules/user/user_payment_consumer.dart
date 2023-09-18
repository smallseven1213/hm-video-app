import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/payment_controller.dart';
import '../../models/payment.dart';

enum PaymentType {
  none,
  coin,
  vip,
}

class PaymentConsumer extends StatefulWidget {
  final int id;
  final Widget Function(List<Payment> payment) child;
  const PaymentConsumer({
    Key? key,
    required this.child,
    required this.id,
  }) : super(key: key);

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentConsumer> {
  late PaymentController paymentController;

  @override
  void initState() {
    super.initState();
    paymentController = Get.put(PaymentController(productId: widget.id),
        tag: 'payment-${widget.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.child(paymentController.payments));
  }
}
