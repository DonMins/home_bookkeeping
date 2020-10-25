import 'package:home_bookkeeping/db/AccountDb.dart';

class TransferDb {
  int id;
  String date;
  double amount;
  AccountDb accountFrom;
  AccountDb accountTo;

  TransferDb(this.id, this.date, this.amount, this.accountFrom, this.accountTo);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_transfer': id,
      'date': date,
      'amount': amount,
      'accountFrom': accountFrom.id,
      'accountTo': accountTo.id,
    };
    return map;
  }

  TransferDb.fromMap(Map<String, dynamic> map) {
    id = map['id_transfer'];
    date = map['date'];
    amount = map['amount'];
    accountFrom = new AccountDb(
        map['id_accountFrom'],
        map['name_accountFrom'],
        map['balance_accountFrom'],
        map['cartNum_accountFrom'],
        map['description_accountFrom']);

    accountTo = new AccountDb(
        map['id_accountTo'],
        map['name_accountTo'],
        map['balance_accountTo'],
        map['cartNum_accountTo'],
        map['description_accountTO']);
  }
}
