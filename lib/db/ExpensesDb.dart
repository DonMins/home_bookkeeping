import 'package:home_bookkeeping/db/AccountDb.dart';
import 'package:home_bookkeeping/db/Users.dart';

class ExpensesDb {
  int id;
  String date;
  double amount;
  AccountDb account;
  String nameCategory;
  UsersDb user;

  ExpensesDb(this.id, this.date, this.amount, this.account, this.nameCategory,
      this.user);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_expenses': id,
      'date': date,
      'amount': amount,
      'account': account.id,
      'nameCategory': nameCategory,
      'user_id': user.id,
    };
    return map;
  }

  ExpensesDb.fromMap(Map<String, dynamic> map) {
    id = map['id_expenses'];
    date = map['date'];
    amount = map['amount'];
    user = new UsersDb(map['user_id'], map['login'], map['password']);
    account = new AccountDb(map['id_account'], map['name'], map['balance'],
        map['cartNum'], map['description'],user);
    nameCategory = map['nameCategory'];
  }

  ExpensesDb.fromJson(Map<String, dynamic> map) {
    id = int.parse(map['id']);
    date = map['date'];
    amount = map['amount'];
    user = new UsersDb(int.parse(map['user']['id']), map['user']['login'], map['user']['password']);
    account = new AccountDb(int.parse(map['account']['id']), map['account']['name'], map['account']['balance'],
        map['account']['cartNum'], map['account']['description'],user);
    nameCategory = map['nameCategory']['nameCategory'];
  }
}
