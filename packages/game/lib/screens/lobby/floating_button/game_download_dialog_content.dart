import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/widgets/button.dart';

class GameDownloadDialogContent extends StatefulWidget {
  final Map data;
  final Function onGetApkPath;

  const GameDownloadDialogContent({
    Key? key,
    required this.data,
    required this.onGetApkPath,
  }) : super(key: key);

  @override
  State<GameDownloadDialogContent> createState() =>
      GameDownloadDialogContentState();
}

class GameDownloadDialogContentState extends State<GameDownloadDialogContent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Column(
        children: [
          Image.asset(
            'packages/game/assets/images/game_lobby/download-button.webp',
            width: 50,
            height: 50,
          ),
          const SizedBox(height: 10),
          Text(
            '尊貴的用戶您好\n環球遊戲邀請您下載APP，提升遊戲體驗。',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: gameLobbyPrimaryTextColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '此組帳密僅提供首次登入APP使用\n請務必在登入後，更換帳號密碼。',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: gameLobbyPrimaryTextColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: BoxDecoration(
                color: gameLobbyBoxBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '帳號',
                        style: TextStyle(
                          color: gameLobbyPrimaryTextColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 150,
                          child: Text(
                            '${widget.data['username']}',
                            style: TextStyle(
                              color: gameLobbyPrimaryTextColor,
                              fontSize: 13,
                            ),
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.data['username']));
                          Fluttertoast.showToast(
                            msg: '帳號已複製',
                            gravity: ToastGravity.CENTER,
                          );
                        },
                        child: Icon(
                          Icons.copy,
                          color: gameLobbyPrimaryTextColor,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '密碼',
                        style: TextStyle(
                          color: gameLobbyPrimaryTextColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${widget.data['password']}',
                          style: TextStyle(
                            color: gameLobbyPrimaryTextColor,
                            fontSize: 13,
                          ),
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.data['password']));
                          Fluttertoast.showToast(
                            msg: '密碼已複製',
                            gravity: ToastGravity.CENTER,
                          );
                        },
                        child: Icon(
                          Icons.copy,
                          color: gameLobbyPrimaryTextColor,
                          size: 16,
                        ),
                      ),
                    ],
                  )
                ],
              )),
          const SizedBox(height: 15),
          GameButton(
            text: '下載APP',
            onPressed: () {
              widget.onGetApkPath();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
