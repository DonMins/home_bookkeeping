import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'IncomeCategoryDb.dart';

class IncomeCategoryHelperDb {
  static Database _db;
  static const String ID = 'id';
  static const String NAME_CATEGORY = 'nameCategory';
  static const String TABLE = 'income_category';
  static const String DB_NAME = 'home_bookkeeping.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME_CATEGORY TEXT)");
  }

  Future<IncomeCategoryDb> save(IncomeCategoryDb incomeCategoryDb) async {
    var dbClient = await db;
    incomeCategoryDb.id = await dbClient.insert(TABLE, incomeCategoryDb.toMap());
    return incomeCategoryDb;
  }

  Future<List<IncomeCategoryDb>> getIncomeCategory() async {
    var dbClient = await db;
    // List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME_CATEGORY]);
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<IncomeCategoryDb> incomeCategoryDb = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        incomeCategoryDb.add(IncomeCategoryDb.fromMap(maps[i]));
      }
    }
    return incomeCategoryDb;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(IncomeCategoryDb incomeCategoryDb) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, incomeCategoryDb.toMap(),
        where: '$ID = ?', whereArgs: [incomeCategoryDb.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}