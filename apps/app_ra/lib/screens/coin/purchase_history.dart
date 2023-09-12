import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class PurchaseHistory extends StatelessWidget {
  const PurchaseHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Text('PurchaseHistory', style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
