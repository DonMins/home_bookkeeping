import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'AccountDB.dart';
import 'ExpenseCategoryDb.dart';
import 'IncomeCategoryDb.dart';


class HelperDB {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String BALANCE = 'balance';
  static const String CART_NUM = 'cartNum';
  static const String DESCRIPTION = 'description';
  static const String TABLE_ACCOUNT = 'account_table1';
  static const String NAME_CATEGORY = 'nameCategory';
  static const String TABLE_INCOME_CATEGORY = 'income_category';
  static const String TABLE_EXPENSE_CATEGORY = 'expense_category ';
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
    await deleteDatabase(path);

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE_ACCOUNT ($ID INTEGER PRIMARY KEY,"
        " $BALANCE REAL,"
        " $CART_NUM TEXT,"
        " $DESCRIPTION TEXT,"
        " $NAME TEXT"
        ")");

    await db
        .execute("CREATE TABLE $TABLE_INCOME_CATEGORY ($ID INTEGER PRIMARY KEY, $NAME_CATEGORY TEXT)");

    await db
        .execute("CREATE TABLE $TABLE_EXPENSE_CATEGORY ($ID INTEGER PRIMARY KEY, $NAME_CATEGORY TEXT)");
  }

  Future<AccountDb> saveAccount(AccountDb account) async {
    var dbClient = await db;
    account.id = await dbClient.insert(TABLE_ACCOUNT, account.toMap());
    return account;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

  Future<List<AccountDb>> getAccounts() async {
    var dbClient = await db;
    // List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME]);
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_ACCOUNT");
    List<AccountDb> accounts = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        accounts.add(AccountDb.fromMap(maps[i]));
      }
    }
    return accounts;
  }

  Future<int> deleteAccount(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE_ACCOUNT, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updateAccount(AccountDb employee) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_ACCOUNT, employee.toMap(),
        where: '$ID = ?', whereArgs: [employee.id]);
  }

  Future<IncomeCategoryDb> saveIncomeCategory(IncomeCategoryDb incomeCategoryDb) async {
    var dbClient = await db;
    incomeCategoryDb.id = await dbClient.insert(TABLE_INCOME_CATEGORY, incomeCategoryDb.toMap());
    return incomeCategoryDb;
  }

  Future<List<IncomeCategoryDb>> getIncomeCategory() async {
    var dbClient = await db;
    // List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME_CATEGORY]);
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_INCOME_CATEGORY");
    List<IncomeCategoryDb> incomeCategoryDb = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        incomeCategoryDb.add(IncomeCategoryDb.fromMap(maps[i]));
      }
    }
    return incomeCategoryDb;
  }

  Future<int> deleteIncomeCategory(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE_INCOME_CATEGORY, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updateIncomeCategory(IncomeCategoryDb incomeCategoryDb) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_INCOME_CATEGORY, incomeCategoryDb.toMap(),
        where: '$ID = ?', whereArgs: [incomeCategoryDb.id]);
  }


  Future<ExpenseCategoryDb> saveExpenseCategory(ExpenseCategoryDb expenseCategory) async {
    var dbClient = await db;
    expenseCategory.id = await dbClient.insert(TABLE_EXPENSE_CATEGORY, expenseCategory.toMap());
    return expenseCategory;
  }

  Future<List<ExpenseCategoryDb>> getExpenseCategory() async {
    var dbClient = await db;
    // List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME_CATEGORY]);
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_EXPENSE_CATEGORY");
    List<ExpenseCategoryDb> incomeCategoryDb = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        incomeCategoryDb.add(ExpenseCategoryDb.fromMap(maps[i]));
      }
    }
    return incomeCategoryDb;
  }

  Future<int> deleteExpenseCategory(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE_EXPENSE_CATEGORY, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updateExpenseCategory(ExpenseCategoryDb expenseCategory) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_EXPENSE_CATEGORY, expenseCategory.toMap(),
        where: '$ID = ?', whereArgs: [expenseCategory.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}