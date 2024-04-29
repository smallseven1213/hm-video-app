import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:game/models/third_login_api_response_with_data.dart';
import 'package:intl/intl.dart';

String intlAmount(int amount, String currency) {
  return '${amount > 0 ? NumberFormat.currency(
      locale: currencyMapper[amount] ?? 'zh-TW',
      symbol: '',
    ).format(
      DecimalIntl(
        Decimal.parse(amount.toString()),
      ),
    ) : '0.00'} $currency}';
}
