import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/layout_controller.dart';

class HomeMainScreen extends StatelessWidget {
  HomeMainScreen({Key? key}) : super(key: key);

  final layoutController = Get.find<LayoutController>(tag: 'layout1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '0',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
