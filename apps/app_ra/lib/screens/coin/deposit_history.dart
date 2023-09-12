import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class DepositHistory extends StatelessWidget {
  const DepositHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Text('DepositHistory', style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
