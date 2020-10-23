import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';

import 'AddAccounts.dart';
import 'db/AccountDb.dart';
import 'db/HelperDB.dart';

class Accounts extends StatefulWidget {
  Accounts({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DBTestPageState();
  }

  final String title;
}

class _DBTestPageState extends State<Accounts> {
  Future<List<AccountDb>> accountDb;
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
      accountDb = dbHelper.getAccounts();
    });
  }

  prettify(str) {
    var arr = str.split(".");
    return StringUtils.reverse(StringUtils.addCharAtPosition(
            StringUtils.reverse(arr[0]), " ", 3,
            repeat: true)) +
        "." +
        arr[1];
  }

  list() {
    return FutureBuilder<List<AccountDb>>(
        future: accountDb,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                AccountDb item = snapshot.data[index];
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
                        Text(item.name),
                        Text(prettify(item.balance.toString()) + 'p',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ]),
                  subtitle: Text(item.description),
                  trailing: new PopupMenuButton(
                    itemBuilder: (_) => <PopupMenuItem<String>>[
                      new PopupMenuItem<String>(
                          child: const Text('Редактировать'), value: '0'),
                      new PopupMenuItem<String>(
                          child: const Text('Удалить'), value: '1'),
                    ],
                    onSelected: (val) async {
                      if (val == '0') {
                        Object refresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAccounts(
                                    title: "Обновить счёт",
                                    isUpdating: true,
                                    curUserId: item.id,
                                    balance:item.balance,
                                    description:item.description,
                                    name:item.name,
                                    cartNum:item.cartNum)));
                        if (refresh != null) refreshList();
                      }
                      if (val == '1') {
                        dbHelper.deleteAccount(item.id);
                        refreshList();
                      }
                    },
                  ),

                  // trailing: IconButton(
                  //   icon: Icon(Icons.delete),
                  //   onPressed: () {
                  //     dbHelper.deleteAccount(item.id);
                  //     refreshList();
                  //     },
                  // ),
                  onTap: () async {
                    // Object refresh = await Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AddAccounts(
                    //             title: "Обновить счёт",
                    //             isUpdating: true,
                    //             curUserId: item.id)));
                    // if (refresh != null) refreshList();
                  },
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Счета",
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
                  builder: (context) => AddAccounts(title: "Cчета",isUpdating: false,)));
          if (refresh != null) refreshList();
        },
        child: new Icon(Icons.add),
      ),
    );
  }
}
