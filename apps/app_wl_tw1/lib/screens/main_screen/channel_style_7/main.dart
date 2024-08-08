import 'package:flutter/material.dart';
import '../../../widgets/sliver_post_grid.dart';

class ChannelStyle7Main extends StatefulWidget {
  final int postId;

  const ChannelStyle7Main({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  ChannelStyle7MainState createState() => ChannelStyle7MainState();
}

class ChannelStyle7MainState extends State<ChannelStyle7Main> {
  @override
  Widget build(BuildContext context) {
    return const SliverPostGrid();
  }
}
