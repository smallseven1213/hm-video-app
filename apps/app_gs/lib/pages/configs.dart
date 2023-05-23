import 'package:app_gs/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

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
  ConfigsPage({Key? key}) : super(key: key);

  final List<CellData> cellDataList = [
    CellData(
      image: Image(
        image: const AssetImage('assets/images/config_password.png'),
        width: 20,
        height: 20,
      ),
      text: '修改密碼',
      onTap: () {
        print('Settings tapped');
      },
    ),
    CellData(
      image: Image(
        image: const AssetImage('assets/images/config_id.png'),
        width: 20,
        height: 20,
      ),
      text: '帳號憑證',
      onTap: () {
        print('Settings tapped');
      },
    ),
    CellData(
      image: Image(
        image: const AssetImage('assets/images/config_setting.png'),
        width: 20,
        height: 20,
      ),
      text: '個性設置',
      onTap: () {
        print('Settings tapped');
      },
    ),
    CellData(
      image: Image(
        image: const AssetImage('assets/images/config_lock.png'),
        width: 20,
        height: 20,
      ),
      text: '安全鎖設置',
      label: const Text('未設置'),
      onTap: () {
        print('Settings tapped');
      },
    ),
    CellData(
      image: Image(
        image: const AssetImage('assets/images/config_update.png'),
        width: 20,
        height: 20,
      ),
      text: '更新檢查',
      onTap: () {
        print('Settings tapped');
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '設置'),
      body: Padding(
        // padding x 8
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView.builder(
          itemCount: cellDataList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                CellItem(
                  image: cellDataList[index].image,
                  text: cellDataList[index].text,
                  onTap: cellDataList[index].onTap,
                ),
                const Divider(
                  height: 1,
                  color: Color.fromRGBO(122, 162, 200, 0.3),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class CellItem extends StatelessWidget {
  final Widget image;
  final Widget? label;
  final String text;
  final VoidCallback onTap;

  const CellItem(
      {super.key,
      required this.image,
      this.label,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: image,
      title: Expanded(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) label!,
          const Icon(Icons.keyboard_arrow_right, color: Colors.white),
        ],
      ),
      onTap: onTap,
    );
  }
}
