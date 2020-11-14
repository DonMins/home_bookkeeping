import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_bookkeeping/Income.dart';
import 'package:home_bookkeeping/IncomeCategory.dart';
import 'package:home_bookkeeping/Transfer.dart';
import 'package:home_bookkeeping/db/Users.dart';

import 'Accounts.dart';
import 'BaseAuth.dart';
import 'ExpenseCategory.dart';
import 'Expenses.dart';
import 'IncomeCategory.dart';
import 'RootPage.dart';
import 'login.dart';

class StartPage extends StatelessWidget {
  StartPage({Key key, this.title, this.user}) : super(key: key);

  final String title;
  final UsersDb user;

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
                padding: EdgeInsets.only(top: 18, right: 20.0),
                child: Text(user.login,
                    style: TextStyle(
                      fontFamily: 'Comic',
                      fontWeight: FontWeight.bold,
                    ))),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (c) => new RootPage(auth: new Auth())),
                        (r) => false);
                  },
                  child: Icon(Icons.exit_to_app),
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
        body: Center(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromRGBO(240, 183, 153, 1),
                    Color.fromRGBO(59, 187, 203, 1)
                  ],
                )),
                child: ListView(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 10.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _getIconSurveys("icon/bank.png", 'Счета', context,
                          (context) => Accounts(title: "Счета",user:user)),
                      _getIconSurveys("icon/income.png", 'Доходы', context,
                          (context) => Income(title: "Доходы",user:user)),
                      _getIconSurveys("icon/spend.png", 'Расходы', context,
                          (context) => Expenses(title: "Расходы",user:user)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _getIconSurveys(
                          "icon/down.png",
                          'Категории\nрасходов',
                          context,
                          (context) =>
                              ExpenseCategory(title: "Категории расходов",user:user)),
                      _getIconSurveys(
                          "icon/up.png",
                          'Категории\nдоходов',
                          context,
                          (context) =>
                              IncomeCategory(title: "Категории доходов",user:user)),
                      _getIconSurveys("icon/transfer.png", 'Переводы', context,
                          (context) => Transfer(title: "Переводы",user:user)),
                    ],
                  ),
                ]))));
  }
}

Widget _getIconSurveys(
    String imgPath, String name, BuildContext context, Function nextPage) {
  return Padding(
      padding: EdgeInsets.all(10.0),
      child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: nextPage));
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
