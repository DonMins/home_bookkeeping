import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_bookkeeping/db/Users.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'AddIncome.dart';
import 'db/HelperDB.dart';
import 'db/IncomeDb.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:intl/intl.dart';
class Income extends StatefulWidget {
  Income({Key key, this.title,this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return IncomeForm(title,user);
  }
  final String title;
  final UsersDb user;
}

class IncomeForm extends State<Income> {
  Future<List<IncomeDb>> incomeDb;
  String nameCategory;
  String title;
  int accountId;
  UsersDb user;

  IncomeForm(this.title,this.user);

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
  prettify(str) {
    var arr = str.split(".");
    return StringUtils.reverse(StringUtils.addCharAtPosition(
        StringUtils.reverse(arr[0]), " ", 3,
        repeat: true)) +
        "." +
        arr[1];
  }
  refreshList() {
    setState(() {
      incomeDb = dbHelper.getIncome(user);
    });
  }

  list() {
    return FutureBuilder<List<IncomeDb>>(
        future: incomeDb,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                IncomeDb item = snapshot.data[index];
                return Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.red,
                        size: 50,
                      ),
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                        Text(item.account == null ? "" : item.account.name),
                        Text(prettify(item.amount.toString()) + 'p',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ]),
                      subtitle: Text(item.nameCategory == null ? "" : item.nameCategory
                          + (item.date == null ? "" : "\n"+DateFormat('dd.MM.yyy в kk:mm').format(DateTime.parse(item.date)).toString())),
                      trailing: new PopupMenuButton(
                        itemBuilder: (_) => <PopupMenuItem<String>>[
                          new PopupMenuItem<String>(
                              child: const Text('Редактировать'), value: '0'),
                          new PopupMenuItem<String>(
                              child: const Text('Удалить'), value: '1'),

                        ],
                        onSelected: (val) async {
                          if (val =='0'){
                            Alert(
                              context: context,
                              title: "Важно!",
                              desc: "Лень было делать, но это не сложно ;)",
                            ).show();
                          }
                          if (val == '1') {
                            dbHelper.deleteIncome(item.id);
                            refreshList();
                          }
                        },
                      ),
                    ));
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
                  builder: (context) => AddIncome(
                      title: "Добавить доход", isUpdating: false,user:user)));
          if (refresh != null) refreshList();
        },
        child: new Icon(Icons.add),
      ),
    );
  }
}
