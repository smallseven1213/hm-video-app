import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GSize {
  final double width;
  final double height;
  GSize(this.width, this.height);
}

GSize gs() => GSize(Get.width, Get.height);
BuildContext? gc() => Get.context;
BuildContext? goc() => Get.overlayContext;

GetStorage gss() => GetStorage('app');
GetStorage gsss() => GetStorage('session');

bool isWeb() => GetPlatform.isWeb;
bool isAndroid() => GetPlatform.isAndroid;
bool isIOS() => GetPlatform.isIOS;
bool isMobile() => GetPlatform.isMobile;

void back() => Get.back();
Future? gto(String page, {dynamic args}) =>
    Get.toNamed(page, arguments: args, preventDuplicates: false);
void grto(String page, {dynamic args}) =>
    Get.offNamed(page, arguments: args, preventDuplicates: false);
void gato(String page, {dynamic args}) =>
    Get.offAllNamed(page, arguments: args);
