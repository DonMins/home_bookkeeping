import 'package:home_bookkeeping/db/AccountDb.dart';

class ExpensesDb {
  int id;
  String date;
  double amount;
  AccountDb account;
  String nameCategory;

  ExpensesDb(this.id, this.date, this.amount, this.account, this.nameCategory);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_expenses': id,
      'date': date,
      'amount': amount,
      'account': account.id,
      'nameCategory': nameCategory,
    };
    return map;
  }

  ExpensesDb.fromMap(Map<String, dynamic> map) {
    id = map['id_expenses'];
    date = map['date'];
    amount = map['amount'];
    account = new AccountDb(map['id_account'], map['name'], map['balance'],
        map['cartNum'], map['description']);
    nameCategory = map['nameCategory'];
  }
}
