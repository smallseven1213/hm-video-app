import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_core/models/room_rank.dart';

import '../apis/live_api.dart';

class RankProvider extends StatefulWidget {
  final Widget Function(RoomRank? roomRank) child;

  const RankProvider({Key? key, required this.child}) : super(key: key);

  @override
  _RankProviderState createState() => _RankProviderState();
}

class _RankProviderState extends State<RankProvider> {
  RoomRank? roomRank;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _startRankTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void _startRankTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        var getRoomRank = await LiveApi().getRank();
        setState(() {
          roomRank = getRoomRank.data;
        });
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child(roomRank);
  }
}
