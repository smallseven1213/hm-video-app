import 'package:app_wl_tw1/config/colors.dart';
import 'package:app_wl_tw1/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/modules/user/user_info_consumer.dart';
import 'package:shared/navigator/delegate.dart';

class CellData {
  final Widget image;
  final String text;
  final Widget? label;
  final VoidCallback onTap;

  CellData(
      {required this.image,
      required this.text,
      required this.onTap,
      this.label});
}

class ConfigsPage extends StatelessWidget {
  const ConfigsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<CellData> cellDataList = [
      CellData(
        image: Icon(
          Icons.lock_open_outlined,
          size: 20,
          color: AppColors.colors[ColorKeys.textPrimary],
        ),
        text: '修改密碼',
        onTap: () {
          MyRouteDelegate.of(context).push(AppRoutes.updatePassword);
        },
      ),
    ];
    return Scaffold(
      appBar: const CustomAppBar(title: '設置'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: UserInfoConsumer(child: (info, isVIP, isGuest, isLoading) {
          // 檢查是否為 guest，如果是則不顯示修改密碼的項目
          final displayedCellDataList = cellDataList.where((data) {
            return data.text != '修改密碼' || !isGuest;
          }).toList();

          return ListView.builder(
            itemCount: displayedCellDataList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  CellItem(
                    image: displayedCellDataList[index].image,
                    text: displayedCellDataList[index].text,
                    onTap: displayedCellDataList[index].onTap,
                  ),
                  const Divider(
                    height: 1,
                    color: Color.fromRGBO(122, 162, 200, 0.3),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}

class CellItem extends StatelessWidget {
  final Widget image;
  final Widget? label;
  final String text;
  final VoidCallback? onTap;

  const CellItem(
      {super.key,
      required this.image,
      this.label,
      required this.text,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 20.0),
                image,
                const SizedBox(width: 15.0),
                Text(
                  text,
                  style: TextStyle(
                    color: AppColors.colors[ColorKeys.textPrimary],
                  ),
                ),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.colors[ColorKeys.textPrimary],
            ),
          ],
        ),
      ),
    );
  }
}
