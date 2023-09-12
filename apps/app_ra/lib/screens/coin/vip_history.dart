import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class VipHistory extends StatelessWidget {
  const VipHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('VipHistory', style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
