import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../apis/user_api.dart';
import '../models/index.dart';
import '../models/user.dart';
import '../models/wallet_item.dart';

class UserController extends GetxController {
  var info = User(
    '',
    0,
    [],
  ).obs;
  var token = ''.obs;
  var wallets = <WalletItem>[].obs;
  var isLoading = false.obs;
  var totalAmount = 0.0.obs;
  var loginCode = ''.obs;
  var promoteData = UserPromote('', '', -1, -1).obs;

  bool get isGuest => info.value.roles.contains('guest');
  GetStorage box = GetStorage();

  @override
  void onReady() {
    super.onReady();
    String? storedToken = box.read('token');
    if (storedToken != null) {
      token.value = storedToken;
    }

    ever(token, (_) => mutateAll());
  }

  void _updateWallets(WalletItem walletItem) {
    if (wallets.indexWhere((element) => element.type == walletItem.type) !=
        -1) {
      wallets[wallets.indexWhere((element) => element.type == walletItem.type)]
          .amount = walletItem.amount;
    } else {
      wallets.add(walletItem);
    }

    totalAmount.value =
        wallets.fold(0.0, (sum, item) => sum + (item.amount ?? 0));
  }

  Future<void> _fetchUserInfo() async {
    isLoading.value = true;
    try {
      var userApi = UserApi();
      var res = await userApi.getCurrentUser();
      info.value = res;

      _updateWallets(WalletItem(
          type: WalletType.main, amount: double.parse(res.points ?? '0')));
    } catch (error) {
      print(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getLoginCode() async {
    isLoading.value = true;
    try {
      var authApi = AuthApi();
      var res = await authApi.getLoginCode();
      print('res.data: ${res.data}');
      loginCode.value = res.data;
    } catch (error) {
      print(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserPromoteData() async {
    isLoading.value = true;
    try {
      var userApi = UserApi();
      UserPromote res = await userApi.getUserPromote();
      promoteData.value = res;
    } catch (error) {
      print(error);
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> _fetchWallets() async {
  //   isLoading.value = true;
  //   try {
  //     var res = await Get.put(GamePlatformProvider()).getPoints();
  //     _updateWallets(WalletItem(
  //         type: WalletType.wali, amount: double.parse(res['balance'] ?? '0')));
  //   } catch (error) {
  //     print(error);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void mutateAll() {
    _fetchUserInfo();
    // _fetchWallets();
    getLoginCode();
    getUserPromoteData();
  }

  void mutateInfo(User? user, bool revalidateFromServer) {
    if (user != null) {
      info.value = user;
    }
    if (revalidateFromServer) {
      _fetchUserInfo();
    }
  }

  void mutateWallets(WalletItem? walletItem, bool revalidateFromServer) {
    if (walletItem != null) {
      _updateWallets(walletItem);
    }
    if (revalidateFromServer) {
      // _fetchWallets();
    }
  }

  void setToken(String? token) {
    var nextToken = token ?? '';
    this.token.value = nextToken;
    box.write('auth-token', nextToken);
  }
}
