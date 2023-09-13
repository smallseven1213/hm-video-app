import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class AppColors {
  static const Map<ColorKeys, Color> colors = {
    // bg
    ColorKeys.primary: Color(0xff0F1320),
    ColorKeys.secondary: Color(0xffF4CDCA),
    ColorKeys.background: Color(0xff0F1320),
    ColorKeys.formBg: Color(0xfff2f2f2),
    ColorKeys.videoPreviewBg: Color(0xffefefef),
    // text
    ColorKeys.textPrimary: Colors.white,
    ColorKeys.textSecondary: Color(0xff979797),
    ColorKeys.textTertiary: Color(0xff73747b),
    ColorKeys.textPlaceholder: Color(0xffCACACA),
    // button
    ColorKeys.buttonTextPrimary: Colors.white,
    ColorKeys.buttonTextSecondary: Colors.white,
    ColorKeys.buttonTextCancel: Colors.white,
    ColorKeys.buttonBgPrimary: Color(0xff6874b6),
    ColorKeys.buttonBgSecondary: Color(0xff3F425A),
    ColorKeys.buttonBgCancel: Color(0xff1F2235),
    ColorKeys.buttonBgDisable: Color(0xff464C61),
    ColorKeys.buttonOverlayColor: Color(0xff585858),
    ColorKeys.noImageBgTop: Color(0xff00234D),
    ColorKeys.noImageBgBottom: Color(0xff002D62),
    ColorKeys.menuBgColor: Color(0xff1C202F),
    ColorKeys.menuColor: Color(0xff919BB3),
    ColorKeys.menuActiveColor: Color(0xffF4CDCA),
    ColorKeys.dividerColor: Color(0xffeeeeee),
    ColorKeys.gradientBgTopColor: Color(0xff46454a),
    ColorKeys.gradientBgBottomColor: Color(0xff1c1c1c),
    // tabs
    ColorKeys.tabBgColor: Color(0xff0F1320), // layout tab
    ColorKeys.tabTextColor: Color(0xff919BB3), // layout tab
    ColorKeys.tabTextActiveColor: Color(0xffF4CDCA), // layout tab
    ColorKeys.tabBarTextColor: Color(0xff919BB3),
    ColorKeys.tabBarTextActiveColor: Color(0xffF4CDCA),
    // search input
    ColorKeys.textSearch: Color(0xff919BB3),
    // jingang
    ColorKeys.jingangBorder: Color(0xffF4CDCA),
  };
}
