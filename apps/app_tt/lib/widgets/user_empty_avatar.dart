import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared/apis/user_api.dart';
import 'package:shared/controllers/user_controller.dart';

final userApi = UserApi();

class UserEmptyAvatar extends StatelessWidget {
  const UserEmptyAvatar({Key? key}) : super(key: key);

  void _showPictureBottomSheet(context) {
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
    return InkWell(
      onTap: () {
        _showPictureBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100 / 2),
        ),
        child: SizedBox(
          width: 100,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100 / 2),
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: const Color(0xff262626),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/take-picture.png'),
                        width: 40,
                        height: 40,
                      ),
                      Text('添加頭像',
                          style: TextStyle(color: Colors.white, fontSize: 11))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
