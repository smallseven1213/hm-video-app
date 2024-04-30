import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:game/models/third_login_api_response_with_data.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

String intlAmount(int amount, String currency) {
  var getLocale = GetStorage('locale').read('locale');
  return '${amount > 0 ? NumberFormat.currency(
      locale: getLocale ?? 'zh-TW',
      symbol: '',
    ).format(
      DecimalIntl(
        Decimal.parse(amount.toString()),
      ),
    ) : '0.00'} $currency';
}
