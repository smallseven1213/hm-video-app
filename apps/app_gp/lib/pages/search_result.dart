import 'package:app_gp/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared/apis/vod_api.dart';
import 'package:shared/models/vod.dart';

import '../widgets/video_preview.dart';

final vodApi = VodApi();

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({Key? key, required this.keyword}) : super(key: key);

  final String keyword;

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List<Vod> videos = [];

  @override
  void initState() {
    super.initState();
    _fetchData(1);
  }

  _fetchData(page) async {
    final result = await vodApi.searchMany(widget.keyword);
    setState(() {
      videos = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: widget.keyword,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlignedGridView.count(
            crossAxisCount: 2,
            itemCount: videos.length,
            itemBuilder: (BuildContext context, int index) {
              var video = videos[index];
              return VideoPreviewWidget(
                  id: video.id,
                  coverVertical: video.coverVertical!,
                  coverHorizontal: video.coverHorizontal!,
                  timeLength: video.timeLength!,
                  tags: video.tags!,
                  title: video.title,
                  videoViewTimes: video.videoViewTimes!);
            },
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 10.0,
          ),
        ));
  }
}
