import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

final themeMode = {
  1: 'dark',
  2: 'light',
};

final localStorage = GetStorage();
int themeNumber =
    localStorage.hasData('pageColor') ? localStorage.read('pageColor') : 1;
final theme = themeMode[themeNumber].toString();

// theme - game lobby page
final gameLobbyBgColor =
    gameTheme[theme]!['gameLobbyBgColor'] ?? Colors.transparent;
final gameLobbyAppBarTextColor =
    gameTheme[theme]!['gameLobbyAppBarTextColor'] ?? Colors.transparent;
final gameLobbyAppBarIconColor =
    gameTheme[theme]!['gameLobbyAppBarIconColor'] ?? Colors.transparent;
final gameLobbyPrimaryTextColor =
    gameTheme[theme]!['gameLobbyPrimaryTextColor'] ?? Colors.transparent;
final gameLobbyPointsDollars =
    gameTheme[theme]!['gameLobbyPointsDollars'] ?? Colors.transparent;
final gameLobbyWithdrawText1 =
    gameTheme[theme]!['gameLobbyWithdrawText1'] ?? Colors.transparent;
final gameLobbyWithdrawText2 =
    gameTheme[theme]!['gameLobbyWithdrawText2'] ?? Colors.transparent;
final gameLobbyTransferText1 =
    gameTheme[theme]!['gameLobbyTransferText1'] ?? Colors.transparent;
final gameLobbyTransferText2 =
    gameTheme[theme]!['gameLobbyTransferText2'] ?? Colors.transparent;
final gameItemMainColor =
    gameTheme[theme]!['gameItemMainColor'] ?? Colors.transparent;
final gameButtonGroupColor =
    gameTheme[theme]!['gameButtonGroupColor'] ?? Colors.transparent;
final gameButtonGroupTextColor =
    gameTheme[theme]!['gameButtonGroupTextColor'] ?? Colors.transparent;
final gamePrimaryButtonColor =
    gameTheme[theme]!['gamePrimaryButtonColor'] ?? Colors.transparent;
final gamePrimaryButtonTextColor =
    gameTheme[theme]!['gamePrimaryButtonTextColor'] ?? Colors.transparent;
final gameSecondButtonColor =
    gameTheme[theme]!['gameSecondButtonColor'] ?? Colors.transparent;
final gameSecondButtonColor1 =
    gameTheme[theme]!['gameSecondButtonColor1'] ?? Colors.transparent;
final gameSecondButtonColor2 =
    gameTheme[theme]!['gameSecondButtonColor2'] ?? Colors.transparent;
final gameSecondButtonTextColor =
    gameTheme[theme]!['gameSecondButtonTextColor'] ?? Colors.transparent;
final withdrawalSuccess =
    gameTheme[theme]!['withdrawalSuccess'] ?? Colors.transparent;
final withdrawalFelid =
    gameTheme[theme]!['withdrawalFelid'] ?? Colors.transparent;
final modalDropDownActive =
    gameTheme[theme]!['modalDropDownActive'] ?? Colors.transparent;
final gameLobbyHintColor =
    gameTheme[theme]!['gameLobbyHintColor'] ?? Colors.transparent;
final gameLobbyLoginFormColor =
    gameTheme[theme]!['gameLobbyLoginFormColor'] ?? Colors.transparent;
final gameLobbyLoginFormBorderColor =
    gameTheme[theme]!['gameLobbyLoginFormBorderColor'] ?? Colors.transparent;
final gameLobbyButtonDisableColor =
    gameTheme[theme]!['gameLobbyButtonDisableColor'] ?? Colors.transparent;
final gameLobbyButtonDisableTextColor =
    gameTheme[theme]!['gameLobbyButtonDisableTextColor'] ?? Colors.transparent;
final gameLobbyDepositActiveColor =
    gameTheme[theme]!['gameLobbyDepositActiveColor'] ?? Colors.transparent;
final gameLobbyIconColor =
    gameTheme[theme]!['gameLobbyIconColor'] ?? Colors.transparent;
final gameLobbyIconColor2 =
    gameTheme[theme]!['gameLobbyIconColor2'] ?? Colors.transparent;
final gameLobbyUserInfoColor1 =
    gameTheme[theme]!['gameLobbyUserInfoColor1'] ?? Colors.transparent;
final gameLobbyUserInfoColor2 =
    gameTheme[theme]!['gameLobbyUserInfoColor2'] ?? Colors.transparent;
final gameLobbyDividerColor =
    gameTheme[theme]!['gameLobbyDividerColor'] ?? Colors.transparent;
final gameLobbyTabBgColor =
    gameTheme[theme]!['gameLobbyTabBgColor'] ?? Colors.transparent;
final gameLobbyTabTextColor =
    gameTheme[theme]!['gameLobbyTabTextColor'] ?? Colors.transparent;
final gameLobbyDialogColor1 =
    gameTheme[theme]!['gameLobbyDialogColor1'] ?? Colors.transparent;
final gameLobbyDialogColor2 =
    gameTheme[theme]!['gameLobbyDialogColor2'] ?? Colors.transparent;
final gameLobbyLoginPlaceholderColor =
    gameTheme[theme]!['gameLobbyLoginPlaceholderColor'] ?? Colors.transparent;
final gameLobbyBoxBgColor =
    gameTheme[theme]!['gameLobbyBoxBgColor'] ?? Colors.transparent;
final gameRecordLabelTextColor =
    gameTheme[theme]!['gameRecordLabelTextColor'] ?? Colors.transparent;
final gameLobbyEmptyColor =
    gameTheme[theme]!['gameLobbyEmptyColor'] ?? Colors.transparent;

class DarkThemeColors {
  static const gameLobbyBgColor = Color(0xff1E2123);
  static const gameLobbyAppBarTextColor = Colors.white;
  static const gameLobbyAppBarIconColor = Colors.white;
  static const gameLobbyPrimaryTextColor = Colors.white;
  static const gameLobbyPointsDollars = Color(0xFF34332E);
  static const gameLobbyWithdrawText1 = Color(0xFF518103);
  static const gameLobbyWithdrawText2 = Color(0xFF00ad38);
  static const gameLobbyTransferText1 = Color(0xFF987A4E);
  static const gameLobbyTransferText2 = Color(0xFF937104);
  static const gameItemMainColor = Color(0xff2e3136);
  static const gameButtonGroupColor = Color(0xff2e3136);
  static const gameButtonGroupTextColor = Color(0xffffffff);
  static const gamePrimaryButtonColor = Color(0xffebfe69);
  static const gamePrimaryButtonTextColor = Color(0xff000000);
  static const gameSecondButtonColor = Color(0xff43474a);
  static const gameSecondButtonColor1 = Color(0xff43474a);
  static const gameSecondButtonColor2 = Color(0xff43474a);
  static const gameSecondButtonTextColor = Color(0xffffffff);
  static const withdrawalSuccess = Color(0xff3de965);
  static const withdrawalFelid = Color(0xff43474a);
  static const modalDropDownActive = Color(0xff3de965);
  static const gameLobbyHintColor = Color(0xffd6df87);
  static const gameLobbyLoginFormColor = Color(0xff979797);
  static const gameLobbyLoginFormBorderColor = Color(0xFF43474a);
  static const gameLobbyButtonDisableColor = Color(0xff26282c);
  static const gameLobbyButtonDisableTextColor = Color(0xff43474a);
  static const gameLobbyDepositActiveColor = Color(0x1aebfe69);
  static const gameLobbyIconColor = Color(0xff3B3E41);
  static const gameLobbyIconColor2 = Colors.white;
  static const gameLobbyUserInfoColor1 = Color(0xff3a3c33);
  static const gameLobbyUserInfoColor2 = Color(0xff2c2c2c);
  static const gameLobbyDividerColor = Color(0xff3a3c33);
  static const gameLobbyTabBgColor = Color(0xff2c2c2c);
  static const gameLobbyTabTextColor = Colors.white;
  static const gameLobbyDialogColor1 = Color(0xff2e3136);
  static const gameLobbyDialogColor2 = Color(0xff2e3136);
  static const gameLobbyLoginPlaceholderColor = Color(0xff979797);
  static const gameLobbyBoxBgColor = Color(0xff383d44);
  static const gameRecordLabelTextColor = Colors.white;
  static const gameLobbyEmptyColor = Color(0xff2c2c2c);
}

class LightThemeColors {
  static const gameLobbyBgColor = Colors.white;
  static const gameLobbyAppBarTextColor = Color(0xFF1F1F1F);
  static const gameLobbyAppBarIconColor = Color(0xFF323232);
  static const gameLobbyPrimaryTextColor = Color(0xFF434343);
  static const gameLobbyPointsDollars = Color(0xFF34332E);
  static const gameLobbyWithdrawText1 = Color(0xFF518103);
  static const gameLobbyWithdrawText2 = Color(0xFF00ad38);
  static const gameLobbyTransferText1 = Color(0xFF987A4E);
  static const gameLobbyTransferText2 = Color(0xFF937104);
  static const gameItemMainColor = Colors.white;
  static const gameButtonGroupColor = Color(0xff2e3136);
  static const gameButtonGroupTextColor = Color(0xffffffff);
  static const gamePrimaryButtonColor = Color(0xff38d59f);
  static const gamePrimaryButtonTextColor = Color(0xffffffff);
  static const gameSecondButtonColor = Color(0xff43474a);
  static const gameSecondButtonColor1 = Colors.white;
  static const gameSecondButtonColor2 = Color(0xffe8fdff);
  static const gameSecondButtonTextColor = Color(0xff38d59f);
  static const withdrawalSuccess = Color(0xff38d59f);
  static const withdrawalFelid = Color(0xff93b6ae);
  static const modalDropDownActive = Color(0xff3de965);
  static const gameLobbyHintColor = Color(0xff38d59f);
  static const gameLobbyLoginFormColor = Color(0xff979797);
  static const gameLobbyLoginFormBorderColor = Color(0xFFd2deda);
  static const gameLobbyButtonDisableColor = Color(0xffe5f6f2);
  static const gameLobbyButtonDisableTextColor = Color(0xff93b6ae);
  static const gameLobbyDepositActiveColor = Color(0x1a38d59f);
  static const gameLobbyIconColor = Color(0xffCCD9D5);
  static const gameLobbyIconColor2 = Color(0xffd2deda);
  static const gameLobbyUserInfoColor1 = Color(0xffedffec);
  static const gameLobbyUserInfoColor2 = Color(0xffe8fdff);
  static const gameLobbyDividerColor = Color(0xffc7ece4);
  static const gameLobbyTabBgColor = Colors.white;
  static const gameLobbyTabTextColor = Color(0xFF979797);
  static const gameLobbyDialogColor1 = Colors.white;
  static const gameLobbyDialogColor2 = Color(0xffe8fdff);
  static const gameLobbyLoginPlaceholderColor = Color(0xffd2deda);
  static const gameLobbyBoxBgColor = Color(0xffe6f9f2);
  static const gameRecordLabelTextColor = Color(0xFF979797);
  static const gameLobbyEmptyColor = Color(0xffededed);
}

Map<String, Map<String, Color>> gameTheme = {
  'light': {
    'gameLobbyBgColor': LightThemeColors.gameLobbyBgColor,
    'gameLobbyAppBarTextColor': LightThemeColors.gameLobbyAppBarTextColor,
    'gameLobbyAppBarIconColor': LightThemeColors.gameLobbyAppBarIconColor,
    'gameLobbyPrimaryTextColor': LightThemeColors.gameLobbyPrimaryTextColor,
    'gameLobbyPointsDollars': LightThemeColors.gameLobbyPointsDollars,
    'gameLobbyWithdrawText1': LightThemeColors.gameLobbyWithdrawText1,
    'gameLobbyWithdrawText2': LightThemeColors.gameLobbyWithdrawText2,
    'gameLobbyTransferText1': LightThemeColors.gameLobbyTransferText1,
    'gameLobbyTransferText2': LightThemeColors.gameLobbyTransferText2,
    'gameItemMainColor': LightThemeColors.gameItemMainColor,
    'gameButtonGroupColor': LightThemeColors.gameButtonGroupColor,
    'gameButtonGroupTextColor': LightThemeColors.gameButtonGroupTextColor,
    'gamePrimaryButtonColor': LightThemeColors.gamePrimaryButtonColor,
    'gamePrimaryButtonTextColor': LightThemeColors.gamePrimaryButtonTextColor,
    'gameSecondButtonColor': LightThemeColors.gameSecondButtonColor,
    'gameSecondButtonColor1': LightThemeColors.gameSecondButtonColor1,
    'gameSecondButtonColor2': LightThemeColors.gameSecondButtonColor2,
    'gameSecondButtonTextColor': LightThemeColors.gameSecondButtonTextColor,
    'withdrawalSuccess': LightThemeColors.withdrawalSuccess,
    'withdrawalFelid': LightThemeColors.withdrawalFelid,
    'modalDropDownActive': LightThemeColors.modalDropDownActive,
    'gameLobbyHintColor': LightThemeColors.gameLobbyHintColor,
    'gameLobbyLoginFormColor': LightThemeColors.gameLobbyLoginFormColor,
    'gameLobbyLoginFormBorderColor':
        LightThemeColors.gameLobbyLoginFormBorderColor,
    'gameLobbyButtonDisableColor': LightThemeColors.gameLobbyButtonDisableColor,
    'gameLobbyButtonDisableTextColor':
        LightThemeColors.gameLobbyButtonDisableTextColor,
    'gameLobbyDepositActiveColor': LightThemeColors.gameLobbyDepositActiveColor,
    'gameLobbyIconColor': LightThemeColors.gameLobbyIconColor,
    'gameLobbyIconColor2': LightThemeColors.gameLobbyIconColor2,
    'gameLobbyUserInfoColor1': LightThemeColors.gameLobbyUserInfoColor1,
    'gameLobbyUserInfoColor2': LightThemeColors.gameLobbyUserInfoColor2,
    'gameLobbyDividerColor': LightThemeColors.gameLobbyDividerColor,
    'gameLobbyTabBgColor': LightThemeColors.gameLobbyTabBgColor,
    'gameLobbyTabTextColor': LightThemeColors.gameLobbyTabTextColor,
    'gameLobbyDialogColor1': LightThemeColors.gameLobbyDialogColor1,
    'gameLobbyDialogColor2': LightThemeColors.gameLobbyDialogColor2,
    'gameLobbyLoginPlaceholderColor':
        LightThemeColors.gameLobbyLoginPlaceholderColor,
    'gameLobbyBoxBgColor': LightThemeColors.gameLobbyBoxBgColor,
    'gameRecordLabelTextColor': LightThemeColors.gameRecordLabelTextColor,
    'gameLobbyEmptyColor': LightThemeColors.gameLobbyEmptyColor,
  },
  'dark': {
    'gameLobbyBgColor': DarkThemeColors.gameLobbyBgColor,
    'gameLobbyAppBarTextColor': DarkThemeColors.gameLobbyAppBarTextColor,
    'gameLobbyAppBarIconColor': DarkThemeColors.gameLobbyAppBarIconColor,
    'gameLobbyPrimaryTextColor': DarkThemeColors.gameLobbyPrimaryTextColor,
    'gameLobbyPointsDollars': DarkThemeColors.gameLobbyPointsDollars,
    'gameLobbyWithdrawText1': DarkThemeColors.gameLobbyWithdrawText1,
    'gameLobbyWithdrawText2': DarkThemeColors.gameLobbyWithdrawText2,
    'gameLobbyTransferText1': DarkThemeColors.gameLobbyTransferText1,
    'gameLobbyTransferText2': DarkThemeColors.gameLobbyTransferText2,
    'gameItemMainColor': DarkThemeColors.gameItemMainColor,
    'gameButtonGroupColor': DarkThemeColors.gameButtonGroupColor,
    'gameButtonGroupTextColor': DarkThemeColors.gameButtonGroupTextColor,
    'gamePrimaryButtonColor': DarkThemeColors.gamePrimaryButtonColor,
    'gamePrimaryButtonTextColor': DarkThemeColors.gamePrimaryButtonTextColor,
    'gameSecondButtonColor': DarkThemeColors.gameSecondButtonColor,
    'gameSecondButtonColor1': DarkThemeColors.gameSecondButtonColor1,
    'gameSecondButtonColor2': DarkThemeColors.gameSecondButtonColor2,
    'gameSecondButtonTextColor': DarkThemeColors.gameSecondButtonTextColor,
    'withdrawalSuccess': DarkThemeColors.withdrawalSuccess,
    'withdrawalFelid': DarkThemeColors.withdrawalFelid,
    'modalDropDownActive': DarkThemeColors.modalDropDownActive,
    'gameLobbyHintColor': DarkThemeColors.gameLobbyHintColor,
    'gameLobbyLoginFormColor': DarkThemeColors.gameLobbyLoginFormColor,
    'gameLobbyLoginFormBorderColor':
        DarkThemeColors.gameLobbyLoginFormBorderColor,
    'gameLobbyButtonDisableColor': DarkThemeColors.gameLobbyButtonDisableColor,
    'gameLobbyButtonDisableTextColor':
        DarkThemeColors.gameLobbyButtonDisableTextColor,
    'gameLobbyDepositActiveColor': DarkThemeColors.gameLobbyDepositActiveColor,
    'gameLobbyIconColor': DarkThemeColors.gameLobbyIconColor,
    'gameLobbyIconColor2': DarkThemeColors.gameLobbyIconColor2,
    'gameLobbyUserInfoColor1': DarkThemeColors.gameLobbyUserInfoColor1,
    'gameLobbyUserInfoColor2': DarkThemeColors.gameLobbyUserInfoColor2,
    'gameLobbyDividerColor': DarkThemeColors.gameLobbyDividerColor,
    'gameLobbyTabBgColor': DarkThemeColors.gameLobbyTabBgColor,
    'gameLobbyTabTextColor': DarkThemeColors.gameLobbyTabTextColor,
    'gameLobbyDialogColor1': DarkThemeColors.gameLobbyDialogColor1,
    'gameLobbyDialogColor2': DarkThemeColors.gameLobbyDialogColor2,
    'gameLobbyLoginPlaceholderColor':
        DarkThemeColors.gameLobbyLoginPlaceholderColor,
    'gameLobbyBoxBgColor': DarkThemeColors.gameLobbyBoxBgColor,
    'gameRecordLabelTextColor': DarkThemeColors.gameRecordLabelTextColor,
    'gameLobbyEmptyColor': DarkThemeColors.gameLobbyEmptyColor,
  }
};
