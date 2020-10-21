import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_bookkeeping/IncomeCategory.dart';
import 'package:home_bookkeeping/db/ExpenseCategoryDb.dart';

import 'Accounts.dart';
import 'ExpenseCategory.dart';
import 'IncomeCategory.dart';

class StartPage extends StatelessWidget {
  StartPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title,
            style: TextStyle(
            fontFamily: 'Comic',
            fontWeight: FontWeight.bold,
          ),),
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
                      colors: <Color>[ Color.fromRGBO(240, 183, 153, 1),Color.fromRGBO(59, 187, 203, 1) ]))),
        ),
        body: Center(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [ Color.fromRGBO(240, 183, 153, 1),Color.fromRGBO(59, 187, 203, 1) ],
                )),
                child: ListView(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 10.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _getIconSurveys("icon/bank.png", 'Счета',context,(context) => Accounts(title:"Счета")),
                      _getIconSurveys("icon/income.png", 'Доходы',context,(context) => Accounts(title:"Доходы")),
                      _getIconSurveys("icon/spend.png", 'Расходы',context,(context) => Accounts(title:"Расходы")),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _getIconSurveys("icon/down.png", 'Категории\nрасходов',context,(context) => ExpenseCategory(title:"Категории расходов")),
                      _getIconSurveys("icon/up.png", 'Категории\nдоходов',context,(context) => IncomeCategory(title:"Категории доходов")),
                      _getIconSurveys("icon/xz.png", 'Что - то',context,(context) => {}),
                    ],
                  ),
                ]))));
  }
}


Widget _getIconSurveys(String imgPath, String name, BuildContext context,Function nextPage) {
  return Padding(
      padding: EdgeInsets.all(10.0),
      child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: nextPage ));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Hero(
                tag: imgPath,
                child: Image(
                  image: AssetImage(imgPath),
                  fit: BoxFit.cover,
                  height: 100.0,
                  width: 100.0,
                ),
              ),
              Center(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: 'Comic',

                    ),
                  )),
            ],
          )));
}
