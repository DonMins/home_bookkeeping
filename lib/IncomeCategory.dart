import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AddIncomeCategory.dart';
import 'db/IncomeCategoryDb.dart';
import 'db/IncomeCategoryHelperDb.dart';

class IncomeCategory  extends StatefulWidget {
  IncomeCategory({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return IncomeCategoryForm(title);
  }
  final String title;
}

class IncomeCategoryForm extends State<IncomeCategory>{
  Future<List<IncomeCategoryDb>> incomeCategoryDb;
  TextEditingController controller = TextEditingController();
  String nameCategory;
  String title;
  int curUserId;

  IncomeCategoryForm(this.title);

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = IncomeCategoryHelperDb();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      incomeCategoryDb = dbHelper.getIncomeCategory();
    });
  }

  list() {
    return FutureBuilder<List<IncomeCategoryDb>>(
        future: incomeCategoryDb,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                IncomeCategoryDb item = snapshot.data[index];
                return ListTile(
                  title: Text(item.nameCategory),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      dbHelper.delete(item.id);
                      refreshList();
                    },
                  )
                );
              },
            );
          }

          else {
            return Center(child: CircularProgressIndicator());
          }
        }
      );
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
          onPressed: () {Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddIncomeCategory(title:"Добавить категорию") ));},
          child: new Icon(Icons.add),
        ),
    );
  }
}
