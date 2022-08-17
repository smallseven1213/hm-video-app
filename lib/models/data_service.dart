import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/index.dart';

class DataService {
  final VIconData icon;
  final String title;
  final GestureTapCallback? onTap;
  DataService(this.icon, this.title, {this.onTap});
// final
}

class DataInputService {
  final VIconData? icon;
  final String title;
  final GestureTapCallback? onTap;
  DataInputService(this.title, {this.icon, this.onTap});
// final
}
