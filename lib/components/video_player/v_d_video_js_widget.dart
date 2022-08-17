import 'dart:html' as html;
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:video_js/src/web/video_js_controller.dart';
import 'package:video_js/src/web/video_js_scripts.dart';
import 'package:video_js/video_js.dart';

class VDVideoJsWidget extends StatefulWidget {
  final VideoJsController videoJsController;
  final double height;
  final double width;
  final String? title;

  const VDVideoJsWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.videoJsController,
    this.title = '',
  }) : super(key: key);

  @override
  VDVideoJsWidgetState createState() => VDVideoJsWidgetState();
}

class VDVideoJsWidgetState extends State<VDVideoJsWidget> {
  late String elementId;

  @override
  void dispose() {
    super.dispose();
    widget.videoJsController.dispose();
    html.Element? ta =
        html.querySelector('#vod-${widget.videoJsController.playerId}');
    if (ta!.parent != null) {
      ta.parent!.remove();
    }
    // html.Element? ele = html.querySelector("#divId");
    // if (html.querySelector("#divId") != null) {
    //   ele!.remove();
    // }
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      elementId = generateRandomString(7);
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(elementId, (int id) {
        final html.Element htmlElement = html.DivElement()
          ..id = "divId"
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.overflow = 'hidden'
          ..children = [
            html.VideoElement()
              ..id = widget.videoJsController.playerId
              ..style.minHeight = "100%"
              ..style.minHeight = "100%"
              ..style.width = "100%"
              ..style.height = "auto"
              ..className = "video-js vjs-default-skin",
            html.ScriptElement()
              ..innerHtml = VideoJsScripts().videojsCode(
                      widget.videoJsController.playerId,
                      getVideoJsOptions(
                          widget.videoJsController.videoJsOptions)) +
                  """
                  var player = videojs.getPlayer('${widget.videoJsController.playerId}');
                  player.addChild('VDTitle');
                  player.on('ended', () => { endOfTrial(); });
                  """,
          ];
        return htmlElement;
      });
    }
  }

  /// Get video initial options as a json
  Map<String, dynamic> getVideoJsOptions(VideoJsOptions? videoJsOptions) {
    return videoJsOptions != null ? videoJsOptions.toJson() : {};
  }

  /// To generate random string for HtmlElementView ID
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: kIsWeb
          ? HtmlElementView(
              viewType: elementId,
            )
          : Center(
              child: Text("Video_js plugin just supported on web"),
            ),
    );
  }
}
