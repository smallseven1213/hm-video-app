import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/v_tab_collection.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/channels.dart';

class VChannelController extends GetxController implements VTabCollection {
  List<Channel> rawChannels = [];
  List<Channel> channels = [];
  Channel? current;

  @override
  Map<int, VTabItem> getTabs() {
    return channels
        .map((value) => VTabItem(value.id, value.name,
            url: 'internal://channel/${value.id}'))
        .toList()
        .asMap();
  }

  void setCustomChannels(String savedChannels) {
    List<int> _channels = savedChannels.isEmpty
        ? []
        : savedChannels.split(',').map((e) => int.parse(e)).toList();

    channels = _channels.isEmpty
        ? rawChannels
        : rawChannels
            .where((element) =>
                _channels.firstWhere((element2) => element.id == element2,
                    orElse: () => -1) >
                -1)
            .toList();
    update();
  }

  void setChannels(List<Channel> _channel, {bool persistent = true}) {
    String savedChannels = persistent && gss().hasData('layout-1-channels')
        ? gss().read('layout-1-channels').toString()
        : '';
    List<int> _channels = savedChannels.isEmpty
        ? []
        : savedChannels.split(',').map((e) => int.parse(e)).toList();

    rawChannels = _channel;
    channels = _channels.isEmpty
        ? rawChannels
        : _channel
            .where((element) =>
                _channels.firstWhere((element2) => element.id == element2,
                    orElse: () => -1) >
                -1)
            .toList();
    update();
  }

  void setCurrentChannel(int idx) {
    current = channels.isNotEmpty ? channels[idx] : Channel(0, '');
    update();
  }

  Channel? getCurrentChannel() {
    return current;
  }
}
