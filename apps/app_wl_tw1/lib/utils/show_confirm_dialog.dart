import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

import '../config/colors.dart';
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
  bool? barrierDismissible = true,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible ?? true,
    builder: (BuildContext context) {
      return PopScope(
        canPop: barrierDismissible ?? true, 
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(0),
          child: IntrinsicHeight(
            child: Container(
              constraints: const BoxConstraints(minHeight: 180),
              width: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.colors[ColorKeys.noticeBg],
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 30,
                    child: title != null
                        ? Text(
                            title,
                            style: TextStyle(
                              color: AppColors.colors[ColorKeys.textPrimary],
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: message != null
                          ? Text(
                              message,
                              style: TextStyle(
                                color: AppColors.colors[ColorKeys.textPrimary],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox.shrink(),
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
                                type: 'cancel',
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
        ),
      );
    },
  );
}
