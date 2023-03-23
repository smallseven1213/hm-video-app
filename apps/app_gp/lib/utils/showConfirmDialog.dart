import 'package:flutter/material.dart';

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
        insetPadding: EdgeInsets.all(0),
        child: Container(
          width: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color(0xFF000916),
                Color(0xFF003F6C),
                Color(0xFF005B9C),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(
              color: Color(0x80FFFFFF),
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (title != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (message != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showCancelButton)
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            if (onCancel != null) {
                              onCancel();
                            }
                            Navigator.of(context).pop(false);
                          },
                          child: Text(cancelButtonText),
                        ),
                      ),
                    if (showConfirmButton)
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            if (onConfirm != null) {
                              onConfirm();
                            }
                            Navigator.of(context).pop(true);
                          },
                          child: Text(confirmButtonText),
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
