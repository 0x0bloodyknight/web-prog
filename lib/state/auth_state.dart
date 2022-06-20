import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kursova/repository/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends ChangeNotifier {
  String? currentUsername;
  bool? _loggedIn;
  bool _loggingIn = false;

  final _repository = Api();

  bool? get loggedIn => _loggedIn;
  bool get loggingIn => _loggingIn;

  AuthState() {
    SharedPreferences.getInstance().then((prefs) {
      final token = prefs.getString('access_token');
      log(token ?? 'no token');
      if (token != null) {
        _loggedIn = true;
        currentUsername = JwtDecoder.decode(token)['sub'];
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<String?> register(
      {required String username,
      required String password,
      required String firstname,
      required String lastname,
      required String email,
      required String city,
      required String phone}) async {
    if (username.isEmpty || password.isEmpty) return null;
    // _loggingIn = true;
    // notifyListeners();
    final res = await _repository.register(
        username: username,
        password: password,
        firstname: firstname,
        lastname: lastname,
        email: email,
        city: city,
        phone: phone);

    if (res != null) {
      try {
        // currentUsername = JwtDecoder.decode(res as String)['sub'];
        // _loggedIn = true;
      } catch (_) {}
    }
    // _loggingIn = false;
    // notifyListeners();
    return res;
  }

  Future<String?> updateUser(
      {String? username,
      String? password,
      String? firstname,
      String? lastname,
      String? email,
      String? city,
      String? phone}) async {
    final res = await _repository.updateUser(
        username: username,
        password: password,
        firstname: firstname,
        lastname: lastname,
        email: email,
        city: city,
        phone: phone);

    if (res != null) {
      try {
        username != null && username.isNotEmpty
            ? currentUsername = username
            : null;
        notifyListeners();
        // currentUsername = ;
        // _loggedIn = true;
      } catch (_) {}
    }
    // _loggingIn = false;
    // notifyListeners();
    return res;
  }

  /// Returns null on success
  Future<String?> login(
      {required String username, required String password}) async {
    if (username.isEmpty || password.isEmpty) return null;
    _loggingIn = true;
    notifyListeners();
    final res = await _repository.login(username: username, password: password);

    if (res != null) {
      try {
        currentUsername = JwtDecoder.decode(res as String)['sub'];
        _loggedIn = true;
      } catch (_) {}
    }
    _loggingIn = false;
    notifyListeners();
    return res;
  }

  void logout() {
    _loggedIn = false;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.remove('access_token'));
    notifyListeners();
  }
}
