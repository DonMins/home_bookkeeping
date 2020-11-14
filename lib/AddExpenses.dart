import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_bookkeeping/db/AccountDb.dart';
import 'package:home_bookkeeping/db/ExpenseCategoryDb.dart';
import 'package:home_bookkeeping/db/ExpensesDb.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:home_bookkeeping/db/Users.dart';
import 'package:intl/intl.dart';

import 'db/HelperDB.dart';


class AddExpenses extends StatefulWidget {
  AddExpenses(
      {Key key, this.title, this.isUpdating, this.accountId, this.nameCategory,this.user})
      : super(key: key);

  final String title;
  final String nameCategory;
  final bool isUpdating;
  final int accountId;
  final UsersDb user;

  @override
  State<StatefulWidget> createState() {
    return AddExpensesForm(title, isUpdating, accountId, nameCategory,user);
  }
}

class AddExpensesForm extends State<AddExpenses> {
  String title;
  AddExpensesForm(this.title, this.isUpdating, this.accountId, this.nameCategory,this.user);
  Future<List<ExpenseCategoryDb>> expensesCategoryDb;
  List<DropdownMenuItem<String>> listCategory;
  List<DropdownMenuItem> listAccount;
  int accountId;
  AccountDb account;
  UsersDb user;
  int id;
  String date;
  String nameCategory;
  double amount;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    listCategory = [];
    listAccount = [];
    dbHelper = HelperDB();
    dbHelper.getExpenseCategory(user).then((row) {
      row.map((map) {
        return getDropDownWidgetCategory(map);
      }).forEach((dropDownItems) {
        listCategory.add(dropDownItems);
      });
      setState(() {});
    });

    dbHelper.getAccounts(user).then((row) {
      row.map((map) {
        return getDropDownWidgetAccounts(map);
      }).forEach((dropDownItems) {
        listAccount.add(dropDownItems);
      });
      setState(() {});
    });
  }

  DropdownMenuItem<String> getDropDownWidgetCategory(ExpenseCategoryDb map) {
    return DropdownMenuItem<String>(
      value: map.nameCategory,
      child: Text(map.nameCategory),
    );
  }
  DropdownMenuItem getDropDownWidgetAccounts(AccountDb map) {
    return DropdownMenuItem(
      value: map,
      child: Text(map.name),
    );
  }


  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        ExpensesDb e = ExpensesDb(id, date, amount, account, nameCategory,user);
        dbHelper.updateExpenses(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        ExpensesDb e = ExpensesDb(null, date, amount, account, nameCategory,user);
        dbHelper.saveExpenses(e);
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
                    DateTimeField(
                      format: DateFormat("yyyy-MM-dd HH:mm"),
                      initialValue: DateTime.now(),
                      onSaved: (val) => date = val.toIso8601String(),
                      validator: (val) => val == null ? 'Заполните дату' : null,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                    ),
                    DropdownButtonFormField(
                      // value: listCategory.length == 0 ? "" : listCategory[0].value,
                      onChanged: (value) {},
                      onSaved: (val) => account = val,
                      validator: (val) => val == null ? 'Выберите счет' : null,
                      decoration: InputDecoration( hintText: 'Снять со счета',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            formKey.currentState.reset();
                          },
                        ),
                      ),
                      items: listAccount,
                    ),
                    DropdownButtonFormField(
                      // value: listCategory.length == 0 ? "" : listCategory[0].value,
                      onChanged: (value) {},
                      onSaved: (val) => nameCategory = val,
                      validator: (val) => val == null ? 'Выберите категорию' : null,
                      decoration: InputDecoration(
                        hintText: 'Категория расхода',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            formKey.currentState.reset();
                          },
                        ),
                      ),
                      items: listCategory,
                    ),
                    TextFormField(
                      controller: TextEditingController(
                          text: amount == null ? "" : amount.toString()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]+([.][0-9]*)?|[.][0-9]+'))
                      ],
                      decoration: InputDecoration(labelText: 'Сумма'),
                      validator: (val) =>
                      val.length == 0 ? 'Введите сумму расхода' : null,
                      onSaved: (val) => amount = double.parse(val),
                    ),
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
