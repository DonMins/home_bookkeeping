import 'dart:ffi';

import 'package:home_bookkeeping/db/AccountDb.dart';
import 'package:home_bookkeeping/db/IncomeCategoryDb.dart';

class IncomeDb {
  int id;
  String date;
  double amount;
  AccountDb account;
  String nameCategory;

  IncomeDb(this.id, this.date,this.amount,this.account, this.nameCategory);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_income': id,
      'date': date,
      'amount': amount,
      'account': account.id,
      'nameCategory': nameCategory,
    };
    return map;
  }

  IncomeDb.fromMap(Map<String, dynamic> map) {
    id = map['id_income'];
    date = map['date'];
    amount = map['amount'];
    account = new AccountDb(map['id_account'], map['name'],
        map['balance'],  map['cartNum'], map['description']);
    nameCategory = map['nameCategory'];
  }
}