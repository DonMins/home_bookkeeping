import 'package:home_bookkeeping/db/AccountDb.dart';

class UsersDb {
  int id;
  String login;
  String password;

  UsersDb(this.id, this.login, this.password);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_id': id,
      'login': login,
      'password': password
    };
    return map;
  }

  UsersDb.fromMap(Map<String, dynamic> map) {
    id = map['user_id'];
    login = map['login'];
    password = map['password'];
  }
}
