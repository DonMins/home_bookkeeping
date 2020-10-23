import 'dart:ffi';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
