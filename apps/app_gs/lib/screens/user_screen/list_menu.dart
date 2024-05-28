import 'package:app_gs/localization/i18n.dart';
import 'package:app_gs/screens/user_screen/scan_qrcode.dart';
import 'package:app_gs/utils/show_confirm_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scan/scan.dart';
import 'package:shared/controllers/auth_controller.dart';
import 'package:shared/models/navigation.dart';
import 'package:shared/modules/user_setting/user_setting_more_link_consumer.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/handle_url.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../widgets/id_card.dart';

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
                  title: Text(I18n.albumSelection),
                  onTap: () {
                    imgFromGallery(context);
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(I18n.takePhoto),
                onTap: () async {
                  Navigator.of(context).pop();
                  Permission.camera.request().then((PermissionStatus status) {
                    scanQRCode(context, status);
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: Text(I18n.cancel),
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
            title: Text(I18n.insufficientPermissions),
            content: Text(I18n.allowCameraAccess),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(I18n.confirmAction),
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
      String? str = await Scan.parse(image.path);
      var res = await authApi.loginByCode(str ?? '');
      if (res != null) {
        // do login
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
                    title: I18n.hintMessage,
                    message: I18n.useMobileAppToRecoverAccount,
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
              return Container(
                height: 38,
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                decoration: BoxDecoration(
                  borderRadius: kIsWeb ? null : BorderRadius.circular(38),
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
                          width: 20,
                        ),
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
      },
    );
  }
}
