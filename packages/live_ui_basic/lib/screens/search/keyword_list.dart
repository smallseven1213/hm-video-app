import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/controllers/live_search_controller.dart';

import '../../widgets/no_result.dart';

class KeywordList extends StatelessWidget {
  final Function(String)? onSearch;
  final LiveSearchController controller = Get.find();

  KeywordList({
    Key? key,
    this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.recommendKeywords.isEmpty) {
        const NoResult();
      }
      return ListView.builder(
        itemCount: controller.recommendKeywords.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              onSearch!(controller.recommendKeywords[index]);
            },
            title: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xff7b7b7b)),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        color: Color(0xffc2c3c4), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      controller.recommendKeywords[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )),
          );
        },
      );
    });
  }
}
