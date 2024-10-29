// 繼承 FloatingActionButtonLocation
// 自訂 FloatingActionButton 位置，允許 x 和 y 偏移
import 'package:flutter/material.dart';

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation baseLocation;
  final double offsetX;  // X 方向的偏移量
  final double offsetY;  // Y 方向的偏移量

  CustomFloatingActionButtonLocation(
    this.baseLocation, {
    this.offsetX = 0,
    this.offsetY = 0,
  });

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // 取得基礎位置的 Offset
    Offset baseOffset = baseLocation.getOffset(scaffoldGeometry);
    
    // 返回偏移後的新 Offset
    return Offset(baseOffset.dx + offsetX, baseOffset.dy + offsetY);
  }
}
