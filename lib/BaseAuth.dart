import 'dart:async';
import 'package:home_bookkeeping/db/HelperDB.dart';
import 'package:sqflite/sqflite.dart';

import 'db/HelperDB.dart';
import 'db/Users.dart';

abstract class BaseAuth {
  Future<int> signIn(String email, String password);

  Future<UsersDb> getCurrentUser();
}
class Auth implements BaseAuth {
  HelperDB helper = new HelperDB();
  Future<UsersDb> currentUser;

  Future<int> signIn(String email, String password) async {
    Future<UsersDb> user = helper.getUserByEmailAndPassword(email, password);
    this.currentUser = user;
    return user.then((value) => value.id);
  }

  Future<UsersDb> getCurrentUser() async {
    return this.currentUser;
  }
}
