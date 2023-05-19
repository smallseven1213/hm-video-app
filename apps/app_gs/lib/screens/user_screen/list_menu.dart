import 'package:app_gs/screens/user_screen/scan_qrcode.dart';
import 'package:app_gs/utils/showConfirmDialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scan/scan.dart';
import 'package:shared/controllers/auth_controller.dart';

final logger = Logger();

class ListMenuItem {
  final String name;
  final String icon;
  final Function onTap;

  ListMenuItem({
    required this.name,
    required this.icon,
    required this.onTap,
  });
}

class ListMenu extends StatelessWidget {
  const ListMenu({Key? key}) : super(key: key);

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('相簿選擇'),
                  onTap: () {
                    imgFromGallery(context);
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('拍照'),
                onTap: () async {
                  Navigator.of(context).pop();
                  PermissionStatus status = await Permission.camera.request();
                  scanQRCode(context, status);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('取消'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  scanQRCode(BuildContext context, PermissionStatus status) {
    if (status.isGranted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ScanQRView(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('權限不足'),
            content: const Text('請允許訪問相機'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('確定'),
              ),
            ],
          );
        },
      );
    }
  }

  imgFromGallery(context) async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      String? str = await Scan.parse(image!.path);
      var res = await authApi.loginByCode(str ?? '');
      if (res != null) {
        // do login
        Get.find<AuthController>().setToken(res.data?['token']);
        showConfirmDialog(
          context: context,
          title: '提示',
          message: '登入成功',
          showCancelButton: false,
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      } else {
        showConfirmDialog(
          context: context,
          title: '提示',
          message: '登入失敗，用戶不存在。',
          showCancelButton: false,
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      ListMenuItem(
        name: '找回帳號',
        icon: 'assets/images/user_screen_find_account.png',
        onTap: () {
          if (kIsWeb) {
            showConfirmDialog(
              context: context,
              title: '提示',
              message: '請使用手機應用程式找回帳號',
              showCancelButton: false,
            );
          } else {
            showBottomSheet(context);
          }
        },
      ),
    ];
    return SliverList(
      delegate: SliverChildListDelegate(
        items.map((item) {
          return Container(
            height: 38,
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(38),
              border: Border.all(
                color: const Color(0xFF8594E2),
                width: 1,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF000916),
                  Color(0xFF003F6C),
                ],
                stops: [0.0, 1.0],
              ),
            ),
            child: InkWell(
              onTap: item.onTap as void Function()?,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 16),
                  Image(
                    image: AssetImage(item.icon),
                    width: 17,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
