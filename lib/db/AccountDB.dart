import 'dart:ffi';

class AccountDB {
  int id;
  String name;
  double balance;
  String cartNum;
  String description;

  AccountDB(this.id, this.name,this.balance,this.cartNum,this.description);
  // AccountDB(this.id, this.name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'balance': balance,
      'cartNum': cartNum,
      'description': description,
    };
    return map;
  }

  AccountDB.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    balance = map['balance'];
    cartNum = map['cartNum'];
    description = map['description'];
  }
}