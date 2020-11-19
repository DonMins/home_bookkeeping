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
import 'dart:async';
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
  static const String TABLE_INCOME_CATEGORY = 'homebookkeepingcuba_IncomeCategoryTable';
  static const String TABLE_INCOME = 'homebookkeepingcuba_Income';
  static const String TABLE_TRANSFER = 'homebookkeepingcuba_Transfer';
  static const String TABLE_EXPENSES = 'homebookkeepingcuba_Expenses';
  static const String TABLE_USERS = 'homebookkeepingcuba_Users';
  static const String LOGIN = 'login';
  static const String PASSWORD = 'password';
  static const String TABLE_EXPENSE_CATEGORY = 'homebookkeepingcuba_ExpenseCategory ';
  static const String DB_NAME = 'home_bookkeeping2.db';
  static String TOKEN = '';

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

  Future<String> getToken() async {
    if (TOKEN.length == 0) {
      var response = await http
          .post('http://10.0.2.2:8080/app/rest/v2/oauth/token', headers: {
        "Authorization": "Basic Y2xpZW50OnNlY3JldA==",
        "Content-type": "application/x-www-form-urlencoded"
      }, body: {
        "grant_type": "password",
        "username": "admin",
        "password": "admin"
      }).timeout(const Duration(seconds: 3));
      TOKEN = jsonDecode(response.body)["access_token"];
      return TOKEN;
    } else {
      return TOKEN;
    }
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

    //
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_INCOME_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Зарплата',0);");
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_INCOME_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Пенсия',0);");
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_INCOME_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Лотерея',0);");
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_INCOME_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Подарок',0);");
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_INCOME_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Находка',0);");
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_INCOME_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Продажа',0);");

    // await db.rawInsert(
    //     "INSERT INTO $TABLE_ACCOUNT ($BALANCE,$CART_NUM,$DESCRIPTION, $NAME,$ID_USER) "
    //     "VALUES (40000,'56345634534634','Счет семьи', 'Общий счет',1);");
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_ACCOUNT ($BALANCE,$CART_NUM,$DESCRIPTION, $NAME,$ID_USER) "
    //     "VALUES (400000,'56232323423','Счет для накоплений', 'Накопительный',1);");

    // await db.rawInsert(
    //     "INSERT INTO $TABLE_EXPENSE_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Автомобиль',0);");
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_EXPENSE_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Дом',0);");
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_EXPENSE_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Одежда',0);");
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_EXPENSE_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Развлечения',0);");
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_EXPENSE_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Медицина',0);");
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_EXPENSE_CATEGORY ($NAME_CATEGORY,$ID_USER) VALUES ('Продукты питания',0);");
    //
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_USERS ($LOGIN,$PASSWORD) VALUES ('2','2');");
    // await db.rawInsert(
    //     "INSERT INTO $TABLE_USERS ($LOGIN,$PASSWORD) VALUES ('1','1');");
  }

  Future<AccountDb> saveAccount(AccountDb account) async {
    var dbClient = await db;
    account.id = await dbClient.insert(TABLE_ACCOUNT, account.toMap());
    return account;
  }

  void saveAccounts(List<AccountDb> accounts) async {
    accounts.forEach((element) {
      saveAccount(element);
    });
  }

  Future<List<AccountDb>> getAccounts(UsersDb user) async {
    List<AccountDb> accounts = [];
    var queryParameters = {
      "conditions": [
        {"property": "user.id", "operator": "=", "value": user.id},
      ]
    };
    var param = Uri.encodeComponent(jsonEncode(queryParameters));
    http.Response response;
    try {
      response = await http.get(
          'http://10.0.2.2:8080/app/rest/v2/entities/account_table1/search?view=acoountTable-view&filter=' +
              param,
          headers: {
            "Authorization": "Bearer " + await getToken()
          }).timeout(const Duration(seconds: 3));
    } on TimeoutException catch (e) {
      print('Timeout');
      var dbClient = await db;
      List<Map> maps = await dbClient.rawQuery(
          "SELECT * FROM $TABLE_ACCOUNT where $ID_USER=" + user.id.toString());

      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          accounts.add(AccountDb.fromMap(maps[i]));
        }
      }
      return accounts;
    } on Error catch (e) {
      print('Error: $e');
    }
    accounts = (json.decode(response.body) as List)
        .map((i) => AccountDb.fromJson(i))
        .toList();
    String data = response.body;
    saveAccounts(accounts);
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

  void saveIncomeCategories(List<IncomeCategoryDb> incomeCategoryDb) async {
    incomeCategoryDb.forEach((element) {
      saveIncomeCategory(element);
    });
  }

  Future<List<IncomeCategoryDb>> getIncomeCategory(UsersDb user) async {
    List<IncomeCategoryDb> incomeCategoryDb = [];
    var queryParameters = {
      "conditions": [
        {"property": "user.id", "operator": "=", "value": user.id},
      ]
    };
    var param = Uri.encodeComponent(jsonEncode(queryParameters));
    http.Response response;
    try {
      response = await http.get(
          'http://10.0.2.2:8080/app/rest/v2/entities/homebookkeepingcuba_IncomeCategoryTable/search?view=incomeCategoryTable-view&filter=' +
              param,
          headers: {
            "Authorization": "Bearer " + await getToken()
          }).timeout(const Duration(seconds: 3));
    } on TimeoutException catch (e) {
      print('Timeout');
      var dbClient = await db;
      List<Map> maps = await dbClient.rawQuery(
          "SELECT * FROM $TABLE_INCOME_CATEGORY where $ID_USER=" +
              user.id.toString() +
              " or $ID_USER=0");

      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          incomeCategoryDb.add(IncomeCategoryDb.fromMap(maps[i]));
        }
      }
      return incomeCategoryDb;
    } on Error catch (e) {
      print('Error: $e');
    }
    incomeCategoryDb = (json.decode(response.body) as List)
        .map((i) => IncomeCategoryDb.fromJson(i))
        .toList();
    String data = response.body;
    saveIncomeCategories(incomeCategoryDb);
    print("Слова с сервера" + data);
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

  void saveExpenseCategories(List<ExpenseCategoryDb> expenseCategoryDb) async {
    expenseCategoryDb.forEach((element) {
      saveExpenseCategory(element);
    });
  }

  Future<List<ExpenseCategoryDb>> getExpenseCategory(UsersDb user) async {
    List<ExpenseCategoryDb> expenseCategoryDb = [];
    var queryParameters = {
      "conditions": [
        {"property": "user.id", "operator": "=", "value": user.id},
      ]
    };
    var param = Uri.encodeComponent(jsonEncode(queryParameters));
    http.Response response;
    try {
      response = await http.get(
          'http://10.0.2.2:8080/app/rest/v2/entities/homebookkeepingcuba_ExpenseCategory/search?view=expenseCategory-view&filter=' +
              param,
          headers: {
            "Authorization": "Bearer " + await getToken()
          }).timeout(const Duration(seconds: 3));
    } on TimeoutException catch (e) {
      print('Timeout');
      var dbClient = await db;
      List<Map> maps = await dbClient.rawQuery(
          "SELECT * FROM $TABLE_EXPENSE_CATEGORY where $ID_USER=" +
              user.id.toString() +
              " or $ID_USER=0");
      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          expenseCategoryDb.add(ExpenseCategoryDb.fromMap(maps[i]));
        }
      }
      return expenseCategoryDb;
    } on Error catch (e) {
      print('Error: $e');
    }
    expenseCategoryDb = (json.decode(response.body) as List)
        .map((i) => ExpenseCategoryDb.fromJson(i))
        .toList();
    String data = response.body;
    saveExpenseCategories(expenseCategoryDb);
    print("Слова с сервера" + data);
    return expenseCategoryDb;
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

  void saveIncomes(List<IncomeDb> incomeDb) async {
    incomeDb.forEach((element) {saveIncome(element);});
  }

  Future<List<IncomeDb>> getIncome(UsersDb user) async {
    List<IncomeDb> incomeDb = [];

    var queryParameters = {
      "conditions": [
        {"property": "user.id", "operator": "=", "value": user.id},
      ]
    };
    var param = Uri.encodeComponent(jsonEncode(queryParameters));
    http.Response response;
    try {
      response = await http.get(
          'http://10.0.2.2:8080/app/rest/v2/entities/homebookkeepingcuba_Income/search?view=income-view&filter=' +
              param,
          headers: {
            "Authorization": "Bearer " + await getToken()
          }).timeout(const Duration(seconds: 3));
    } on TimeoutException catch (e) {
      print('Timeout');

      var dbClient = await db;
      List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_INCOME "
          "join $TABLE_ACCOUNT on $TABLE_INCOME.account = $TABLE_ACCOUNT.$ID_ACCOUNT where $TABLE_ACCOUNT.$ID_USER=" +
          user.id.toString());
      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          incomeDb.add(IncomeDb.fromMap(maps[i]));
        }
      }
      return incomeDb;

    } on Error catch (e) {
      print('Error: $e');
    }
    incomeDb = (json.decode(response.body) as List)
        .map((i) => IncomeDb.fromJson(i))
        .toList();
    String data = response.body;
    saveIncomes(incomeDb);
    print("Слова с сервера" + data);
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

  void saveExpensesss(List<ExpensesDb> expensesDb) async {
   expensesDb.forEach((element) {saveExpenses(element);});
  }

  Future<List<ExpensesDb>> getExpenses(UsersDb user) async {

    List<ExpensesDb> expensesDb = [];
    var queryParameters = {
      "conditions": [
        {"property": "user.id", "operator": "=", "value": user.id},
      ]
    };
    var param = Uri.encodeComponent(jsonEncode(queryParameters));
    http.Response response;
    try {
      response = await http.get(
          'http://10.0.2.2:8080/app/rest/v2/entities/homebookkeepingcuba_Expenses/search?view=expenses-view&filter=' +
              param,
          headers: {
            "Authorization": "Bearer " + await getToken()
          }).timeout(const Duration(seconds: 3));
    } on TimeoutException catch (e) {
      print('Timeout');
      var dbClient = await db;
      List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_EXPENSES "
          "join $TABLE_ACCOUNT on $TABLE_EXPENSES.account = $TABLE_ACCOUNT.$ID_ACCOUNT where "
          "$TABLE_ACCOUNT.$ID_USER=" +
          user.id.toString());
      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          expensesDb.add(ExpensesDb.fromMap(maps[i]));
        }
      }
      return expensesDb;
    } on Error catch (e) {
      print('Error: $e');
    }
    expensesDb = (json.decode(response.body) as List)
        .map((i) => ExpensesDb.fromJson(i))
        .toList();
    String data = response.body;
    saveExpensesss(expensesDb);
    print("Слова с сервера" + data);
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

  void saveTransfers(List<TransferDb> transferDb) async {
    transferDb.forEach((element) {saveTransfer(element);});
  }

  Future<List<TransferDb>> getTransfer(UsersDb user) async {
    List<TransferDb> transferDb = [];
    var queryParameters = {
      "conditions": [
        {"property": "user.id", "operator": "=", "value": user.id},
      ]
    };
    var param = Uri.encodeComponent(jsonEncode(queryParameters));
    http.Response response;
    try {
      response = await http.get(
          'http://10.0.2.2:8080/app/rest/v2/entities/homebookkeepingcuba_Transfer/search?view=transfer-view&filter=' +
              param,
          headers: {
            "Authorization": "Bearer " + await getToken()
          }).timeout(const Duration(seconds: 3));
    } on TimeoutException catch (e) {
      print('Timeout');
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
      if (maps.length > 0) {
        for (int i = 0; i < maps.length; i++) {
          transferDb.add(TransferDb.fromMap(maps[i]));
        }
      }
      return transferDb;
    } on Error catch (e) {
      print('Error: $e');
    }
    transferDb = (json.decode(response.body) as List)
        .map((i) => TransferDb.fromJson(i))
        .toList();
    String data = response.body;
    saveTransfers(transferDb);
    print("Слова с сервера" + data);
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

  Future<UsersDb> getUserByEmailAndPassword(String login,
      String password) async {
    UsersDb user;
    var queryParameters = {
      "conditions": [
        {"property": "login", "operator": "=", "value": login},
        {"property": "password", "operator": "=", "value": password},
      ]
    };
    var param = Uri.encodeComponent(jsonEncode(queryParameters));
    http.Response response;
    try {
      response = await http.get(
          'http://10.0.2.2:8080/app/rest/v2/entities/homebookkeepingcuba_Users/search?view=users-view&filter=' +
              param,
          headers: {
            "Authorization": "Bearer " + await getToken()
          }).timeout(const Duration(seconds: 3));
    } on TimeoutException catch (e) {
      print('Timeout');
      var dbClient = await db;
      List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE_USERS "
          "where $LOGIN=" +
          login +
          " and $PASSWORD=" +
          password);
      user = new UsersDb(-1, "", "");
      if (maps.length > 0) {
        user = UsersDb.fromMap(maps[0]);
      }
      return user;
    } on Error catch (e) {
      print('Error: $e');
    }

    List<UsersDb> users = (json.decode(response.body) as List)
        .map((i) => UsersDb.fromJson(i))
        .toList();
    String data = response.body;
    print("Слова с сервера" + data);
    return users.single;
  }
}
