import 'dart:async';
import 'package:home_bookkeeping/db/HelperDB.dart';
import 'package:sqflite/sqflite.dart';

import 'db/HelperDB.dart';
import 'db/Users.dart';

abstract class BaseAuth {
  Future<int> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<UsersDb> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}
class Auth implements BaseAuth {
  HelperDB helper = new HelperDB();
  Future<int> signIn(String email, String password) async {
    Future<UsersDb> user = helper.getUserByEmailAndPassword(email, password);
    return 5;
  }

  Future<String> signUp(String email, String password) async {
    return " ";
  }

  Future<UsersDb> getCurrentUser() async {
    return new UsersDb(0, '0', '0');
  }

  Future<void> signOut() async {
    return " ";
  }

  Future<void> sendEmailVerification() async {
    return " ";
  }

  Future<bool> isEmailVerified() async {
    return true;
  }
}