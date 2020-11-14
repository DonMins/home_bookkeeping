import 'package:home_bookkeeping/db/Users.dart';

class ExpenseCategoryDb {
  int id;
  String nameCategory;
  UsersDb user;
  ExpenseCategoryDb(this.id, this.nameCategory,this.user);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_expense_category': id,
      'nameCategory': nameCategory,
      'user_id': user.id,
    };
    return map;
  }

  ExpenseCategoryDb.fromMap(Map<String, dynamic> map) {
    id = map['id_expense_category'];
    nameCategory = map['nameCategory'];
    user = new UsersDb(map['user_id'], map['login'], map['password']);
  }
}
