import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class VDImage extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final Map<String, String>? headers;
  final bool withDefaultPlaceholder;
  final bool flowContainer;
  final BoxFit? fit;
  const VDImage({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.headers,
    this.withDefaultPlaceholder = false,
    this.flowContainer = true,
    this.fit,
  }) : super(key: key);

  @override
  State<VDImage> createState() => _VDImageState();
}

class _VDImageState extends State<VDImage> {
  late CancelableOperation<Image?> ff;

  @override
  void initState() {
    updateImage();
    super.initState();
  }

  @override
  void didUpdateWidget(VDImage oldWidget) {
    if (oldWidget.url != widget.url) {
      updateImage();
    }
    super.didUpdateWidget(oldWidget);
  }

  void updateImage() {
    ff = CancelableOperation.fromFuture(
      Get.find<ImagesProvider>().getImage(
        widget.url,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        placeholder: widget.withDefaultPlaceholder
            ? (w) => Container(
                  decoration: BoxDecoration(
                    color: color27,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Center(
                        child: widget.flowContainer
                            ? LayoutBuilder(
                                builder: (_cc, BoxConstraints constraints) {
                                  return SizedBox(
                                    width: constraints.maxWidth / 2,
                                    height: constraints.maxHeight / 2,
                                    child: Image.asset(
                                      'assets/img/img-default@3x.png',
                                      // fit: BoxFit.contain,
                                    ),
                                  );
                                },
                              )
                            : SizedBox(
                                width: widget.width,
                                height: widget.height,
                                child: Image.asset(
                                  'assets/img/img-default@3x.png',
                                  // fit: BoxFit.contain,
                                ),
                              ),
                      ),
                      w,
                    ],
                  ),
                )
            : null,
      ),
      onCancel: () {
        // print('${widget.url} canceled.');
      },
    );
  }

  @override
  void dispose() {
    ff.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: FutureBuilder<Image?>(
        future: ff.valueOrCancellation(),
        builder: (_cxx, _data) {
          if (!_data.hasData) {
            return Container(
              decoration: BoxDecoration(
                color: color27,
                borderRadius: BorderRadius.circular(6.0),
              ),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: widget.flowContainer
                        ? LayoutBuilder(
                            builder: (_cc, BoxConstraints constraints) {
                              return SizedBox(
                                width: constraints.maxWidth / 2,
                                height: constraints.maxHeight / 2,
                                child: Image.asset(
                                  'assets/img/img-default@3x.png',
                                  // fit: BoxFit.contain,
                                ),
                              );
                            },
                          )
                        : SizedBox(
                            width: widget.width,
                            height: widget.height,
                            child: Image.asset(
                              'assets/img/img-default@3x.png',
                              // fit: BoxFit.contain,
                            ),
                          ),
                  ),
                ],
              ),
            );
          }
          return _data.data!;
        },
      ),
    );
  }
}
