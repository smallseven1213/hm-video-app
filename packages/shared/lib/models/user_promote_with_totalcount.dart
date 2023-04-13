import 'package:shared/models/user_promote_record.dart';

class UserPromoteWithTotalCount {
  final int total;
  final List<UserPromoteRecord> record;
  UserPromoteWithTotalCount(this.record, this.total);
}
