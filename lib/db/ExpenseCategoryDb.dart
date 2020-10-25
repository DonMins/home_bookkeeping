class ExpenseCategoryDb {
  int id;
  String nameCategory;
  ExpenseCategoryDb(this.id, this.nameCategory);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_expense_category': id,
      'nameCategory': nameCategory,
    };
    return map;
  }

  ExpenseCategoryDb.fromMap(Map<String, dynamic> map) {
    id = map['id_expense_category'];
    nameCategory = map['nameCategory'];
  }
}
