
import 'package:home_bookkeeping/db/Users.dart';

class AccountDb {
  int id;
  String name;
  double balance;
  String cartNum;
  String description;
  UsersDb user;

  AccountDb(this.id, this.name,this.balance,this.cartNum,this.description,this.user);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_account': id,
      'name': name,
      'balance': balance,
      'cartNum': cartNum,
      'description': description,
      'user_id': user.id,
    };
    return map;
  }

  AccountDb.fromMap(Map<String, dynamic> map) {
    id = map['id_account'];
    name = map['name'];
    balance = map['balance'];
    cartNum = map['cartNum'];
    description = map['description'];
    user = new UsersDb(map['user_id'], map['login'], map['password']);
  }
}