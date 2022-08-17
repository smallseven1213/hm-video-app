import 'package:get/get.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';

class HomeController extends GetxController {
  static HomeController get cc => Get.find();
  //
  Map<int, List<Channel>> cachedChannels = {};
  Map<Channel, List<JinGang>> cachedJingangs = {};
  Map<Channel, List<Block>> cachedBlocks = {};
  Map<Channel, ChannelBanner> cachedChannelBanners = {};
  Map<int, BlockVod> cachedBlockVods = {};
  Map<int, bool> channelLoaded = {};
  bool isCachedBlocks = false;

  Future fetchChannels({int layoutId = 1}) async {
    ChannelProvider _channelProvider = Get.find<ChannelProvider>();

    bool first = true;
    cachedChannels[layoutId] = await _channelProvider.getManyByLayout(layoutId);
    for (Channel channel in (cachedChannels[layoutId] ?? [])) {
      if (first) {
        await fetchArea(channel: channel);
        first = false;
      } else {
        fetchArea(channel: channel);
      }
      await Future.delayed(const Duration(milliseconds: 168));
    }
    update();
  }

  /// Deprecated
  Future fetchAreas({required Channel channel}) async {
    JingangProvider _jingangProvider = Get.find<JingangProvider>();
    BlockProvider _blockProvider = Get.find<BlockProvider>();
    VodProvider _vodProvider = Get.find<VodProvider>();
    AdProvider _adProvider = Get.find<AdProvider>();

    channelLoaded[channel.id] = false;
    var jingans = channel.jingang ?? [];
    if (jingans.isNotEmpty) {
      cachedJingangs[channel] =
          await _jingangProvider.getMany(channel.jingang ?? []);
    }
    if (channel.id == 1) {
      cachedBlocks[channel] = await _blockProvider.getManyByChannel(1);
      for (var block in cachedBlocks[channel]!) {
        _vodProvider.getManyByChannel(block.id).then((vods) {
          cachedBlockVods[block.id] = vods;
          // channelLoaded[channel.id] =
          //     cachedBlockVods.length == cachedBlocks[channel]!.length;
          update();
        });
      }
    } else {
      _blockProvider.getManyByChannel(channel.id).then((blocks) {
        cachedBlocks[channel] = blocks;
        isCachedBlocks = true;
        update();
        for (var block in blocks) {
          _vodProvider.getManyByChannel(block.id).then((vods) {
            cachedBlockVods[block.id] = vods;
            // channelLoaded[channel.id] =
            //     cachedBlockVods.length == cachedBlocks[channel]!.length;
            update();
          });
        }
      });
    }
    if (channel.id == 1) {
      cachedChannelBanners[channel] =
          await _adProvider.getBannersByChannel(channel.id);
    } else {
      _adProvider.getBannersByChannel(channel.id).then((value) {
        cachedChannelBanners[channel] = value;
        update();
      });
    }
    await Future.delayed(const Duration(milliseconds: 168));
    update();
  }

  Future fetchArea({required Channel channel}) async {
    JingangProvider _jingangProvider = Get.find<JingangProvider>();
    VodProvider _vodProvider = Get.find<VodProvider>();
    AdProvider _adProvider = Get.find<AdProvider>();

    channelLoaded[channel.id] = false;
    var jingans = channel.jingang ?? [];
    if (jingans.isNotEmpty) {
      cachedJingangs[channel] =
          await _jingangProvider.getMany(channel.jingang ?? []);
    }
    var vodBlockList = await _vodProvider.getBlockVodsByChannel(channel.id);
    cachedBlocks[channel] = vodBlockList;
    for (var value in vodBlockList) {
      cachedBlockVods[value.id] = value.videos ?? BlockVod([], 0);
    }
    channelLoaded[channel.id] = true;
    update();
    _adProvider.getBannersByChannel(channel.id).then((value) {
      cachedChannelBanners[channel] = value;
      update();
    });
  }
}
