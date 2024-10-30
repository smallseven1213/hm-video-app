import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/utils/datetime_formatter.dart';

class SystemEventCard extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final String time;
  final bool isSelected;

  final ListEditorController listEditorController =
      Get.find<ListEditorController>(
          tag: ListEditorCategory.notifications.toString());

  SystemEventCard({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  time,
                  style: TextStyle(
                      fontSize: 12, color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ],
          ),
          Obx(() {
            if (listEditorController.isEditing.value) {
              return Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    listEditorController.toggleSelected(id);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, right: 4),
                      child: Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          })
        ],
      ),
    );
  }
}
