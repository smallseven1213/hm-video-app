import 'package:flutter/material.dart';
import 'package:game/apis/game_api.dart';
import 'package:game/utils/show_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../localization/game_localization_delegate.dart';
import 'game_download_dialog_content.dart';

class GameDownloadButton extends StatefulWidget {
  final Function setShowFab;

  const GameDownloadButton({
    Key? key,
    required this.setShowFab,
  }) : super(key: key);

  @override
  State<GameDownloadButton> createState() => GameDownloadButtonState();
}

class GameDownloadButtonState extends State<GameDownloadButton> {
  final localStorage = GetStorage();

  // 取得apk下載位置
  Future<void> onGetApkPath() async {
    var resApkPath = await Get.find<GameLobbyApi>().getApkPath();
    if (resApkPath.startsWith('http://') || resApkPath.startsWith('https://')) {
      await launchUrl(Uri.parse(resApkPath.toString()),
          webOnlyWindowName: '_blank');
    } else {
      throw 'Could not launch $resApkPath';
    }
  }

  Future<void> onHandleDownload(context) async {
    var resDiversion = await Get.find<GameLobbyApi>().getDiversion();

    if (resDiversion != null) {
      showModel(
        context,
        onClosed: () {
          Navigator.pop(context);
        },
        content: GameDownloadDialogContent(
          data: resDiversion,
          onGetApkPath: onGetApkPath,
        ),
      );
    } else {
      onGetApkPath();
    }
  }

  @override
  Widget build(BuildContext context) {
    final GameLocalizations localizations = GameLocalizations.of(context)!;

    return SizedBox(
      width: 65,
      height: 65,
      child: Stack(
        children: [
          InkWell(
              onTap: () => onHandleDownload(context),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 3),
                    child: Image.asset(
                      'packages/game/assets/images/game_lobby/download-button.webp',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xffe0951f),
                      ),
                      gradient: const LinearGradient(
                        colors: [Color(0xf13b3b3b), Color(0xff000000)],
                        stops: [0, 1],
                        begin: Alignment(-1.00, 0.00),
                        end: Alignment(1.00, -0.00),
                        // angle: 0,
                        // scale: undefined,
                      ),
                    ),
                    child: Text(localizations.translate('download_app'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              )),
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                localStorage.write('show-app-download', true);
                widget.setShowFab();
              },
              child: Image.asset(
                'packages/game/assets/images/game_lobby/download-button-close.webp',
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
