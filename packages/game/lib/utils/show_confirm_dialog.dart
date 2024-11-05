// ignore: unnecessary_import
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:game/screens/game_theme_config.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../localization/game_localization_delegate.dart';

void showConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? confirmText,
  String? cancelText,
  bool barrierDismissible = false,
  required void Function() onConfirm,
  void Function()? onCancel,
  bool? rotate = false,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return PopScope(
        canPop: false,
        child: PointerInterceptor(
          child: RotatedBox(
            quarterTurns: rotate == true ? 1 : 0,
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              content: Container(
                height: 140,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: gameLobbyDialogColor1,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (title != '')
                        Padding(
                          padding: title != ''
                              ? const EdgeInsets.only(
                                  top: 15, left: 15, right: 15)
                              : EdgeInsets.zero,
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: gameLobbyPrimaryTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFeatures: const [
                                FontFeature.proportionalFigures()
                              ],
                            ),
                          ),
                        ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            content,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: gameLobbyPrimaryTextColor,
                              fontFeatures: const [
                                FontFeature.proportionalFigures()
                              ],
                            ),
                          ),
                        ),
                      )),
                    ]),
              ),
              actions: [
                Row(
                  children: [
                    // 如果onCancel是null, 就不顯示這個Button
                    if (onCancel != null)
                      Expanded(
                        child: Ink(
                          decoration: BoxDecoration(
                            color: gameSecondButtonColor1,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(0),
                            ),
                          ),
                          child: InkWell(
                            onTap: onCancel,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  cancelText ??
                                      GameLocalizations.of(context)!
                                          .translate('cancel'),
                                  style: TextStyle(
                                      color: gameSecondButtonTextColor,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Ink(
                        decoration: BoxDecoration(
                          color: gamePrimaryButtonColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft:
                                Radius.circular(onCancel == null ? 24 : 0),
                            bottomRight: const Radius.circular(24),
                          ),
                        ),
                        child: InkWell(
                          onTap: onConfirm,
                          borderRadius: BorderRadius.only(
                            bottomLeft:
                                Radius.circular(onCancel == null ? 24 : 0),
                            bottomRight: const Radius.circular(24),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                confirmText ??
                                    GameLocalizations.of(context)!
                                        .translate('confirm'),
                                style: TextStyle(
                                    color: gamePrimaryButtonTextColor,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
