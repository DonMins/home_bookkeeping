import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'AccountDB.dart';


class HelperDB {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String cartNum = 'cartNum';
  static const String balance = 'balance';
  static const String description = 'description';
  static const String TABLE = 'AccountDB';
  static const String DB_NAME = 'accountDb3.db';

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
    await deleteDatabase(path);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);

    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT, "
        "$cartNum TEXT,"
        " $description TEXT,"
        "$balance REAL)");
  }

  Future<AccountDB> save(AccountDB employee) async {
    var dbClient = await db;
    employee.id = await dbClient.insert(TABLE, employee.toMap());
    return employee;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

  Future<List<AccountDB>> getEmployees() async {
    var dbClient = await db;
    // List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME,cartNum,description,balance]);
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<AccountDB> employees = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        employees.add(AccountDB.fromMap(maps[i]));
      }
    }
    return employees;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(AccountDB employee) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, employee.toMap(),
        where: '$ID = ?', whereArgs: [employee.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}