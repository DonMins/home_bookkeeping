import 'dart:ffi';

class AccountDB {
  int id;
  String name;
  // Double balance;
  // String cartNum;
  // String description;

  // AccountDB(this.id, this.name,this.balance,this.cartNum,this.description);
  AccountDB(this.id, this.name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      // 'balance': balance,
      // 'cartNum': cartNum,
      // 'description': description,
    };
    return map;
  }

  AccountDB.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    // name = map['balance'];
    // name = map['cartNum'];
    // name = map['description'];
  }
}