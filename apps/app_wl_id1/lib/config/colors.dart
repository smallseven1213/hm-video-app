import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class AppColors {
  static const Map<ColorKeys, Color> colors = {
    // bg
    ColorKeys.primary: Color(0xffFFC700),
    ColorKeys.accent: Color(0x00ffffff),
    ColorKeys.background: Color(0xff001A40),
    // text
    ColorKeys.textPrimary: Color(0xffFFC700),
    ColorKeys.textSecondary: Color(0xffffffff),
    // button
    ColorKeys.buttonBgPrimary: Colors.white,
    ColorKeys.buttonBgSecondary: Colors.white,
    ColorKeys.buttonTextPrimary: Colors.white,
    ColorKeys.buttonTextSecondary: Color(0xffFFC700),
    ColorKeys.noImageBgTop: Color(0xff00234D),
    ColorKeys.noImageBgBottom: Color(0xff002D62),
    ColorKeys.formBg: Color(0xfff6f6f6),
    ColorKeys.gradientBgTopColor: Color(0xFF040405),
    ColorKeys.gradientBgBottomColor: Color.fromRGBO(20, 49, 104, 0.7),
    // video
    ColorKeys.videoTitle: Color(0xffffffff),
    // dialog
    ColorKeys.noticeBg: Color(0xff3F4253),
    // tabs
    ColorKeys.tabBgColor: Color(0xff0F1320), // layout tab
    ColorKeys.tabTextColor: Color(0xffb2bac5), // layout tab
    ColorKeys.tabTextActiveColor: Color(0xffFFC700), // layout tab
    ColorKeys.tabBarTextColor: Color(0xffb2bac5),
    ColorKeys.tabBarTextActiveColor: Color(0xffFFC700),
  };
}
