// 1: 頻道 - 上方輪播
// 2: 頻道 - 區域內橫幅
// 3: 篩選設置 - 下方輪播橫幅
// 4: 篩選結果 - 橫幅
// 5: 大廳頁 - 彈出廣告
// 6: 發現頁 - 輪播
// 7: 播放頁 - 下方輪播
// 8: 入站 - 啟動頁廣告
// 9: 頻道 - 內嵌廣告(直)
// 12: 播放頁 - 播放器版位(片頭廣告)
// 13: 頻道 - 內嵌廣告(橫)
// 14: 播放頁 - APP下載廣告
// 15: 播放頁 - 播放中廣告
// 16: 播放頁 - 暫停廣告
// 17: 遊戲大廳 - 上方輪播
// 18: 頻道 - 區域下方橫幅

enum BannerPosition {
  unused,
  channelTopCarousel,
  channelAreaBanner,
  filterBottomCarousel,
  filterResultBanner,
  lobbyPopup,
  discoverCarousel,
  playBottomCarousel,
  landing,
  channelVertical,
  channelHorizontal,
  playPlayer,
  playAppDownload,
  playPlaying,
  playPause,
  lobbyTopCarousel,
  channelAreaBottomBanner;
}

class BannerPhoto {
  final int id;
  final String photoSid;
  final String? logoSid;
  final String? url;
  final String? name;
  final String? title;
  final bool isAutoClose;
  final List? tags;
  final String? button;

  BannerPhoto({
    this.id = 0,
    this.isAutoClose = false,
    this.logoSid,
    this.name,
    this.photoSid = '',
    this.title,
    this.url,
    this.tags,
    this.button,
  });
  factory BannerPhoto.fromJson(Map<String, dynamic> json) {
    return BannerPhoto(
      id: json['id'],
      isAutoClose: json['isAutoClose'] ?? false,
      photoSid: json['photoSid'],
      logoSid: json['logoSid'],
      url: json['url'],
      name: json['name'],
      title: json['title'],
      button: json['button'],
      tags: json['tags'],
    );
  }
}
