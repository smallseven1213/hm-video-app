import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class OrderRecord extends StatelessWidget {
  const OrderRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Text('DepositHistory', style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
