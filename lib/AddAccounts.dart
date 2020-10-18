import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class AddAccounts extends StatelessWidget {
  AddAccounts({Key key, this.title}) : super(key: key);

  final String title;

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
      body: ListView(children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Название счета'),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Описание'),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(labelText: 'Номер карты'),
        ),
        TextFormField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            BlacklistingTextInputFormatter(new RegExp('[\\-|\\ ]'))
          ],
          decoration: InputDecoration(labelText: 'Баланс'),
        ),
        RaisedButton.icon(
          onPressed: () {},
          color:  Color.fromRGBO(59, 187, 203, 1),
          textColor: Colors.white,
          icon: Icon(Icons.save),
          label: Text('Сохранить'),
        ),
      ]),
    );
  }
}
