import 'package:flutter/material.dart';
import 'package:home_bookkeeping/db/Users.dart';

import 'BaseAuth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  String _email;
  String _password;

  @override
  State<StatefulWidget> createState() =>
      new _LoginSignupPageState(_email, _password);
}

class _LoginSignupPageState extends State<LoginPage>{
  final _formKey = new GlobalKey<FormState>();
  bool _isLoading = false;
  String _email;
  String _password;
  String _errorMessage = "";
  _LoginSignupPageState(this._email, this._password);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Авторизация'),
        ),
        body: Stack(
          children: <Widget>[
            showForm(),
            showCircularProgress(),
          ],
        ));
  }

  validate() async {

    setState(() {
      _errorMessage = "";
    });

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      int userId = 0;
      try {
        userId = await widget.auth.signIn(_email, _password);
        print('Signed in: $userId');

        if (userId!=-1 && userId != null) {
          widget.loginCallback();
        } else{
          _errorMessage = "Неверный логин или пароль";
          _formKey.currentState.reset();
        }

      } catch (e) {
        print('Error: $e');
        _errorMessage = "Неверный логин или пароль";
        _formKey.currentState.reset();
      }
    }
  }

  Widget showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }


  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Login',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Login can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Войти',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validate,
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0) {
      return new Text(
        _errorMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 15.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.bold),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Text('Введите логин и пароль',
            style: TextStyle(
              fontSize: 40.0,
              color: Colors.black,
              height: 1.0,
              fontWeight: FontWeight.w300),
          ),
        ),
      ),
    );
  }

}
