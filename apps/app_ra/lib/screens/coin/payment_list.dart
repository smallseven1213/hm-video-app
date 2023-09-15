import 'package:flutter/material.dart';
import 'package:shared/modules/user/user_payment_consumer.dart';

class PaymentList extends StatelessWidget {
  final int productId;

  const PaymentList({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaymentConsumer(
      id: productId,
      child: (payments) {
        
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Text('請選擇支付方式', style: Theme.of(context).textTheme.headlineLarge),
            Expanded(
              child: ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return ListTile(
                    title: Text(payment.id.toString()),
                    subtitle: Text(payment.type.toString()),
                    // trailing: Text(payment.amount.toString()),
                  );
                },
              ),
            ),
          ]),
        );
      },
    );
  }
}
