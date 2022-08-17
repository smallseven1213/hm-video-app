import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/providers/ad_provider.dart';

class VBlockAd extends StatefulWidget {
  final int bannerId;
  final String? url;
  final String photoSid;
  final EdgeInsets margin;
  const VBlockAd({
    Key? key,
    required this.bannerId,
    required this.photoSid,
    this.url,
    this.margin = const EdgeInsets.symmetric(vertical: 0),
  }) : super(key: key);

  @override
  State<VBlockAd> createState() => _VBlockAdState();
}

class _VBlockAdState extends State<VBlockAd> {
  // bool showImage = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<AdProvider>().clickedBanner(widget.bannerId);
        if (widget.url != '') {
          launch(widget.url.toString());
        }
      },
      child: Container(
        width: gs().width - 16,
        height: (gs().width - 16) / 2.85,
        margin: widget.margin,
        // padding: const EdgeInsets.symmetric(vertical: 30),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child:
                // VisibilityDetector(
                //   key: Key('vd-ad-image-${math.Random()}'),
                //   onVisibilityChanged: (VisibilityInfo info) {
                //     var _showImage = (info.visibleFraction * 100 > 0);
                //     if (showImage != _showImage) {
                //       setState(() {
                //         showImage = _showImage;
                //       });
                //     }
                //   },
                //   child: showImage
                //       ?
                VDImage(
              url: widget.photoSid,
              width: gs().width - 16,
              height: (gs().width - 16) / 2.85,
              fit: BoxFit.cover,
            )
            // : Container(
            //     decoration: BoxDecoration(
            //       color: color27,
            //       borderRadius: BorderRadius.circular(6.0),
            //     ),
            //     alignment: Alignment.center,
            //     child: LayoutBuilder(
            //       builder: (_cc, BoxConstraints constraints) {
            //         return SizedBox(
            //           width: gs().width - 40,
            //           height: 50,
            //           child: Image.asset(
            //             'assets/img/img-default@3x.png',
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            ),
      ),
    );
  }
}
