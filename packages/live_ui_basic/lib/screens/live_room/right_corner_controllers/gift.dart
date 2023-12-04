import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/gifts_controller.dart';

class Gift extends StatelessWidget {
  const Gift({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
              child: Gifts(),
            );
          },
        );
      },
      child: Image.asset(
          'packages/live_ui_basic/assets/images/gift_button.webp',
          width: 33,
          height: 33),
    );
  }
}

class Gifts extends StatelessWidget {
  const Gifts({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final giftsController = Get.put(GiftsController());
    return Container(
      height: 200,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: giftsController.gifts.value.data.length,
          itemBuilder: (context, index) {
            return Container(
              width: 100,
              height: 100,
              child: Image.network(
                giftsController.gifts.value.data[index]['image'],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
