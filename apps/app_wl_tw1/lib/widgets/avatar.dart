import 'package:app_wl_tw1/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_controller.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared/apis/user_api.dart';
import 'package:app_wl_tw1/localization/i18n.dart';
import 'package:shared/widgets/sid_image.dart';

final userApi = UserApi();

class Avatar extends StatelessWidget {
  Avatar({
    Key? key,
    this.onTap,
  }) : super(key: key);

  final Function? onTap;
  final userController = Get.find<UserController>();

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF003068),
      highlightColor: const Color(0xFF00234d),
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  void _showPictureBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Colors.white,
                  ),
                  title: Text(
                    I18n.albumSelection,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    imgFromGallery(context);
                  }),
              // ListTile(
              //   leading: const Icon(Icons.photo_camera),
              //   title: const Text('拍照'),
              //   onTap: () async {
              //     Navigator.of(context).pop();
              //     Permission.camera.request().then((PermissionStatus status) {
              //       scanQRCode(context, status);
              //     });
              //   },
              // ),
              ListTile(
                leading: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                title: Text(
                  I18n.cancel,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
        });
  }

  imgFromGallery(context) async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      try {
        var photoSid = await userApi.uploadAvatar(image);
        Navigator.pop(context);

        Get.find<UserController>().setAvatar(photoSid);
      } catch (e) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Obx(() {
        var isLoading = userController.isLoading.value;
        var hasNoAvatar = userController.info.value.roles.contains('guest');
        if (isLoading && userController.info.value.avatar == null) {
          return _buildShimmer();
        }
        return Container(
          padding: const EdgeInsets.all(1),
          child: hasNoAvatar
              ? Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.colors[ColorKeys.buttonBgDisable],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 32,
                      color: AppColors.colors[ColorKeys.textSecondary],
                    ),
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.colors[ColorKeys.buttonBgDisable],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: userController.info.value.avatar != null
                            ? SidImage(
                                key: ValueKey(userController.info.value.avatar),
                                sid: userController.info.value.avatar!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover)
                            : Icon(
                                Icons.person_rounded,
                                size: 32,
                                color:
                                    AppColors.colors[ColorKeys.textSecondary],
                              ),
                      ),
                      Positioned(
                        bottom: -3,
                        right: -3,
                        child: GestureDetector(
                          onTap: () {
                            _showPictureBottomSheet(context);
                          },
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Color(0xFFf4cdca),
                            backgroundImage:
                                AssetImage('assets/images/icon-add.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
