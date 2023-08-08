import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/layout_controller.dart';

class HomeMainScreen extends StatelessWidget {
  final int layoutId;
  const HomeMainScreen({Key? key, required this.layoutId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // HC: 煩死，勿動!!
      child: GetBuilder<LayoutController>(
        tag: 'layout$layoutId',
        builder: (controller) {
          return Obx(() {
            if (controller.isLoading.value) {
              return const Scaffold(
                body: Center(
                  child: Text('WaveLoading'),
                ),
              );
            }
            return Scaffold(
                body: Stack(
              children: [
                Positioned(
                    child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                  ],
                )),
              ],
            ));
          });
        },
      ),
    );
  }
}
