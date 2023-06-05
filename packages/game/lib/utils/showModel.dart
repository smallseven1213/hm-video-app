import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';

void showModel(
  BuildContext context, {
  String? title,
  required Widget content,
  required Function() onClosed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: AlertDialog(
          titlePadding: const EdgeInsets.all(15),
          buttonPadding: EdgeInsets.zero,
          backgroundColor: gameLobbyBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: title != null ? 1 : 8, child: Container()),
              if (title != null)
                Expanded(
                  flex: 7,
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: gameLobbyPrimaryTextColor,
                      ),
                    ),
                  ),
                ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    onClosed();
                  },
                  child: Icon(
                    Icons.close,
                    color: gameLobbyLoginFormColor,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 350,
            child: content,
          ),
        ),
      );
    },
  );
}
