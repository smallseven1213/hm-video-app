import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class AppColors {
  static const Map<ColorKeys, Color> colors = {
    ColorKeys.primary: Color(0xff1c1c1c),
    ColorKeys.accent: Color(0x00ffffff),
    ColorKeys.background: Colors.white,
    ColorKeys.textPrimary: Colors.black,
    ColorKeys.textSecondary: Color(0xff979797),
    // BUTTON
    ColorKeys.buttonTextPrimary: Colors.white,
    ColorKeys.buttonTextSecondary: Colors.black,
    ColorKeys.buttonTextCancel: Colors.black,
    ColorKeys.buttonBgPrimary: Color(0xffB5925C),
    ColorKeys.buttonBgSecondary: Color(0xfff2f2f2),
    ColorKeys.buttonBgCancel: Color(0xffCACACA),
    ColorKeys.buttonBgDisable: Color(0xffF2F2F2),
    ColorKeys.buttonOverlayColor: Color(0xff585858),
    ColorKeys.noImageBgTop: Color(0xff00234D),
    ColorKeys.noImageBgBottom: Color(0xff002D62),
    ColorKeys.menuColor: Color(0xffb3b3b3),
    ColorKeys.menuActiveColor: Color(0xffb5925c),
    ColorKeys.dividerColor: Color(0xffeeeeee),
  };
}
