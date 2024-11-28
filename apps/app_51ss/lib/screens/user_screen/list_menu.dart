import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:shared/controllers/auth_controller.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/modules/user_setting/user_setting_more_link_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/handle_url.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../config/colors.dart';
import '../../utils/show_confirm_dialog.dart';
import '../../widgets/id_card.dart';
import 'scan_qrcode.dart';
import '../../localization/i18n.dart';
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

class ListMenu extends StatefulWidget {
  const ListMenu({
    Key? key,
  }) : super(key: key);

  @override
  ListMenuState createState() => ListMenuState();
}

class ListMenuState extends State<ListMenu> {
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
                  Permission.camera.request().then((PermissionStatus status) {
                    scanQRCode(context, status);
                  });
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

  Future<void> imgFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      final MobileScannerController controller = MobileScannerController();
      final BarcodeCapture? barcodeCapture =
          await controller.analyzeImage(imageBytes as String);

      if (barcodeCapture != null && barcodeCapture.barcodes.isNotEmpty) {
        final String? qrCode = barcodeCapture.barcodes.first.rawValue;
        if (qrCode != null) {
          var res = await authApi.loginByCode(qrCode);
          if (res != null) {
            // 执行登录操作
            Get.find<AuthController>().setToken(res.data?['token']);
            showConfirmDialog(
              context: context,
              title: I18n.hintMessage,
              message: I18n.loginSuccess,
              showCancelButton: false,
              onConfirm: () {
                Navigator.of(context).pop();
              },
            );
          } else {
            showConfirmDialog(
              context: context,
              title: I18n.hintMessage,
              message: I18n.loginFailedUserDoesNotExist,
              showCancelButton: false,
              onConfirm: () {
                Navigator.of(context).pop();
              },
            );
          }
        } else {
          // 处理未能解析的情况
          print('未能解析二维码');
        }
      } else {
        // 处理未能解析的情况
        print('未能解析二维码');
      }
    } else {
      // 处理未选择图片的情况
      print('未选择图片');
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserSettingMoreLinkConsumer(
      child: (quickLinks) {
        final items = quickLinks.map((Navigation item) {
          if (item.path == '/id') {
            return ListMenuItem(
              name: item.name ?? '',
              icon: item.photoSid ?? '',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: IDCard(),
                    );
                  },
                );
              },
            );
          }
          if (item.path == '/recover_account') {
            return ListMenuItem(
              name: item.name ?? '',
              icon: item.photoSid ?? '',
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
            );
          }
          return ListMenuItem(
            name: item.name ?? '',
            icon: item.photoSid ?? '',
            onTap: () {
              if (item.path!.startsWith('http://') ||
                  item.path!.startsWith('https://')) {
                handleHttpUrl(item.path!);
              } else {
                MyRouteDelegate.of(context).push(item.path ?? '');
              }
            },
          );
        });

        return SliverList(
          delegate: SliverChildListDelegate(
            items.map((item) {
              return Column(
                children: [
                  Container(
                    height: 38,
                    margin: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                    child: GestureDetector(
                      onTap: item.onTap as void Function()?,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 16),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: SidImage(
                              sid: item.icon,
                              width: 18,
                              height: 18,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.colors[ColorKeys.textPrimary],
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.colors[ColorKeys.textSecondary],
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.colors[ColorKeys.dividerColor],
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
