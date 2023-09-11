import 'dart:io';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:app_ab/config/colors.dart';
import 'package:game/services/game_system_config.dart';
import 'package:shared/apis/auth_api.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../../utils/show_confirm_dialog.dart';

final authApi = AuthApi();
final logger = Logger();

class ScanQRView extends StatefulWidget {
  const ScanQRView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQRViewState();
}

class _ScanQRViewState extends State<ScanQRView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  AuthController authController = Get.find<AuthController>();
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) controller.pauseCamera();
      var res = await authApi.loginByCode(scanData.code ?? '');
      if (res != null) {
        logger.i('register success  ${res.data?['token']} }');
        Get.find<AuthController>().setToken(res.data?['token']);
        if (mounted) {
          showConfirmDialog(
              context: context,
              title: '提示',
              message: '登入成功',
              showCancelButton: false,
              onConfirm: () {
                Navigator.of(context).pop();
              });
        }
      } else {
        if (mounted) {
          showConfirmDialog(
              context: context,
              title: '提示',
              message: '登入失敗，用戶不存在。',
              showCancelButton: false,
              onConfirm: () {
                controller.resumeCamera();
              });
        }
      }
    });
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: QRView(
            key: qrKey,
            onQRViewCreated: (controller) => onQRViewCreated(controller),
            overlay: QrScannerOverlayShape(
              borderColor: AppColors.colors[ColorKeys.primary] ?? Colors.blue,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 8,
              cutOutSize: scanArea,
            ),
            onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
          )),
        ],
      ),
    );
  }
}
