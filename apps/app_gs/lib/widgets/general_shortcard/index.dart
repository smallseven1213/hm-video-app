import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import '../shortcard/index.dart';
import '../wave_loading.dart';
import 'short_bottom_area.dart';

class GeneralShortCard extends StatefulWidget {
  final int index;
  final int id;
  final String title;
  final bool? supportedPlayRecord;
  final String obsKey;
  final Vod shortData;
  final bool? displayFavoriteAndCollectCount;
  final bool? isActive;
  final Function toggleFullScreen;

  const GeneralShortCard({
    Key? key,
    required this.obsKey,
    required this.index,
    required this.id,
    required this.title,
    required this.shortData,
    required this.toggleFullScreen,
    // required this.isFullscreen,
    this.isActive = true,
    this.supportedPlayRecord = true,
    this.displayFavoriteAndCollectCount = true,
  }) : super(key: key);

  @override
  GeneralShortCardState createState() => GeneralShortCardState();
}

class GeneralShortCardState extends State<GeneralShortCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          const WaveLoading(
            color: Color.fromRGBO(255, 255, 255, 0.3),
            duration: Duration(milliseconds: 1000),
            size: 17,
            itemCount: 3,
          ),
          ShortCard(
            obsKey: widget.obsKey,
            index: widget.index,
            isActive: widget.isActive,
            id: widget.shortData.id,
            title: widget.shortData.title,
            shortData: widget.shortData,
            toggleFullScreen: widget.toggleFullScreen,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ShortBottomArea(
              shortData: widget.shortData,
              displayFavoriteAndCollectCount:
                  widget.displayFavoriteAndCollectCount,
            ),
          ),
          const FloatPageBackButton()
        ],
      ),
    );
  }
}
