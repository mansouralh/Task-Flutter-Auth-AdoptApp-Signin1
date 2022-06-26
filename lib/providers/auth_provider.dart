import 'dart:io';

import 'package:adopt_app/models/user.dart';
import 'package:adopt_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adopt_app/services/client.dart';

class AuthProvider extends ChangeNotifier {
  late String token = "";
  late User user;

  void signup({required User user}) async {
    token = await AuthServices().signup(user: user);
    setToken(token);
    notifyListeners();
  }

  void signin({required User user}) async {
    token = await AuthServices().signin(user: user);
    setToken(token);
    notifyListeners();
  }

  void setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    notifyListeners();
  }

  // bool get isAuth {
  //   if (token.isNotEmpty &&
  //       // Jwt.isExpired(token))
  //       Jwt.getExpiryDate(token)!.isAfter(DateTime.now())) {
  //     // var json = Jwt.parseJwt(token);
  //     // user = User.fromJson(json);
  //     user = User.fromJson(Jwt.parseJwt(token));
  //     return true;
  //   } else
  //     return false;
  // }

  bool get isAuth {
    getToken();
    if (token.isNotEmpty && Jwt.getExpiryDate(token)!.isAfter(DateTime.now())) {
      user = User.fromJson(Jwt.parseJwt(token));
      client.dio.options.headers = {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      };
      return true;
    }
    logout();
    return false;
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    token = "";
    notifyListeners();
  }
}
