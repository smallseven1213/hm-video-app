import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wgp_video_h5app/components/image/index.dart';

class VIconData {
  final String iconSvg;
  final String type;
  const VIconData({required this.iconSvg, this.type = 'svg'});
  Widget getIconWidget() {
    return iconSvg.startsWith('http')
        ? Image.network(iconSvg)
        : type == 'network'
            ? VDImage(url: iconSvg)
            : type == 'svg'
                ? SvgPicture.asset('assets/$iconSvg')
                : Image.asset('assets/$iconSvg');
  }
}

class VIcons {
  static const VIconData share_white = VIconData(iconSvg: 'svg/icon-share-white.svg');
  static const VIconData heart_white = VIconData(iconSvg: 'svg/icon-heart-white.svg');
  static const VIconData actor = VIconData(iconSvg: 'svg/actor.svg');
  static const VIconData add = VIconData(iconSvg: 'svg/add.svg');
  static const VIconData add2 = VIconData(iconSvg: 'svg/icon-add-2.svg');
  static const VIconData announcement =
      VIconData(iconSvg: 'svg/announcement.svg');
  static const VIconData application =
      VIconData(iconSvg: 'svg/application.svg');
  static const VIconData arrow_down = VIconData(iconSvg: 'svg/arrow-down.svg');
  static const VIconData arrow_left = VIconData(iconSvg: 'svg/arrow-left.svg');
  static const VIconData arrow_right =
      VIconData(iconSvg: 'svg/arrow-right.svg');
  static const VIconData arrow_up = VIconData(iconSvg: 'svg/arrow-up.svg');
  static const VIconData back = VIconData(iconSvg: 'svg/back.svg');
  static const VIconData back_black = VIconData(iconSvg: 'svg/back-black.svg');
  static const VIconData back_black_2 =
      VIconData(iconSvg: 'svg/back-black_2.svg');
  static const VIconData back_black_3 =
      VIconData(iconSvg: 'svg/back-black_3.svg');
  static const VIconData backupaccount =
      VIconData(iconSvg: 'svg/backupaccount.svg');
  static const VIconData chart = VIconData(iconSvg: 'svg/chart.svg');
  static const VIconData chat = VIconData(iconSvg: 'svg/chat.svg');
  static const VIconData chat_black = VIconData(iconSvg: 'svg/chat-black.svg');
  static const VIconData check_black =
      VIconData(iconSvg: 'svg/check-black.svg');
  static const VIconData check_green =
      VIconData(iconSvg: 'svg/check-green.svg');
  // static const VIconData classification =
  //     VIconData(iconSvg: 'svg/classification.svg');
  static const VIconData close = VIconData(iconSvg: 'svg/close.svg');
  static const VIconData close_white =
      VIconData(iconSvg: 'svg/icon-close-white.svg');
  static const VIconData close_2 = VIconData(iconSvg: 'svg/close_2.svg');
  static const VIconData community_active =
      VIconData(iconSvg: 'svg/community-active.svg');
  static const VIconData community_default =
      VIconData(iconSvg: 'svg/community-default.svg');
  static const VIconData creator = VIconData(iconSvg: 'svg/creator.svg');
  static const VIconData cs = VIconData(iconSvg: 'svg/cs.svg');
  static const VIconData delete = VIconData(iconSvg: 'svg/delete.svg');
  static const VIconData diamon = VIconData(iconSvg: 'svg/diamon.svg');
  static const VIconData down = VIconData(iconSvg: 'svg/down.svg');
  static const VIconData download = VIconData(iconSvg: 'svg/download.svg');
  static const VIconData edit = VIconData(iconSvg: 'svg/edit.svg');
  // static const VIconData empty = VIconData(iconSvg: 'svg/empty.svg');
  static const VIconData eye = VIconData(iconSvg: 'svg/eye.svg');
  static const VIconData eye_2 = VIconData(iconSvg: 'svg/eye_2.svg');
  static const VIconData eye_3 = VIconData(iconSvg: 'svg/eye_3.svg');
  static const VIconData eye_4 = VIconData(iconSvg: 'svg/eye_4.svg');
  static const VIconData eye_5 = VIconData(iconSvg: 'svg/eye_5.svg');
  static const VIconData eye_6 = VIconData(iconSvg: 'svg/eye_6.svg');
  static const VIconData eye_7 = VIconData(iconSvg: 'svg/eye_7.svg');
  static const VIconData eye_8 = VIconData(iconSvg: 'svg/eye_8.svg');
  static const VIconData eye_9 = VIconData(iconSvg: 'svg/eye_9.svg');
  static const VIconData eye_10 = VIconData(iconSvg: 'svg/eye_10.svg');
  static const VIconData eye_11 = VIconData(iconSvg: 'svg/eye_11.svg');
  static const VIconData eye_12 = VIconData(iconSvg: 'svg/eye_12.svg');
  static const VIconData eye_13 = VIconData(iconSvg: 'svg/eye_13.svg');
  static const VIconData eye_14 = VIconData(iconSvg: 'svg/eye_14.svg');
  static const VIconData eye_15 = VIconData(iconSvg: 'svg/eye_15.svg');
  static const VIconData eye_16 = VIconData(iconSvg: 'svg/eye_16.svg');
  static const VIconData eye_17 = VIconData(iconSvg: 'svg/eye_17.svg');
  static const VIconData eye_18 = VIconData(iconSvg: 'svg/eye_18.svg');
  static const VIconData eye_19 = VIconData(iconSvg: 'svg/eye_19.svg');
  static const VIconData find_active =
      VIconData(iconSvg: 'svg/find-active.svg');
  static const VIconData find_default =
      VIconData(iconSvg: 'svg/find-default.svg');
  static const VIconData filter = VIconData(iconSvg: 'svg/fliter.svg');
  static const VIconData full_horizontal =
      VIconData(iconSvg: 'svg/full-horizontal.svg');
  static const VIconData fullscreen = VIconData(iconSvg: 'svg/fullscreen.svg');
  static const VIconData game = VIconData(iconSvg: 'svg/game.svg');
  static const VIconData game_active =
      VIconData(iconSvg: 'svg/game-active.svg');
  static const VIconData game_default =
      VIconData(iconSvg: 'svg/game-default.svg');
  static const VIconData heart = VIconData(iconSvg: 'svg/heart.svg');
  static const VIconData heart_gray = VIconData(iconSvg: 'svg/heart-gray.svg');
  static const VIconData heart_red = VIconData(iconSvg: 'svg/heart-red.svg');
  static const VIconData heart_red_2 =
      VIconData(iconSvg: 'svg/heart-red_2.svg');
  static const VIconData heart_red_3 =
      VIconData(iconSvg: 'svg/heart-red_3.svg');
  static const VIconData heart_red_4 =
      VIconData(iconSvg: 'svg/heart-red_4.svg');
  static const VIconData heart_red_5 =
      VIconData(iconSvg: 'svg/heart-red_5.svg');
  static const VIconData heart_red_6 =
      VIconData(iconSvg: 'svg/heart-red_6.svg');
  static const VIconData heart_red_7 =
      VIconData(iconSvg: 'svg/heart-red_7.svg');
  static const VIconData heart_red_8 =
      VIconData(iconSvg: 'svg/heart-red_8.svg');
  static const VIconData heart_red_9 =
      VIconData(iconSvg: 'svg/heart-red_9.svg');
  static const VIconData heart_red_10 =
      VIconData(iconSvg: 'svg/heart-red_10.svg');
  static const VIconData heart_red_11 =
      VIconData(iconSvg: 'svg/heart-red_11.svg');
  static const VIconData heart_red_12 =
      VIconData(iconSvg: 'svg/heart-red_12.svg');
  static const VIconData heart_red_13 =
      VIconData(iconSvg: 'svg/heart-red_13.svg');
  static const VIconData history = VIconData(iconSvg: 'svg/history.svg');
  static const VIconData home_active =
      VIconData(iconSvg: 'svg/home-active.svg');
  static const VIconData home_default =
      VIconData(iconSvg: 'svg/home-default.svg');
  static const VIconData i_dcasrd = VIconData(iconSvg: 'svg/i-dcasrd.svg');
  static const VIconData invite = VIconData(iconSvg: 'svg/invite.svg');
  static const VIconData left = VIconData(iconSvg: 'svg/left.svg');
  static const VIconData left_2 = VIconData(iconSvg: 'svg/left_2.svg');
  static const VIconData like = VIconData(iconSvg: 'svg/like.svg');
  static const VIconData live = VIconData(iconSvg: 'svg/live.svg');
  static const VIconData live_active =
      VIconData(iconSvg: 'svg/live-active.svg');
  static const VIconData live_default =
      VIconData(iconSvg: 'svg/live-default.svg');
  static const VIconData lock = VIconData(iconSvg: 'svg/lock.svg');
  // static const VIconData mail = VIconData(iconSvg: 'svg/mail.svg');
  // static const VIconData mail_news = VIconData(iconSvg: 'svg/mail-news.svg');
  static const VIconData member_active =
      VIconData(iconSvg: 'svg/member-active.svg');
  static const VIconData member_default =
      VIconData(iconSvg: 'svg/member-default.svg');
  static const VIconData more = VIconData(iconSvg: 'svg/more.svg');
  static const VIconData play = VIconData(iconSvg: 'svg/play.svg');
  static const VIconData play_yellow =
      VIconData(iconSvg: 'svg/play-yellow.svg');
  static const VIconData plus =
      VIconData(iconSvg: 'png/icon-plus@3x.png', type: 'png');
  static const VIconData plus_2 = VIconData(iconSvg: 'svg/plus_2.svg');
  static const VIconData plus_gray =
      VIconData(iconSvg: 'svg/icon-plus-gray.svg');
  static const VIconData publisher = VIconData(iconSvg: 'svg/publisher.svg');
  static const VIconData purchasehistory =
      VIconData(iconSvg: 'svg/purchasehistory.svg');
  // static const VIconData reload = VIconData(iconSvg: 'svg/reload.svg');
  // static const VIconData refresh = VIconData(iconSvg: 'svg/return.svg');
  static const VIconData right = VIconData(iconSvg: 'svg/right.svg');
  // static const VIconData search = VIconData(iconSvg: 'svg/search.svg');
  // static const VIconData searchclose =
  //     VIconData(iconSvg: 'svg/searchclose.svg');
  // static const VIconData sequence = VIconData(iconSvg: 'svg/sequence.svg');
  // static const VIconData setting = VIconData(iconSvg: 'svg/setting.svg');
  static const VIconData share = VIconData(iconSvg: 'svg/share.svg');
  static const VIconData share_2 = VIconData(iconSvg: 'svg/share_2.svg');
  static const VIconData sharehistory =
      VIconData(iconSvg: 'svg/sharehistory.svg');
  // static const VIconData sound = VIconData(iconSvg: 'svg/sound.svg');
  // static const VIconData stop = VIconData(iconSvg: 'svg/stop.svg');
  static const VIconData story_active =
      VIconData(iconSvg: 'svg/story-active.svg');
  static const VIconData story_default =
      VIconData(iconSvg: 'svg/story-default.svg');
  // static const VIconData supplier = VIconData(iconSvg: 'svg/supplier.svg');
  // static const VIconData timer = VIconData(iconSvg: 'svg/timer.svg');
  // static const VIconData trash = VIconData(iconSvg: 'svg/trash.svg');
  // static const VIconData view_black = VIconData(iconSvg: 'svg/view-black.svg');
  // static const VIconData view_gray = VIconData(iconSvg: 'svg/view-gray.svg');
  // static const VIconData viewhistory = VIconData(iconSvg: 'svg/viewhistory.svg');
  // static const VIconData wallet = VIconData(iconSvg: 'svg/wallet.svg');
  static const VIconData diamond = VIconData(iconSvg: 'svg/combined-shape.svg');
  static const VIconData coin =
      VIconData(iconSvg: 'img/icon-coin@3x.png', type: 'png');

  // static const VIconData add = VIconData(iconSvg: 'svg/icon-add.svg');
  // static const VIconData announcement =
  //     VIconData(iconSvg: 'svg/icon-announcement.svg');
  // static const VIconData application =
  //     VIconData(iconSvg: 'svg/icon-application.svg');
  static const VIconData arrow_2_down =
      VIconData(iconSvg: 'svg/icon-arrow-2-down.svg');
  static const VIconData arrow_2_left =
      VIconData(iconSvg: 'svg/icon-arrow-2-left.svg');
  static const VIconData arrow_2_right =
      VIconData(iconSvg: 'svg/icon-arrow-2-right.svg');
  // static const VIconData arrow_down =
  //     VIconData(iconSvg: 'svg/icon-arrow-down.svg');
  // static const VIconData arrow_left =
  //     VIconData(iconSvg: 'svg/icon-arrow-left.svg');
  // static const VIconData arrow_right =
  //     VIconData(iconSvg: 'svg/icon-arrow-right.svg');
  // static const VIconData arrow_up = VIconData(iconSvg: 'svg/icon-arrow-up.svg');
  // static const VIconData back = VIconData(iconSvg: 'svg/icon-back.svg');
  // static const VIconData back_black =
  //     VIconData(iconSvg: 'svg/icon-back-black.svg');
  // static const VIconData backupaccount =
  //     VIconData(iconSvg: 'svg/icon-backupaccount.svg');
  static const VIconData backupaccount_white =
      VIconData(iconSvg: 'svg/icon-backupaccount-white.svg');
  // static const VIconData chat = VIconData(iconSvg: 'svg/icon-chat.svg');
  // static const VIconData chat_black =
  //     VIconData(iconSvg: 'svg/icon-chat-black.svg');
  // static const VIconData check_black =
  //     VIconData(iconSvg: 'svg/icon-check-black.svg');
  // static const VIconData check_green =
  //     VIconData(iconSvg: 'svg/icon-check-green.svg');
  static const VIconData classification =
      VIconData(iconSvg: 'svg/icon-classification.svg');
  // static const VIconData close = VIconData(iconSvg: 'svg/icon-close.svg');
  // static const VIconData cs = VIconData(iconSvg: 'svg/icon-cs.svg');
  // static const VIconData delete = VIconData(iconSvg: 'svg/icon-delete.svg');
  // static const VIconData download = VIconData(iconSvg: 'svg/icon-download.svg');
  // static const VIconData edit = VIconData(iconSvg: 'svg/icon-edit.svg');
  static const VIconData empty = VIconData(iconSvg: 'svg/icon-empty.svg');
  // static const VIconData eye = VIconData(iconSvg: 'svg/icon-eye.svg');
  static const VIconData fliter = VIconData(iconSvg: 'svg/icon-fliter.svg');
  static const VIconData follow_white_ =
      VIconData(iconSvg: 'svg/icon-follow-white.svg');
  static const VIconData footer_community_active =
      VIconData(iconSvg: 'svg/icon-footer-community-active.svg');
  static const VIconData footer_community_active_dark =
      VIconData(iconSvg: 'svg/icon-footer-community-active-dark.svg');
  static const VIconData footer_community_default =
      VIconData(iconSvg: 'svg/icon-footer-community-default.svg');
  static const VIconData footer_community_default_white =
      VIconData(iconSvg: 'svg/icon-footer-community-default-white.svg');
  static const VIconData footer_find_active =
      VIconData(iconSvg: 'svg/icon-footer-find-active.svg');
  static const VIconData ticket = VIconData(iconSvg: 'svg/icon-ticket.svg');

  static const VIconData footer_find_active_dark =
      VIconData(iconSvg: 'svg/icon-footer-find-active-dark.svg');
  static const VIconData footer_find_default =
      VIconData(iconSvg: 'svg/icon-footer-find-default.svg');
  static const VIconData footer_find_default_white =
      VIconData(iconSvg: 'svg/icon-footer-find-default-white.svg');
  static const VIconData footer_game_active =
      VIconData(iconSvg: 'svg/icon-footer-game-active.svg');
  static const VIconData footer_game_active_dark =
      VIconData(iconSvg: 'svg/icon-footer-game-active-dark.svg');
  static const VIconData footer_game_default =
      VIconData(iconSvg: 'svg/icon-footer-game-default.svg');
  static const VIconData footer_game_default_white =
      VIconData(iconSvg: 'svg/icon-footer-game-default-white.svg');
  static const VIconData footer_home_active =
      VIconData(iconSvg: 'svg/icon-footer-home-active.svg');
  static const VIconData footer_home_active_dark =
      VIconData(iconSvg: 'svg/icon-footer-home-active-dark.svg');
  static const VIconData footer_home_default =
      VIconData(iconSvg: 'svg/icon-footer-home-default.svg');
  static const VIconData footer_home_default_white =
      VIconData(iconSvg: 'svg/icon-footer-home-default-white.svg');
  static const VIconData footer_live_active =
      VIconData(iconSvg: 'svg/icon-footer-live-active.svg');
  static const VIconData footer_live_active_dark =
      VIconData(iconSvg: 'svg/icon-footer-live-active-dark.svg');
  static const VIconData footer_live_default =
      VIconData(iconSvg: 'svg/icon-footer-live-default.svg');
  static const VIconData footer_live_default_white =
      VIconData(iconSvg: 'svg/icon-footer-live-default-white.svg');
  static const VIconData footer_member_active =
      VIconData(iconSvg: 'svg/icon-footer-member-active.svg');
  static const VIconData footer_member_active_dark =
      VIconData(iconSvg: 'svg/icon-footer-member-active-dark.svg');
  static const VIconData footer_member_default =
      VIconData(iconSvg: 'svg/icon-footer-member-default.svg');
  static const VIconData footer_member_default_white =
      VIconData(iconSvg: 'svg/icon-footer-member-default-white.svg');
  static const VIconData footer_story_active =
      VIconData(iconSvg: 'svg/icon-footer-story-active.svg');
  static const VIconData footer_story_active_dark =
      VIconData(iconSvg: 'svg/icon-footer-story-active-dark.svg');
  static const VIconData footer_story_default =
      VIconData(iconSvg: 'svg/icon-footer-story-default.svg');
  static const VIconData footer_story_default_white =
      VIconData(iconSvg: 'svg/icon-footer-story-default-white.svg');
  static const VIconData footer_vip_default =
      VIconData(iconSvg: 'svg/icon-footer-vip-default.svg');
  static const VIconData footer_vip_active =
      VIconData(iconSvg: 'svg/icon-footer-vip-active.svg');
  // static const VIconData full_horizontal =
  //     VIconData(iconSvg: 'svg/icon-full-horizontal.svg');
  // static const VIconData fullscreen =
  //     VIconData(iconSvg: 'svg/icon-fullscreen.svg');
  // static const VIconData heart_gray =
  //     VIconData(iconSvg: 'svg/icon-heart-gray.svg');
  // static const VIconData heart_red =
  //     VIconData(iconSvg: 'svg/icon-heart-red.svg');
  // static const VIconData history = VIconData(iconSvg: 'svg/icon-history.svg');
  // static const VIconData invite = VIconData(iconSvg: 'svg/icon-invite.svg');
  // static const VIconData lock = VIconData(iconSvg: 'svg/icon-lock.svg');
  static const VIconData heart_gray_1 =
      VIconData(iconSvg: 'svg/icon-heart-gray-1.svg');
  static const VIconData mail = VIconData(iconSvg: 'svg/icon-mail.svg');
  static const VIconData mail_news =
      VIconData(iconSvg: 'svg/icon-mail-news.svg');
  // static const VIconData more = VIconData(iconSvg: 'svg/icon-more.svg');
  // static const VIconData play = VIconData(iconSvg: 'svg/icon-play.svg');
  // static const VIconData play_yellow =
  //     VIconData(iconSvg: 'svg/icon-play-yellow.svg');
  // static const VIconData plus = VIconData(iconSvg: 'svg/icon-plus.svg');
  static const VIconData processing =
      VIconData(iconSvg: 'svg/icon-processing.svg');
  // static const VIconData publisher =
  //     VIconData(iconSvg: 'svg/icon-publisher.svg');
  static const VIconData recommend_creator =
      VIconData(iconSvg: 'svg/icon-recommend-creator.svg');
  static const VIconData recommend_i_dcasrd =
      VIconData(iconSvg: 'svg/icon-recommend-i-dcasrd.svg');
  static const VIconData recommend_like =
      VIconData(iconSvg: 'svg/icon-recommend-like.svg');
  static const VIconData recommend_purchasehistory =
      VIconData(iconSvg: 'svg/icon-recommend-purchasehistory.svg');
  static const VIconData recommend_share =
      VIconData(iconSvg: 'svg/icon-recommend-share.svg');
  static const VIconData recommend_sharehistory =
      VIconData(iconSvg: 'svg/icon-recommend-sharehistory.svg');
  static const VIconData recommend_viewhistory =
      VIconData(iconSvg: 'svg/icon-recommend-viewhistory.svg');
  static const VIconData recommend_wallet =
      VIconData(iconSvg: 'svg/icon-recommend-wallet.svg');
  static const VIconData reload = VIconData(iconSvg: 'svg/icon-reload.svg');
  static const VIconData reload_black =
      VIconData(iconSvg: 'png/icon-reload-black@3x.png', type: 'png');
  static const VIconData refresh = VIconData(iconSvg: 'svg/icon-return.svg');
  static const VIconData search = VIconData(iconSvg: 'svg/icon-search.svg');
  static const VIconData searchclose =
      VIconData(iconSvg: 'svg/icon-searchclose.svg');
  static const VIconData sequence = VIconData(iconSvg: 'svg/icon-sequence.svg');
  static const VIconData setting = VIconData(iconSvg: 'svg/icon-setting.svg');
  static const VIconData share_gray =
      VIconData(iconSvg: 'svg/icon-share-gray.svg');
  static const VIconData sound = VIconData(iconSvg: 'svg/icon-sound.svg');
  static const VIconData stop = VIconData(iconSvg: 'svg/icon-stop.svg');
  static const VIconData supplier = VIconData(iconSvg: 'svg/icon-supplier.svg');
  static const VIconData theme_actor =
      VIconData(iconSvg: 'svg/icon-theme-actor.svg');
  static const VIconData theme_chart =
      VIconData(iconSvg: 'svg/icon-theme-chart.svg');
  static const VIconData theme_diamon =
      VIconData(iconSvg: 'svg/icon-theme-diamon.svg');
  static const VIconData theme_game =
      VIconData(iconSvg: 'svg/icon-theme-game.svg');
  static const VIconData theme_live =
      VIconData(iconSvg: 'svg/icon-theme-live.svg');
  static const VIconData timer = VIconData(iconSvg: 'svg/icon-timer.svg');
  static const VIconData trash = VIconData(iconSvg: 'svg/icon-trash.svg');
  static const VIconData upload = VIconData(iconSvg: 'svg/icon-upload.svg');
  static const VIconData upload_gray =
      VIconData(iconSvg: 'svg/icon-upload-gray.svg');
  static const VIconData view_black =
      VIconData(iconSvg: 'svg/icon-view-black.svg');
  static const VIconData view_gray =
      VIconData(iconSvg: 'svg/icon-view-gray.svg');

  static const VIconData payment_alipay =
      VIconData(iconSvg: 'svg/icon-payment-alipay.svg');
  static const VIconData payment_paypal =
      VIconData(iconSvg: 'svg/icon-payment-paypal.svg');
  static const VIconData payment_quickpass =
      VIconData(iconSvg: 'svg/icon-payment-quickpass.svg');
  static const VIconData payment_wechat =
      VIconData(iconSvg: 'svg/icon-payment-wechat.svg');
  static const VIconData promote_recore =
      VIconData(iconSvg: 'svg/icon-promote-recore.svg');
  static const VIconData promote_shard =
      VIconData(iconSvg: 'svg/icon-promote-share.svg');
  static const VIconData view = VIconData(iconSvg: 'svg/icon-view.svg');
  static const VIconData timer2 = VIconData(iconSvg: 'svg/icon-timer2.svg');
}
