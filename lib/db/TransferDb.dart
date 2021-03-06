import 'package:home_bookkeeping/db/AccountDb.dart';
import 'package:home_bookkeeping/db/Users.dart';

class TransferDb {
  int id;
  String date;
  double amount;
  AccountDb accountFrom;
  AccountDb accountTo;
  UsersDb user;

  TransferDb(this.id, this.date, this.amount, this.accountFrom, this.accountTo,this.user);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_transfer': id,
      'date': date,
      'amount': amount,
      'accountFrom': accountFrom.id,
      'accountTo': accountTo.id,
      'user_id': user.id,
    };
    return map;
  }

  TransferDb.fromMap(Map<String, dynamic> map) {
    id = map['id_transfer'];
    date = map['date'];
    amount = map['amount'];
    user = new UsersDb(map['user_id'], map['login'], map['password']);
    accountFrom = new AccountDb(
        map['id_accountFrom'],
        map['name_accountFrom'],
        map['balance_accountFrom'],
        map['cartNum_accountFrom'],
        map['description_accountFrom'],user);

    accountTo = new AccountDb(
        map['id_accountTo'],
        map['name_accountTo'],
        map['balance_accountTo'],
        map['cartNum_accountTo'],
        map['description_accountTO'],user);
  }

  TransferDb.fromJson(Map<String, dynamic> map) {
    id = int.parse(map['id']);
    date = map['date'];
    amount = map['amount'];
    user = new UsersDb(int.parse(map['user']['id']), map['user']['login'], map['user']['password']);
    accountFrom = new AccountDb(int.parse(map['accountFrom']['id']), map['accountFrom']['name'], map['accountFrom']['balance'],
        map['accountFrom']['cartNum'], map['accountFrom']['description'],user);
    accountTo = new AccountDb(int.parse(map['accounTo']['id']), map['accounTo']['name'], map['accounTo']['balance'],
        map['accounTo']['cartNum'], map['accounTo']['description'],user);
  }
}
