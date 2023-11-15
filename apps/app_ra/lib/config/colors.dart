import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class AppColors {
  static const Map<ColorKeys, Color> colors = {
    // bg
    ColorKeys.primary: Color(0xffFDDCEF),
    ColorKeys.accent: Color(0x00ffffff),
    ColorKeys.background: Color(0xff030923),
    ColorKeys.videoPreviewBg: Color(0xffD9D9D9),

    // text
    ColorKeys.textPrimary: Color(0xffFDDCEF),
    ColorKeys.textSecondary: Color(0xff73747b),
    ColorKeys.textLink: Color(0xff04498d),
    ColorKeys.textPlaceholder: Color(0xffCACACA),
    // button
    ColorKeys.buttonBgPrimary: Colors.white,
    ColorKeys.buttonBgSecondary: Colors.white,
    ColorKeys.buttonBgCancel: Color(0xffdedede),
    ColorKeys.noImageBgTop: Color(0xff00234D),
    ColorKeys.noImageBgBottom: Color(0xff002D62),
    ColorKeys.menuColor: Color(0xffb3b3b3),
    ColorKeys.menuActiveColor: Color(0xffb5925c),
    ColorKeys.dividerColor: Color(0xffeeeeee),
    ColorKeys.formBg: Color(0xfff6f6f6),
    ColorKeys.gradientBgTopColor: Colors.transparent,
    ColorKeys.gradientBgBottomColor: Colors.transparent,
    // video
    ColorKeys.videoTitle: Color(0xffFDDCEF),
  };
}
