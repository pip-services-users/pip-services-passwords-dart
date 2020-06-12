import 'package:pip_services3_commons/pip_services3_commons.dart';

class UserPasswordV1 implements IStringIdentifiable {
  @override
  /* Identification */
  String id;
  String password;

  /* Password management */
  DateTime change_time;
  bool locked;
  DateTime lock_time;
  num fail_count;
  DateTime fail_time;
  String rec_code;
  DateTime rec_expire_time;

  /* Custom fields */
  dynamic custom_hdr;
  dynamic custom_dat;

  UserPasswordV1(
      {String id,
      String password,
      DateTime change_time,
      bool locked,
      DateTime lock_time,
      num fail_count,
      DateTime fail_time,
      String rec_code,
      DateTime rec_expire_time,
      dynamic custom_hdr,
      dynamic custom_dat})
      : id = id,
        password = password,
        change_time = change_time,
        locked = locked ?? false,
        lock_time = lock_time,
        fail_count = fail_count,
        fail_time = fail_time,
        rec_code = rec_code,
        rec_expire_time = rec_expire_time,
        custom_hdr = custom_hdr,
        custom_dat = custom_dat;

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    var change_time_json = json['change_time'];
    change_time =
        change_time_json != null ? DateTime.tryParse(change_time_json) : null;
    locked = json['locked'];
    var lock_time_json = json['lock_time'];
    lock_time =
        lock_time_json != null ? DateTime.tryParse(lock_time_json) : null;
    fail_count = json['fail_count'];
    var fail_time_json = json['fail_time'];
    fail_time =
        fail_time_json != null ? DateTime.tryParse(fail_time_json) : null;
    rec_code = json['rec_code'];
    var rec_expire_time_json = json['rec_expire_time'];
    rec_expire_time = rec_expire_time_json != null
        ? DateTime.tryParse(rec_expire_time_json)
        : null;
    custom_hdr = json['custom_hdr'];
    custom_dat = json['custom_dat'];
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'password': password,
      'change_time':
          change_time != null ? change_time.toIso8601String() : change_time,
      'locked': locked,
      'lock_time': lock_time != null ? lock_time.toIso8601String() : lock_time,
      'fail_count': fail_count,
      'fail_time': fail_time != null ? fail_time.toIso8601String() : fail_time,
      'rec_code': rec_code,
      'rec_expire_time': rec_expire_time != null
          ? rec_expire_time.toIso8601String()
          : rec_expire_time,
      'custom_hdr': custom_hdr,
      'custom_dat': custom_dat
    };
  }

  factory UserPasswordV1.fromJson(Map<String, dynamic> json) {
    var pass = UserPasswordV1();
    pass.fromJson(json);
    return pass;
  }
}
