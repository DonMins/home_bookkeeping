import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_bookkeeping/AddExpenseCategory.dart';
import 'package:home_bookkeeping/db/Users.dart';
import 'db/ExpenseCategoryDb.dart';
import 'db/HelperDB.dart';

class ExpenseCategory extends StatefulWidget {
  ExpenseCategory({Key key, this.title,this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ExpenseCategoryForm(title,user);
  }
  final String title;
  final UsersDb user;

}

class ExpenseCategoryForm extends State<ExpenseCategory> {
  Future<List<ExpenseCategoryDb>> expenseCategoryDb;
  String nameCategory;
  String title;
  int accountId;
  UsersDb user;

  ExpenseCategoryForm(this.title,this.user);

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = HelperDB();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      expenseCategoryDb = dbHelper.getExpenseCategory(user);
    });
  }

  list() {
    return FutureBuilder<List<ExpenseCategoryDb>>(
        future: expenseCategoryDb,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                ExpenseCategoryDb item = snapshot.data[index];
                return ListTile(
                  title: Text(item.nameCategory),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      dbHelper.deleteExpenseCategory(item.id);
                      refreshList();
                    },
                  ),
                  onTap: () async {
                    Object refresh = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddExpenseCategory(
                                title: "Обновить категорию",
                                isUpdating: true,
                                accountId: item.id, nameCategory:item.nameCategory)));
                    if (refresh != null) refreshList();
                  },
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Comic',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.settings,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(Icons.more_vert),
              )),
        ],
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
              Color.fromRGBO(240, 183, 153, 1),
              Color.fromRGBO(59, 187, 203, 1)
            ]))),
      ),
      body: list(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          Object refresh = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddExpenseCategory(
                      title: "Добавить категорию", isUpdating: false,user:user)));
          if (refresh != null) refreshList();
        },
        child: new Icon(Icons.add),
      ),
    );
  }
}
