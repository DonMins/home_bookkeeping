import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_bookkeeping/db/Users.dart';

import 'db/ExpenseCategoryDb.dart';
import 'db/HelperDB.dart';

class AddExpenseCategory extends StatefulWidget {
  AddExpenseCategory(
      {Key key, this.title, this.isUpdating, this.accountId, this.nameCategory,this.user})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddExpenseCategoryDb(title, isUpdating, accountId, nameCategory,user);
  }

  final String title;
  final String nameCategory;
  final bool isUpdating;
  final int accountId;
  final UsersDb user;
}

class AddExpenseCategoryDb extends State<AddExpenseCategory> {
  String title;

  AddExpenseCategoryDb(
      this.title, this.isUpdating, this.accountId, this.nameCategory,this.user);

  Future<List<ExpenseCategoryDb>> expenseCategoryDb;
  int accountId;
  String nameCategory;
  UsersDb user;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = HelperDB();
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        ExpenseCategoryDb e = ExpenseCategoryDb(accountId, nameCategory,user);
        dbHelper.updateExpenseCategory(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        ExpenseCategoryDb e = ExpenseCategoryDb(null, nameCategory,user);
        dbHelper.saveExpenseCategory(e);
      }
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Form(
          key: formKey,
          child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    TextFormField(
                        controller: TextEditingController(
                            text: nameCategory == null ? "" : nameCategory),
                        keyboardType: TextInputType.text,
                        decoration:
                            InputDecoration(labelText: 'Название категории'),
                        validator: (val) => val.length == 0
                            ? 'Введите название категории'
                            : null,
                        onSaved: (val) => nameCategory = val),
                    RaisedButton.icon(
                      onPressed: validate,
                      color: Color.fromRGBO(59, 187, 203, 1),
                      textColor: Colors.white,
                      icon: Icon(Icons.save),
                      label: Text('Сохранить'),
                    ),
                  ]))),
    );
  }
}
