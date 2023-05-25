class BannerPosition {
  const BannerPosition._(this.value);
  final int value;

  static const BannerPosition none = BannerPosition._(0);
  static const BannerPosition channelTopCarousel =
      BannerPosition._(1); // 1: 頻道 - 上方輪播
  static const BannerPosition channelAreaBanner =
      BannerPosition._(2); // 2: 頻道 - 區域內橫幅
  static const BannerPosition filterBottomCarousel =
      BannerPosition._(3); // 3: 篩選設置 - 下方輪播橫幅
  static const BannerPosition filterResultBanner =
      BannerPosition._(4); // 4: 篩選結果 - 橫幅
  static const BannerPosition lobbyPopup = BannerPosition._(5); // 5: 大廳頁 - 彈出廣告
  static const BannerPosition discoverCarousel =
      BannerPosition._(6); // 6: 發現頁 - 輪播
  static const BannerPosition playBottomCarousel =
      BannerPosition._(7); // 7: 播放頁 - 下方輪播
  static const BannerPosition landing = BannerPosition._(8); // 8: 入站 - 啟動頁廣告
  static const BannerPosition verticalEmbeddedAdAd =
      BannerPosition._(9); // 9: 頻道 - 內嵌廣告(直)
  static const BannerPosition userCenter =
      BannerPosition._(11); // 11: 個人中心 - 內嵌廣告(橫)
  static const BannerPosition playPlayer =
      BannerPosition._(12); // 12: 播放頁 - 播放器版位(片頭廣告)
  static const BannerPosition horizontalEmbeddedAdAd =
      BannerPosition._(13); // 13: 頻道 - 內嵌廣告(橫)
  static const BannerPosition playAppDownload =
      BannerPosition._(14); // 14: 播放頁 - APP下載廣告
  static const BannerPosition playPlaying =
      BannerPosition._(15); // 15: 播放頁 - 播放中廣告
  static const BannerPosition playPause =
      BannerPosition._(16); // 16: 播放頁 - 暫停廣告
  static const BannerPosition lobbyTopCarousel =
      BannerPosition._(17); // 17: 遊戲大廳 - 上方輪播
  static const BannerPosition channelAreaBottomBanner =
      BannerPosition._(18); // 18: 頻道 - 區域下方橫幅
}
