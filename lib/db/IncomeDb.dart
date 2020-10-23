import 'dart:ffi';

import 'package:home_bookkeeping/db/AccountDb.dart';
import 'package:home_bookkeeping/db/IncomeCategoryDb.dart';

class IncomeDb {
  int id;
  DateTime date;
  double amount;
  String account;
  String nameCategory;

  IncomeDb(this.id, this.date,this.amount,this.account, this.nameCategory);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'date': date,
      'amount': amount,
      'account': account,
      'nameCategory': nameCategory,
    };
    return map;
  }

  IncomeDb.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    date = map['date'];
    amount = map['amount'];
    account = map['account'];
    nameCategory = map['nameCategory'];
  }
}