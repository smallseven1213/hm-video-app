import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:game/widgets/button.dart';

import '../../../localization/game_localization_delegate.dart';

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
    final GameLocalizations localizations = GameLocalizations.of(context)!;

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
            localizations.translate(
                'greetings_to_our_valued_users_global_gaming_invites_you_to_download_the_app_to_enhance_your_gaming_experience'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: gameLobbyPrimaryTextColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            localizations.translate(
                'this_password_is_only_for_the_first_time_you_log_in_to_the_app_please_be_sure_to_change_your_password_after_logging_in'),
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
                        localizations.translate('username'),
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
                            msg: localizations
                                .translate('account_has_been_copied'),
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
                        localizations.translate('password'),
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
                            msg: localizations.translate('password_copied'),
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
            text: localizations.translate('download_app'),
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
