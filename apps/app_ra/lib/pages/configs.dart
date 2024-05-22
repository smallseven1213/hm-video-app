import 'package:app_ra/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/enums/app_routes.dart';
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

// class ConfigsPage extends StatelessWidget {
//   ConfigsPage({Key? key}) : super(key: key);

//   UserController get userController => Get.find<UserController>();

//   @override
//   Widget build(BuildContext context) {
// final List<CellData> cellDataList = [
//   CellData(
//     image: const Image(
//       image: AssetImage('assets/images/config_password.png'),
//       width: 20,
//       height: 20,
//     ),
//     text: '修改密碼',
//     onTap: () {
//       MyRouteDelegate.of(context).push(AppRoutes.updatePassword.value);
//     },
//   ),
//   CellData(
//     image: const Image(
//       image: AssetImage('assets/images/config_id.png'),
//       width: 20,
//       height: 20,
//     ),
//     text: '帳號憑證',
//     onTap: () {
//       MyRouteDelegate.of(context).push(AppRoutes.idCard.value);
//     },
//   ),
//   CellData(
//     image: const Image(
//       image: AssetImage('assets/images/config_setting.png'),
//       width: 20,
//       height: 20,
//     ),
//     text: '個性設置',
//     onTap: () {
//       logger.i('Settings tapped');
//     },
//   ),
//   CellData(
//     image: const Image(
//       image: AssetImage('assets/images/config_lock.png'),
//       width: 20,
//       height: 20,
//     ),
//     text: '安全鎖設置',
//     label: const Text('未設置'),
//     onTap: () {
//       logger.i('Settings tapped');
//     },
//   ),
//   CellData(
//     image: const Image(
//       image: AssetImage('assets/images/config_update.png'),
//       width: 20,
//       height: 20,
//     ),
//     text: '更新檢查',
//     onTap: () {
//       logger.i('Settings tapped');
//     },
//   ),
// ];

//     return Scaffold(
//       appBar: const CustomAppBar(title: '設置'),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         child: Obx(() {
//           return ListView.builder(
//             itemCount: cellDataList.length,
//             itemBuilder: (context, index) {
//               return Column(
//                 children: [
//                   CellItem(
//                     image: cellDataList[index].image,
//                     text: cellDataList[index].text,
//                     onTap: cellDataList[index].onTap,
//                   ),
//                   const Divider(
//                     height: 1,
//                     color: Color.fromRGBO(122, 162, 200, 0.3),
//                   ),
//                 ],
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
// }

class ConfigsPage extends StatelessWidget {
  const ConfigsPage({Key? key}) : super(key: key);

  UserController get userController => Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final List<CellData> cellDataList = [
      CellData(
        image: const Image(
          image: AssetImage('assets/images/config_password.png'),
          width: 20,
          height: 20,
        ),
        text: '修改密碼',
        onTap: () {
          MyRouteDelegate.of(context).push(AppRoutes.updatePassword);
        },
      ),
      CellData(
        image: const Image(
          image: AssetImage('assets/images/config_id.png'),
          width: 20,
          height: 20,
        ),
        text: '帳號憑證',
        onTap: () {
          MyRouteDelegate.of(context).push(AppRoutes.idCard);
        },
      ),
      // CellData(
      //   image: const Image(
      //     image: AssetImage('assets/images/config_setting.png'),
      //     width: 20,
      //     height: 20,
      //   ),
      //   text: '個性設置',
      //   onTap: () {
      //     logger.i('Settings tapped');
      //   },
      // ),
      // CellData(
      //   image: const Image(
      //     image: AssetImage('assets/images/config_lock.png'),
      //     width: 20,
      //     height: 20,
      //   ),
      //   text: '安全鎖設置',
      //   label: const Text('未設置'),
      //   onTap: () {
      //     logger.i('Settings tapped');
      //   },
      // ),
      // CellData(
      //   image: const Image(
      //     image: AssetImage('assets/images/config_update.png'),
      //     width: 20,
      //     height: 20,
      //   ),
      //   text: '更新檢查',
      //   onTap: () {
      //     logger.i('Settings tapped');
      //   },
      // ),
    ];
    return Scaffold(
      appBar: const CustomAppBar(title: '設置'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Obx(() {
          // 檢查是否為 guest，如果是則不顯示修改密碼的項目
          final displayedCellDataList = cellDataList.where((data) {
            return data.text != '修改密碼' ||
                !userController.info.value.roles.contains('guest');
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
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Icon(Icons.keyboard_arrow_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
