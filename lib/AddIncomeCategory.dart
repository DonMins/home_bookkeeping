import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_bookkeeping/IncomeCategory.dart';
import 'package:sqflite/sqflite.dart';

import 'db/IncomeCategoryDb.dart';
import 'db/IncomeCategoryHelperDb.dart';

class AddIncomeCategory extends StatefulWidget {
  AddIncomeCategory({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return AddIncomeCategoryDb(title);
  }
}

class AddIncomeCategoryDb extends State<AddIncomeCategory> {
  String title;

  AddIncomeCategoryDb(this.title);

  Future<List<IncomeCategoryDb>> incomeCategoryDb;
  TextEditingController controller = TextEditingController();
  int curUserId;
  String nameCategory;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = IncomeCategoryHelperDb();
    isUpdating = false;
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        IncomeCategoryDb e = IncomeCategoryDb(curUserId, nameCategory);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        IncomeCategoryDb e = IncomeCategoryDb(null, nameCategory);
        dbHelper.save(e);
      }
      Navigator.pop(context, 1);
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
                        controller: controller,
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
