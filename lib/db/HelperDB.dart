import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:home_bookkeeping/db/ExpensesDb.dart';
import 'package:home_bookkeeping/db/IncomeDb.dart';
import 'package:home_bookkeeping/db/TransferDb.dart';
import 'package:home_bookkeeping/db/Users.dart';
import 'package:kinfolk/kinfolk.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'AccountDb.dart';
import 'ExpenseCategoryDb.dart';
import 'IncomeCategoryDb.dart';

class HelperDB {
  static Database _db;
  static const String ID_ACCOUNT = 'id_account';
  static const String ID_INCOME = 'id_income';
  static const String ID_EXPENSES = 'id_expenses';
  static const String ID_TRANSFER = 'id_transfer';
  static const String ID_USER = 'user_id';
  static const String ID_INCOME_CATEGORY = 'id_income_category';
  static const String ID_EXPENSE_CATEGORY = 'id_expense_category';
  static const String NAME = 'name';
  static const String BALANCE = 'balance';
  static const String AMOUNT = 'amount';
  static const String DATE = 'date';
  static const String ACCOUNT = 'account';
  static const String CART_NUM = 'cartNum';
  static const String ACCOUNT_TO = 'accountTo';
  static const String ACCOUNT_FROM = 'accountFrom';
  static const String DESCRIPTION = 'description';
  static const String TABLE_ACCOUNT = 'account_table1';
  static const String NAME_CATEGORY = 'nameCategory';
  static const String TABLE_INCOME_CATEGORY = 'income_category';
  static const String TABLE_INCOME = 'income';
  static const String TABLE_TRANSFER = 'transfer';
  static const String TABLE_EXPENSES = 'expenses';
  static const String TABLE_USERS = 'users';
  static const String LOGIN = 'login';
  static const String PASSWORD = 'password';
  static const String TABLE_EXPENSE_CATEGORY = 'expense_category ';
  static const String DB_NAME = 'home_bookkeeping2.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Database getDatabase() {
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
        .execute("CREATE TABLE $TABLE_ACCOUNT ($ID_ACCOUNT INTEGER PRIMARY KEY,"
            " $BALANCE REAL,"
            " $ID_USER INTEGER,"
            " $CART_NUM TEXT,"
            " $DESCRIPTION TEXT,"
            " $NAME TEXT,"
            "FOREIGN KEY ($ID_USER) REFERENCES $TABLE_USERS ($ID_USER)"
            ")");

    await db.execute("CREATE TABLE $TABLE_INCOME_CATEGORY ("
        "$ID_INCOME_CATEGORY INTEGER PRIMARY KEY,"
        " $NAME_CATEGORY TEXT,"
        " $ID_USER INTEGER,"
        "FOREIGN KEY ($ID_USER) REFERENCES $TABLE_USERS ($ID_USER)"
        ")");

    await db.execute("CREATE TABLE $TABLE_USERS ($ID_USER INTEGER PRIMARY KEY,"
        " $LOGIN TEXT UNIQUE,"
        " $PASSWORD TEXT"
        ")");

    await db.execute(
        "CREATE TABLE $TABLE_EXPENSE_CATEGORY ($ID_EXPENSE_CATEGORY INTEGER PRIMARY KEY, "
        "$NAME_CATEGORY TEXT,"
        " $ID_USER INTEGER,"
        "FOREIGN KEY ($ID_USER) REFERENCES $TABLE_USERS ($ID_USER)"
        ")");

    await db
        .execute("CREATE TABLE $TABLE_INCOME ($ID_INCOME INTEGER PRIMARY KEY, "
            "$NAME_CATEGORY TEXT,"
            "$ACCOUNT INTEGER,"
            "$AMOUNT REAL,"
            "$DATE DATETIME,"
            "$ID_USER INTEGER,"
            "FOREIGN KEY ($ID_USER) REFERENCES $TABLE_USERS ($ID_USER),"
            "FOREIGN KEY ($ACCOUNT) REFERENCES $TABLE_ACCOUNT ($ID_ACCOUNT)"
            ")");

    await db.execute(
        "CREATE TABLE $TABLE_EXPENSES ($ID_EXPENSES INTEGER PRIMARY KEY, "
        "$NAME_CATEGORY TEXT,"
        "$ACCOUNT INTEGER,"
        "$AMOUNT REAL,"
        "$DATE DATETIME,"
        " $ID_USER INTEGER,"
        "FOREIGN KEY ($ID_USER) REFERENCES $TABLE_USERS ($ID_USER),"
        "FOREIGN KEY ($ACCOUNT) REFERENCES $TABLE_ACCOUNT ($ID_ACCOUNT)"
        ")");

    await db.execute(
        "CREATE TABLE $TABLE_TRANSFER ($ID_TRANSFER INTEGER PRIMARY KEY, "
        "$ACCOUNT_FROM INTEGER,"
        "$ACCOUNT_TO INTEGER,"
        "$AMOUNT REAL,"
        "$DATE DATETIME,"
        "$ID_USER INTEGER,"
        "FOREIGN KEY ($ID_USER) REFERENCES $TABLE_USERS ($ID_USER)"
        "FOREIGN KEY ($ACCOUNT_FROM) REFERENCES $TABLE_ACCOUNT ($ID_ACCOUNT),"
        "FOREIGN KEY ($ACCOUNT_TO) REFERENCES $TABLE_ACCOUNT ($ID_ACCOUNT)"
        ")");

    await db.rawInsert(
        "INSERT INTO $TABLE_INCOME_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Зарплата',0);");
    await db.rawInsert(
        "INSERT INTO $TABLE_INCOME_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Пенсия',0);");
    await db.rawInsert(
        "INSERT INTO $TABLE_INCOME_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Лотерея',0);");
    await db.rawInsert(
        "INSERT INTO $TABLE_INCOME_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Подарок',0);");
    await db.rawInsert(
        "INSERT INTO $TABLE_INCOME_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Находка',0);");
    await db.rawInsert(
        "INSERT INTO $TABLE_INCOME_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Продажа',0);");

    await db.rawInsert(
        "INSERT INTO $TABLE_ACCOUNT ($BALANCE,$CART_NUM,$DESCRIPTION, $NAME,$ID_USER) "
        "VALUES (40000,'56345634534634','Счет семьи', 'Общий счет',1);");
    await db.rawInsert(
        "INSERT INTO $TABLE_ACCOUNT ($BALANCE,$CART_NUM,$DESCRIPTION, $NAME,$ID_USER) "
        "VALUES (400000,'56232323423','Счет для накоплений', 'Накопительный',1);");

    await db.rawInsert(
        "INSERT INTO $TABLE_EXPENSE_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Автомобиль',0);");
    await db.rawInsert(
        "INSERT INTO $TABLE_EXPENSE_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Дом',0);");
    await db.rawInsert(
        "INSERT INTO $TABLE_EXPENSE_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Одежда',0);");
    await db.rawInsert(
        "INSERT INTO $TABLE_EXPENSE_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Развлечения',0);");
    await db.rawInsert(
        "INSERT INTO $TABLE_EXPENSE_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Медицина',0);");
    await db.rawInsert(
        "INSERT INTO $TABLE_EXPENSE_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Продукты питания',0);");

    await db.rawInsert(
        "INSERT INTO $TABLE_USERS ($LOGIN,$PASSWORD) VALUES ('2','2');");
    await db.rawInsert(
        "INSERT INTO $TABLE_USERS ($LOGIN,$PASSWORD) VALUES ('1','1');");
  }

  Future<AccountDb> saveAccount(AccountDb account) async {
    var dbClient = await db;
    account.id = await dbClient.insert(TABLE_ACCOUNT, account.toMap());
    return account;
  }

  Future<List<AccountDb>> getAccounts(UsersDb user) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_ACCOUNT where $ID_USER=" + user.id.toString());
    List<AccountDb> accounts = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        accounts.add(AccountDb.fromMap(maps[i]));
      }
    }
    var response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
        headers: {
          "Accept": "application/json"
        }
    );
    String data = json.decode(response.body);
    print("Слова с сервера" + data);
    return accounts;
  }

  Future<int> deleteAccount(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE_ACCOUNT, where: '$ID_ACCOUNT = ?', whereArgs: [id]);
  }

  Future<int> updateAccount(AccountDb accountDb) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_ACCOUNT, accountDb.toMap(),
        where: '$ID_ACCOUNT = ?', whereArgs: [accountDb.id]);
  }

  Future<IncomeCategoryDb> saveIncomeCategory(
      IncomeCategoryDb incomeCategoryDb) async {
    var dbClient = await db;
    incomeCategoryDb.id =
        await dbClient.insert(TABLE_INCOME_CATEGORY, incomeCategoryDb.toMap());
    return incomeCategoryDb;
  }

  Future<List<IncomeCategoryDb>> getIncomeCategory(UsersDb user) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery(
        "SELECT * FROM $TABLE_INCOME_CATEGORY where $ID_USER=" +
            user.id.toString()+" or $ID_USER=0");
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
    return await dbClient.delete(TABLE_INCOME_CATEGORY,
        where: '$ID_INCOME_CATEGORY = ?', whereArgs: [id]);
  }

  Future<int> updateIncomeCategory(IncomeCategoryDb incomeCategoryDb) async {
    var dbClient = await db;
    return await dbClient.update(
        TABLE_INCOME_CATEGORY, incomeCategoryDb.toMap(),
        where: '$ID_INCOME_CATEGORY = ?', whereArgs: [incomeCategoryDb.id]);
  }

  Future<ExpenseCategoryDb> saveExpenseCategory(
      ExpenseCategoryDb expenseCategory) async {
    var dbClient = await db;
    expenseCategory.id =
        await dbClient.insert(TABLE_EXPENSE_CATEGORY, expenseCategory.toMap());
    return expenseCategory;
  }

  Future<List<ExpenseCategoryDb>> getExpenseCategory(UsersDb user) async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.rawQuery("SELECT * FROM $TABLE_EXPENSE_CATEGORY where $ID_USER=" +
            user.id.toString()+" or $ID_USER=0");
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
    return await dbClient.delete(TABLE_EXPENSE_CATEGORY,
        where: '$ID_EXPENSE_CATEGORY = ?', whereArgs: [id]);
  }

  Future<int> updateExpenseCategory(ExpenseCategoryDb expenseCategory) async {
    var dbClient = await db;
    return await dbClient.update(
        TABLE_EXPENSE_CATEGORY, expenseCategory.toMap(),
        where: '$ID_EXPENSE_CATEGORY = ?', whereArgs: [expenseCategory.id]);
  }

  Future<IncomeDb> saveIncome(IncomeDb incomeDb) async {
    var dbClient = await db;
    incomeDb.id = await dbClient.insert(TABLE_INCOME, incomeDb.toMap());
    incomeDb.account.balance += incomeDb.amount;
    updateAccount(incomeDb.account);
    return incomeDb;
  }

  Future<List<IncomeDb>> getIncome(UsersDb user) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_INCOME "
        "join $TABLE_ACCOUNT on $TABLE_INCOME.account = $TABLE_ACCOUNT.$ID_ACCOUNT where $TABLE_ACCOUNT.$ID_USER=" +
        user.id.toString());
    List<IncomeDb> incomeDb = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        incomeDb.add(IncomeDb.fromMap(maps[i]));
      }
    }
    return incomeDb;
  }

  Future<int> deleteIncome(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE_INCOME, where: '$ID_INCOME = ?', whereArgs: [id]);
  }

  Future<int> updateIncome(IncomeDb incomeDb) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_EXPENSE_CATEGORY, incomeDb.toMap(),
        where: '$ID_INCOME = ?', whereArgs: [incomeDb.id]);
  }

  Future<ExpensesDb> saveExpenses(ExpensesDb expensesDb) async {
    var dbClient = await db;
    expensesDb.id = await dbClient.insert(TABLE_EXPENSES, expensesDb.toMap());
    expensesDb.account.balance -= expensesDb.amount;
    updateAccount(expensesDb.account);
    return expensesDb;
  }

  Future<List<ExpensesDb>> getExpenses(UsersDb user) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_EXPENSES "
        "join $TABLE_ACCOUNT on $TABLE_EXPENSES.account = $TABLE_ACCOUNT.$ID_ACCOUNT where "
        "$TABLE_ACCOUNT.$ID_USER=" + user.id.toString());
    List<ExpensesDb> expensesDb = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        expensesDb.add(ExpensesDb.fromMap(maps[i]));
      }
    }
    return expensesDb;
  }

  Future<int> deleteExpenses(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE_EXPENSES, where: '$ID_EXPENSES = ?', whereArgs: [id]);
  }

  Future<int> updateExpenses(ExpensesDb expensesDb) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_EXPENSES, expensesDb.toMap(),
        where: '$ID_EXPENSES = ?', whereArgs: [expensesDb.id]);
  }

  Future<TransferDb> saveTransfer(TransferDb transferDb) async {
    var dbClient = await db;
    transferDb.id = await dbClient.insert(TABLE_TRANSFER, transferDb.toMap());
    AccountDb accFrom = transferDb.accountFrom;
    AccountDb accTo = transferDb.accountTo;
    accFrom.balance -= transferDb.amount;
    accTo.balance += transferDb.amount;
    updateAccount(accFrom);
    updateAccount(accTo);
    return transferDb;
  }

  Future<List<TransferDb>> getTransfer(UsersDb user) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT "
        "$TABLE_TRANSFER.id_transfer,"
        "$TABLE_TRANSFER.date,"
        "$TABLE_TRANSFER.amount, "
        "ac1.id_account as id_accountFrom,"
        "ac1.name as name_accountFrom,"
        "ac1.balance as balance_accountFrom,"
        "ac1.cartNum as cartNum_accountFrom,"
        "ac1.description as description_accountFrom,"
        "ac2.id_account as id_accountTo,"
        "ac2.name as name_accountTo,"
        "ac2.balance as balance_accountTo,"
        "ac2.cartNum as cartNum_accountTo,"
        "ac2.description as description_accountTO "
        "FROM $TABLE_TRANSFER "
        "join $TABLE_ACCOUNT ac1 on $TABLE_TRANSFER.$ACCOUNT_FROM  = ac1.$ID_ACCOUNT "
        "join $TABLE_ACCOUNT ac2 on $TABLE_TRANSFER.$ACCOUNT_TO  = ac2.$ID_ACCOUNT "
        "where ac1.$ID_USER=" +
        user.id.toString());
    List<TransferDb> transferDb = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        transferDb.add(TransferDb.fromMap(maps[i]));
      }
    }
    return transferDb;
  }

  Future<int> deleteTransfer(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE_TRANSFER, where: '$ID_TRANSFER = ?', whereArgs: [id]);
  }

  Future<int> updateTransfer(TransferDb transferDb) async {
    var dbClient = await db;
    return await dbClient.update(TABLE_TRANSFER, transferDb.toMap(),
        where: '$ID_TRANSFER = ?', whereArgs: [transferDb.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future<UsersDb> getUserByEmailAndPassword(
      String login, String password) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_USERS "
            "where $LOGIN=" +
        login +
        " and $PASSWORD=" +
        password);
    UsersDb user = new UsersDb(-1, "", "");
    if (maps.length > 0) {
      user = UsersDb.fromMap(maps[0]);
    }
    return user;
  }
}
