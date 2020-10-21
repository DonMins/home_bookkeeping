import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'Accounts.dart';
import 'db/AccountDB.dart';
import 'db/HelperDB.dart';

class AddAccounts extends StatefulWidget {
  AddAccounts({Key key, this.title}) : super(key: key);

  final String title;
  @override
  State<StatefulWidget> createState() {
    return _DBTestPageState();
  }
}




class _DBTestPageState extends State<AddAccounts> {
  Future<List<AccountDB>> employees;
  TextEditingController controller = TextEditingController();
  String name;
  int curUserId;
  double balance;
  String cartNum;
  String description;

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
      employees = dbHelper.getEmployees();
    });
  }

  clearName() {
    controller.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        AccountDB e = AccountDB(curUserId, name,balance,cartNum,description);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        AccountDB e = AccountDB(null, name,balance,cartNum,description);
        dbHelper.save(e);
      }
      Navigator.pop(context,1);
    }
  }

  form() {
    return Form(
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
              decoration: InputDecoration(labelText: 'Name'),
              validator: (val) => val.length == 0 ? 'Enter Name' : null,
              onSaved: (val) => name = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text('CANCEL'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return new Scaffold(
  //     appBar: new AppBar(
  //       title: new Text('Flutter SQLITE CRUD DEMO'),
  //     ),
  //     body: new Container(
  //       child: new Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         verticalDirection: VerticalDirection.down,
  //         children: <Widget>[
  //           form(),
  //           list(),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Счет",
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
        TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Название счета'),
          validator: (val) => val.length == 0 ? 'Введите название счета' : null,
          onSaved: (val) => name = val,
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Описание'),
          validator: (val) => val.length == 0 ? 'Введите описание' : null,
          onSaved: (val) => description = val,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(labelText: 'Номер карты'),
          validator: (val) => val.length == 0 ? 'Введите номер карты' : null,
          onSaved: (val) => cartNum = val,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]+([.][0-9]*)?|[.][0-9]+'))
          ],
          decoration: InputDecoration(labelText: 'Баланс'),
          validator: (val) => val.length == 0 ? 'Введите баланс' : null,
          onSaved: (val) => balance = double.parse(val),
        ),
        RaisedButton.icon(
          onPressed: validate,
          color:  Color.fromRGBO(59, 187, 203, 1),
          textColor: Colors.white,
          icon: Icon(Icons.save),
          label: Text('Сохранить'),
        ),
      ])),
    );
  }
}
