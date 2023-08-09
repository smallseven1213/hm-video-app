import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/short_video/short_video_provider.dart';
import 'package:shared/widgets/float_page_back_button.dart';
import '../shortcard/index.dart';
import '../wave_loading.dart';
import 'side_info.dart';

final logger = Logger();

class HomeUseShortCard extends StatefulWidget {
  final int index;
  final int id;
  final String title;
  final bool? supportedPlayRecord;
  final String obsKey;
  final Vod shortData;
  final bool? displayFavoriteAndCollectCount;
  final bool? isActive;
  final Function toggleFullScreen;
  final bool? hiddenBottomArea;

  const HomeUseShortCard({
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
    this.hiddenBottomArea = false,
  }) : super(key: key);

  @override
  HomeUseShortCardState createState() => HomeUseShortCardState();
}

class HomeUseShortCardState extends State<HomeUseShortCard> {
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
            hiddenBottomArea: widget.hiddenBottomArea,
          ),
          SideInfo(
            obsKey: widget.obsKey,
            shortData: widget.shortData,
          ),
          const FloatPageBackButton()
        ],
      ),
    );
  }
}
