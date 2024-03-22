import 'package:app_gs/localization/i18n.dart';
import 'package:flutter/material.dart';

class VideoListLoading extends StatelessWidget {
  final bool isLoading;
  const VideoListLoading({Key? key, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: Text(I18n.loading)) : const SizedBox();
  }
}
