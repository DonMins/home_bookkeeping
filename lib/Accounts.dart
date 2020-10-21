import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddAccounts.dart';
import 'db/AccountDB.dart';
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
      employees = dbHelper.getAccounts();
    });
  }

  SingleChildScrollView dataTable(List<AccountDB> accounts) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('NAME'),
          ),
          // DataColumn(
          //   label: Text('cartNum'),
          // ),
          DataColumn(
            label: Text('description'),
          ),
          DataColumn(
            label: Text('balance'),
          ),
          DataColumn(
            label: Text('DELETE'),
          )
        ],
        rows: accounts
            .map(
              (account) => DataRow(cells: [
                DataCell(
                  Text(account.name),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = account.id;
                    });
                    controller.text = account.name;
                  },
                ),
            // DataCell(
            //   Text(employee.cartNum),
            //   onTap: () {
            //     setState(() {
            //       isUpdating = true;
            //       curUserId = employee.id;
            //     });
            //     controller.text = employee.cartNum;
            //   },
            // ),
                DataCell(
                  Text(account.description),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = account.id;
                    });
                    controller.text = account.description;
                  },
                ),
                DataCell(
                  Text(account.balance.toString()),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = account.id;
                    });
                    controller.text = account.balance.toString();
                  },
                ),

            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                dbHelper.deleteAccount(account.id);
                refreshList();
              },
            )),
          ]),
        )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: employees,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }

          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
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
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            list(),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          Object refresh = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddAccounts(title: "Cчет")));
          if (refresh != null) refreshList();
        },
        child: new Icon(Icons.add),
      ),
    );
  }
}
