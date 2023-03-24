// PlayRecordPage is stateless widget

import 'package:flutter/material.dart';

class PlayRecordPage extends StatelessWidget {
  const PlayRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlayRecordPage'),
      ),
      body: const Center(
        child: Text('PlayRecordPage'),
      ),
    );
  }
}
