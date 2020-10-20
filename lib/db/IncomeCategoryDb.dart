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
      'id': id,
      'nameCategory': nameCategory,
    };
    return map;
  }

  IncomeCategoryDb.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nameCategory = map['nameCategory'];
  }
}
