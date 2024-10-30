import 'package:app_wl_tw2/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/list_editor_controller.dart';
import 'package:shared/enums/list_editor_category.dart';
import 'package:shared/models/color_keys.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.colors[ColorKeys.systemCardDividerColor]!,
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.colors[ColorKeys.textPrimary]),
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.colors[ColorKeys.textPrimary]),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
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
                        color: AppColors.colors[ColorKeys.buttonBgPrimary],
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
