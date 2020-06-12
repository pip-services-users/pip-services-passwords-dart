import 'package:pip_services3_commons/pip_services3_commons.dart';

class UserPasswordInfoV1 implements IStringIdentifiable {
  @override
  String id;
  DateTime change_time;
  bool locked;
  DateTime lock_time;

  UserPasswordInfoV1(
      {String id, DateTime change_time, bool locked, DateTime lock_time})
      : id = id,
        change_time = change_time,
        locked = locked,
        lock_time = lock_time;

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    var change_time_json = json['change_time'];
    change_time =
        change_time_json != null ? DateTime.tryParse(change_time_json) : null;
    locked = json['locked'];
    var lock_time_json = json['lock_time'];
    lock_time =
        lock_time_json != null ? DateTime.tryParse(lock_time_json) : null;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'change_time':
          change_time != null ? change_time.toIso8601String() : change_time,
      'locked': locked,
      'lock_time': lock_time != null ? lock_time.toIso8601String() : lock_time
    };
  }

  factory UserPasswordInfoV1.fromJson(Map<String, dynamic> json) {
    var pass = UserPasswordInfoV1();
    pass.fromJson(json);
    return pass;
  }
}
