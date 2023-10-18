import 'package:flutter/material.dart';

class GamePaymentChannelDetail {
  final String? branchName;
  final String receiptAccount;
  final String? receiptBank;
  final String receiptName;

  GamePaymentChannelDetail(
    this.branchName,
    this.receiptAccount,
    this.receiptBank,
    this.receiptName,
  );

  factory GamePaymentChannelDetail.fromJson(Map<String, dynamic> json) {
    return GamePaymentChannelDetail(
      json['branchName'],
      json['receiptAccount'],
      json['receiptBank'],
      json['receiptName'],
    );
  }
}

Map<int, Map<String, dynamic>> depositChannelLabel = {
  1: {
    'text': '推薦',
    'color': const LinearGradient(
      colors: [Color(0xfffd7b00), Color(0xfffd5900)],
    ),
  },
  2: {
    'text': '穩定',
    'color': const LinearGradient(
      colors: [Color(0xff00eb70), Color(0xff00af17)],
    ),
  },
  3: {
    'text': '小額',
    'color': const LinearGradient(
      colors: [Color(0xff00b8ff), Color(0xff009bff)],
    ),
  },
  4: {
    'text': '大額',
    'color': const LinearGradient(
      colors: [Color(0xffff5b00), Color(0xfffd1100)],
    ),
  },
  5: {
    'text': '火熱',
    'color': const LinearGradient(
      colors: [Color(0xffff00c1), Color(0xfffd0079)],
    ),
  },
  6: {
    'text': '優惠',
    'color': const LinearGradient(
      colors: [Color(0xffdf00ff), Color(0xfffd00c4)],
    ),
  },
};

Map<String, Map<String, String>> paymentsMapper = {
  'alipay': {
    // 支付寶
    'icon': 'packages/game/assets/images/game_deposit/icon-alipay.webp',
  },
  'debit': {
    // 網銀入款or銀行卡
    'icon': 'packages/game/assets/images/game_deposit/icon-debit.webp',
  },
  'unionpay': {
    // 雲閃付
    'icon': 'packages/game/assets/images/game_deposit/icon-unionpay.webp',
  },
  'wechat': {
    // 微信
    'icon': 'packages/game/assets/images/game_deposit/icon-wechat.webp',
  },
  'selfdebit': {
    // 銀行轉帳
    'icon': 'packages/game/assets/images/game_deposit/icon-selfdebit.webp',
  },
  'selfusdt': {
    // USDT轉帳
    'icon': 'packages/game/assets/images/game_deposit/icon-selfusdt.webp',
  },
};
