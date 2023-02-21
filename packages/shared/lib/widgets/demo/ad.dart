import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdDemo extends StatelessWidget {
  const AdDemo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Add Screen'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Get.offNamed('/home');
      }),
    );
  }
}
