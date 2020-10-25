class IncomeCategoryDb {
  int id;
  String nameCategory;
  IncomeCategoryDb(this.id, this.nameCategory);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id_income_category': id,
      'nameCategory': nameCategory,
    };
    return map;
  }

  IncomeCategoryDb.fromMap(Map<String, dynamic> map) {
    id = map['id_income_category'];
    nameCategory = map['nameCategory'];
  }
}
