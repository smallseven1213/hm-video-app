import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared/controllers/user_controller.dart';
import 'package:app_51ss/widgets/button.dart';

Future<void> captureAndSaveScreenshot(
    context, String successMessage, GlobalKey key) async {
  // 請求權限
  if (Platform.isAndroid) {
    await Permission.storage.request();
  }

  // Get the RenderObject before the async operation
  RenderObject? renderObject = key.currentContext?.findRenderObject();

  if (renderObject is RenderRepaintBoundary) {
    final image = await renderObject.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // 獲取應用文檔目錄
    Directory directory = await getTemporaryDirectory();
    String tempPath = directory.path;

    // 生成文件名
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

    // 保存到臨時文件
    File file = File('$tempPath/$fileName');
    await file.writeAsBytes(pngBytes);

    // 保存到相冊
    final result = await ImageGallerySaver.saveFile(file.path);
    logger.i('File saved: $result');

    // 顯示保存成功提示
    // 注意这里我们再次获取context，因为此处的context可能已经发生改变
    ScaffoldMessenger.of(key.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          successMessage,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class CaptureScreenshotButton extends StatefulWidget {
  final GlobalKey buttonKey;
  final String text;
  final String buttonType;
  final String successMessage;

  const CaptureScreenshotButton({
    Key? key,
    required this.buttonKey,
    required this.text,
    required this.buttonType,
    required this.successMessage,
  }) : super(key: key);

  @override
  State<CaptureScreenshotButton> createState() =>
      CaptureScreenshotButtonState();
}

class CaptureScreenshotButtonState extends State<CaptureScreenshotButton> {
  @override
  Widget build(BuildContext context) {
    return Button(
        text: widget.text,
        type: widget.buttonType,
        onPressed: () async {
          await captureAndSaveScreenshot(
              context, widget.successMessage, widget.buttonKey);
        });
  }
}
