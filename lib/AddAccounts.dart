import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_bookkeeping/db/Users.dart';
import 'db/AccountDb.dart';
import 'db/HelperDB.dart';

class AddAccounts extends StatefulWidget {
  AddAccounts(
      {Key key,
      this.title,
      this.isUpdating,
      this.accountId,
      this.balance,
      this.description,
      this.name,
      this.cartNum,
      this.user })
      : super(key: key);

  final String title;
  String name;
  int accountId;
  double balance;
  String cartNum;
  String description;
  bool isUpdating;
  UsersDb user ;

  @override
  State<StatefulWidget> createState() {
    return AccountsForm(title, name, accountId, balance, cartNum, description,
        isUpdating, user);
  }
}

class AccountsForm extends State<AddAccounts> {
  Future<List<AccountDb>> accountDb;
  String name;
  int accountId;
  double balance;
  String cartNum;
  String description;
  UsersDb user;
  final String title;

  AccountsForm(this.title, this.name, this.accountId, this.balance,
      this.cartNum, this.description, this.isUpdating, this.user);

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = HelperDB();
    refreshList();
  }

  refreshList() {
    setState(() {
      accountDb = dbHelper.getAccounts(user);
    });
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        AccountDb e =
            AccountDb(accountId, name, balance, cartNum, description, user);
        dbHelper.updateAccount(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        AccountDb e =
            AccountDb(null, name, balance, cartNum, description, user);
        dbHelper.saveAccount(e);
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                TextFormField(
                  controller:
                      TextEditingController(text: name == null ? "" : name),
                  decoration: InputDecoration(labelText: 'Название счета'),
                  validator: (val) =>
                      val.length == 0 ? 'Введите название счета' : null,
                  onSaved: (val) => name = val,
                ),
                TextFormField(
                  controller: TextEditingController(
                      text: description == null ? "" : description),
                  decoration: InputDecoration(labelText: 'Описание'),
                  validator: (val) =>
                      val.length == 0 ? 'Введите описание' : null,
                  onSaved: (val) => description = val,
                ),
                TextFormField(
                  controller: TextEditingController(
                      text: cartNum == null ? "" : cartNum),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(labelText: 'Номер карты'),
                  validator: (val) =>
                      val.length == 0 ? 'Введите номер карты' : null,
                  onSaved: (val) => cartNum = val,
                ),
                TextFormField(
                  controller: TextEditingController(
                      text: balance == null ? "" : balance.toString()),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+([.][0-9]*)?|[.][0-9]+'))
                  ],
                  decoration: InputDecoration(labelText: 'Баланс'),
                  validator: (val) => val.length == 0 ? 'Введите баланс' : null,
                  onSaved: (val) => balance = double.parse(val),
                ),
                RaisedButton.icon(
                  onPressed: validate,
                  color: Color.fromRGBO(59, 187, 203, 1),
                  textColor: Colors.white,
                  icon: Icon(Icons.save),
                  label: Text('Сохранить'),
                ),
              ])),
    );
  }
}
