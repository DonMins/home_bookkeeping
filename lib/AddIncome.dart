import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_bookkeeping/IncomeCategory.dart';
import 'package:home_bookkeeping/db/AccountDb.dart';
import 'package:sqflite/sqflite.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import 'db/HelperDB.dart';
import 'db/IncomeCategoryDb.dart';
import 'db/IncomeDb.dart';

class AddIncome extends StatefulWidget {
  AddIncome(
      {Key key, this.title, this.isUpdating, this.curUserId, this.nameCategory})
      : super(key: key);

  final String title;
  final String nameCategory;
  final bool isUpdating;
  final int curUserId;

  @override
  State<StatefulWidget> createState() {
    return AddIncomeForm(title, isUpdating, curUserId, nameCategory);
  }
}

class AddIncomeForm extends State<AddIncome> {
  String title;

  AddIncomeForm(this.title, this.isUpdating, this.curUserId, this.nameCategory);

  Future<List<IncomeCategoryDb>> incomeCategoryDb;
  List<DropdownMenuItem<String>> listCategory;
  List<DropdownMenuItem<String>> listAccount;
  TextEditingController controller = TextEditingController();
  int curUserId;
  String account;
  int id;
  DateTime date;
  String nameCategory;
  double amount;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;
  String _myActivity;

  @override
  void initState() {
    super.initState();
    listCategory = [];
    listAccount = [];
    dbHelper = HelperDB();
    dbHelper.getIncomeCategory().then((row) {
      row.map((map) {
        return getDropDownWidgetCategory(map);
      }).forEach((dropDownItems) {
        listCategory.add(dropDownItems);
      });
      setState(() {});
    });

    dbHelper.getAccounts().then((row) {
      row.map((map) {
        return getDropDownWidgetAccounts(map);
      }).forEach((dropDownItems) {
        listAccount.add(dropDownItems);
      });
      setState(() {});
    });
  }

  DropdownMenuItem<String> getDropDownWidgetCategory(IncomeCategoryDb map) {
    return DropdownMenuItem<String>(
      value: map.nameCategory,
      child: Text(map.nameCategory),
    );
  }
  DropdownMenuItem<String> getDropDownWidgetAccounts(AccountDb map) {
    return DropdownMenuItem<String>(
      value: map.name,
      child: Text(map.name),
    );
  }


  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        IncomeDb e = IncomeDb(id, date, amount, account, nameCategory);
        dbHelper.updateIncome(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        IncomeDb e = IncomeDb(null, date, amount, account, nameCategory);
        dbHelper.saveIncome(e);
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
                      validator: (val) => val == null ? 'Выберите счет' : null,
                      decoration: InputDecoration( hintText: 'Занести на счет',
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
                      validator: (val) => val == null ? 'Выберите категорию' : null,
                      decoration: InputDecoration(
                        hintText: 'Категория дохода',
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
                          val.length == 0 ? 'Введите сумму дохода' : null,
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
