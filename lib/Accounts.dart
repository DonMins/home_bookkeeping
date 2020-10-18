import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_bookkeeping/db/HelperDB.dart';

import 'AddAccounts.dart';
import 'db/AccountDB.dart';

class Accounts  extends StatefulWidget {
  Accounts({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DBTestPageState();
  }

  final String title;
}
  class _DBTestPageState extends State<Accounts>{
  Future<List<AccountDB>> employees;
  TextEditingController controller = TextEditingController();
  String name;
  int curUserId;

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
        AccountDB e = AccountDB(curUserId, name);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        AccountDB e = AccountDB(null, name);
        dbHelper.save(e);
      }
      clearName();
      refreshList();
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

  SingleChildScrollView dataTable(List<AccountDB> employees) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('NAME'),
          ),
          DataColumn(
            label: Text('DELETE'),
          )
        ],
        rows: employees
            .map(
              (employee) => DataRow(cells: [
            DataCell(
              Text(employee.name),
              onTap: () {
                setState(() {
                  isUpdating = true;
                  curUserId = employee.id;
                });
                controller.text = employee.name;
              },
            ),
            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                dbHelper.delete(employee.id);
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter SQLITE CRUD DEMO'),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(
  //         "Счет",
  //         style: TextStyle(
  //           fontFamily: 'Comic',
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       actions: <Widget>[
  //         Padding(
  //             padding: EdgeInsets.only(right: 20.0),
  //             child: GestureDetector(
  //               onTap: () {},
  //               child: Icon(
  //                 Icons.settings,
  //                 size: 26.0,
  //               ),
  //             )),
  //         Padding(
  //             padding: EdgeInsets.only(right: 20.0),
  //             child: GestureDetector(
  //               onTap: () {},
  //               child: Icon(Icons.more_vert),
  //             )),
  //       ],
  //       flexibleSpace: Container(
  //           decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                   begin: Alignment.topCenter,
  //                   end: Alignment.bottomCenter,
  //                   colors: <Color>[
  //             Color.fromRGBO(240, 183, 153, 1),
  //             Color.fromRGBO(59, 187, 203, 1)
  //           ]))),
  //     ),
  //     floatingActionButton: new FloatingActionButton(
  //       onPressed: () {Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => AddAccounts(title:"Cчет") ));},
  //       child: new Icon(Icons.add),
  //     ),
  //   );
  // }
}
