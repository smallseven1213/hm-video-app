import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/components/video_player/custom_cupertino_controls.dart';
import 'package:wgp_video_h5app/components/video_player/custom_material_controls.dart';
import 'package:wgp_video_h5app/components/video_player/custom_material_desktop_controls.dart';
import 'package:wgp_video_h5app/controllers/v_vod_controller.dart';

class AdaptiveControls extends StatelessWidget {
  final String title;
  final AsyncCallback back;
  final VVodController vodController;

  const AdaptiveControls({
    Key? key,
    this.title = '',
    required this.back,
    required this.vodController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return CustomMaterialControls(
          title: title,
          back: back,
          vodController: vodController,
        );

      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.iOS:
        return CustomMaterialDesktopControls(
          title: title,
          back: back,
          vodController: vodController,
        );

      // case TargetPlatform.iOS:
      //   return const CupertinoControls(
      //     backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
      //     iconColor: Color.fromARGB(255, 200, 200, 200),
      //   );
      default:
        // return CustomMaterialControls(title: title);
        // return const CupertinoControls(
        return CustomCupertinoControls(
          title: title,
          backgroundColor: const Color.fromRGBO(41, 41, 41, 0.7),
          iconColor: const Color.fromARGB(255, 200, 200, 200),
          back: back,
          vodController: vodController,
        );
    }
  }
}
