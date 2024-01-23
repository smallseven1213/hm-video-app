import 'package:app_wl_id1/localization/i18n.dart';
import 'package:flutter/material.dart';

class VideoListLoading extends StatelessWidget {
  final bool isLoading;
  const VideoListLoading({Key? key, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: Text(I18n.loading)) : const SizedBox();
  }
}
