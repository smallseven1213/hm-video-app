import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class AppColors {
  static const Map<ColorKeys, Color> colors = {
    ColorKeys.primary: Color(0xffFFC700),
    ColorKeys.accent: Color(0x00ffffff),
    ColorKeys.background: Color(0xff001A40),
    ColorKeys.textPrimary: Color(0xff161823),
    ColorKeys.textSecondary: Color(0xffffffff),
    ColorKeys.buttonBgPrimary: Colors.white,
    ColorKeys.buttonBgSecondary: Colors.white,
    ColorKeys.noImageBgTop: Color(0xff00234D),
    ColorKeys.noImageBgBottom: Color(0xff002D62),
  };
}
