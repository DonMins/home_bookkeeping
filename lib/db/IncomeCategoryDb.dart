import 'package:home_bookkeeping/db/Users.dart';

class IncomeCategoryDb {
  int id;
  String nameCategory;
  UsersDb user;
  IncomeCategoryDb(this.id, this.nameCategory,this.user);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_income_category': id,
      'nameCategory': nameCategory,
      'user_id': user.id,
    };
    return map;
  }

  IncomeCategoryDb.fromMap(Map<String, dynamic> map) {
    id = map['id_income_category'];
    nameCategory = map['nameCategory'];
    user = new UsersDb(map['user_id'], map['login'], map['password']);
  }
}
