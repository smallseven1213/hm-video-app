import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/v_menu_collection.dart';
import 'package:wgp_video_h5app/components/v_d_bottom_navigation_bar.dart';
import 'package:wgp_video_h5app/controllers/app_controller.dart';
import 'package:wgp_video_h5app/styles.dart';

class NotFound extends StatefulWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  _NotFoundState createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
        backgroundColor: mainBgColor,
        shadowColor: Colors.transparent,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: mainBgColor,
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('頁面籌備中，請稍候', style: TextStyle(fontSize: 12)),
        ),
      ),
      bottomNavigationBar: VDBottomNavigationBar(
        collection: Get.find<VBaseMenuCollection>(),
        activeIndex: Get.find<AppController>().navigationBarIndex,
        onTap: Get.find<AppController>().toNamed,
      ),
    );
  }
}
