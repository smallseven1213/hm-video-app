import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/layout_controller.dart';
import 'package:shared/models/slim_channel.dart';
import 'package:shared/modules/main_layout/channels_scaffold.dart';
import '../../controllers/tt_ui_controller.dart';
import 'channel_style_1/index.dart';
import 'channel_style_2/index.dart';
import 'channel_style_3/index.dart';
import 'channel_style_4/index.dart';
import 'channel_style_5/index.dart';
import 'channel_style_6/index.dart';
import 'channel_style_not_found/index.dart';

Map<int, Function(SlimChannel channelData, int layoutId)> styleWidgetMap = {
  1: (channelData, layoutId) => ChannelStyle1(
        key: ValueKey(channelData.id),
        channelId: channelData.id,
        layoutId: layoutId,
      ),
  2: (channelData, layoutId) => ChannelStyle2(
        key: ValueKey(channelData.id),
      ),
  3: (channelData, layoutId) => ChannelStyle3(
        key: ValueKey(channelData.id),
        channelId: channelData.id,
        layoutId: layoutId,
      ),
  4: (channelData, layoutId) => ChannelStyle4(
        key: ValueKey(channelData.id),
        channelId: channelData.id,
        layoutId: layoutId,
      ),
  5: (channelData, layoutId) => ChannelStyle5(
        key: ValueKey(channelData.id),
        channelId: channelData.id,
        layoutId: layoutId,
      ),
  6: (channelData, layoutId) => ChannelStyle6(
        key: ValueKey(channelData.id),
      ),
};

class Channels extends StatefulWidget {
  final int layoutId;
  const Channels({Key? key, required this.layoutId}) : super(key: key);

  @override
  _ChannelsState createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  final TTUIController ttUiController = Get.find<TTUIController>();
  late LayoutController layoutController;

  @override
  void initState() {
    layoutController =
        Get.find<LayoutController>(tag: 'layout${widget.layoutId}');
    SlimChannel defaultLayout = layoutController.layout[0];

    if (defaultLayout.style == 2 || defaultLayout.style == 6) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ttUiController.setDarkMode(true);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ttUiController.setDarkMode(false);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChannelsScaffold(
        layoutId: widget.layoutId,
        onPageChanged: (index, channelData) {
          if (channelData.style == 2 || channelData.style == 6) {
            ttUiController.setDarkMode(true);
          } else {
            ttUiController.setDarkMode(false);
          }
        },
        child: (channelData) {
          var getWidget = styleWidgetMap[channelData.style];
          if (getWidget == null) {
            return const ChannelStyleNotFound();
          }
          return getWidget(channelData, widget.layoutId);
        });
  }
}
