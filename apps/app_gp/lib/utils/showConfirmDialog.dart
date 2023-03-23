import 'package:flutter/material.dart';

import '../widgets/button.dart';

Future<bool?> showConfirmDialog({
  required BuildContext context,
  String? title,
  String? message,
  String confirmButtonText = '確定',
  String cancelButtonText = '取消',
  Function? onConfirm,
  Function? onCancel,
  bool showConfirmButton = true,
  bool showCancelButton = true,
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(0),
        child: IntrinsicHeight(
          child: Container(
            constraints: const BoxConstraints(minHeight: 180),
            width: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF000916),
                  Color(0xFF003F6C),
                  Color(0xFF005B9C),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(
                color: const Color(0x80FFFFFF),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: title != null
                        ? Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : SizedBox.shrink(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: message != null
                        ? Text(
                            message,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : SizedBox.shrink(),
                  ),
                ),
                // 以下是按鈕區
                SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 20, left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (showCancelButton)
                          Expanded(
                            child: Button(
                              text: cancelButtonText,
                              onPressed: () {
                                if (onCancel != null) {
                                  onCancel();
                                }
                                Navigator.of(context).pop(false);
                              },
                              type: 'secondary',
                              size: 'small',
                            ),
                          ),
                        if (showCancelButton && showConfirmButton)
                          const SizedBox(width: 10),
                        if (showConfirmButton)
                          Expanded(
                            child: Button(
                              text: confirmButtonText,
                              onPressed: () {
                                if (onConfirm != null) {
                                  onConfirm();
                                }
                                Navigator.of(context).pop(true);
                              },
                              type: 'primary',
                              size: 'small',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
