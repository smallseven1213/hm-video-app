import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

void showFormDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  String confirmText = "確定",
  String cancelText = "取消",
  bool barrierDismissible = true,
  Function()? onConfirm,
  Function()? onCancel,
  Function()? onClosed,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return AlertDialog(
        titlePadding: title != ''
            ? const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10)
            : EdgeInsets.zero,
        buttonPadding: EdgeInsets.zero,
        backgroundColor: gameLobbyBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: title != ''
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    margin: onClosed != null
                        ? const EdgeInsets.only(left: 25)
                        : null,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: gameLobbyPrimaryTextColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (onClosed != null)
                    InkWell(
                      onTap: () {
                        onClosed();
                      },
                      child: Icon(
                        Icons.close,
                        color: gameLobbyLoginFormColor,
                        size: 24,
                      ),
                    ),
                ],
              )
            : onClosed != null
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, right: 15),
                      child: InkWell(
                        onTap: () {
                          onClosed();
                        },
                        child: Icon(
                          Icons.close,
                          color: gameLobbyLoginFormColor,
                        ),
                      ),
                    ),
                  )
                : null,
        content: SizedBox(
          width: 350,
          child: content,
        ),
        actions: [
          Row(
            children: [
              // 如果onCancel是null, 就不顯示這個Button
              if (onCancel != null)
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: gameLobbyButtonDisableColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(24),
                          bottomRight:
                              Radius.circular(onConfirm == null ? 24 : 0),
                        ),
                      ),
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    onPressed: onCancel,
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        color: gameLobbyButtonDisableTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              if (onConfirm != null)
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: gamePrimaryButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft:
                              Radius.circular(onCancel == null ? 24 : 0),
                          bottomRight: const Radius.circular(24),
                        ),
                      ),
                      minimumSize: const Size(double.infinity, 52),
                    ),
                    onPressed: onConfirm,
                    child: Text(
                      confirmText,
                      style: TextStyle(
                          color: gamePrimaryButtonTextColor, fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ],
      );
    },
  );
}
