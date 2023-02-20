import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdDemo extends StatelessWidget {
  const AdDemo({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Ad Screen'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        onComplete();
      }),
    );
  }
}
