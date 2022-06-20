import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kursova/models/announcement.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static final _dio = Dio();

  static final Api _singleton = Api._internal();

  factory Api() {
    _dio.options.baseUrl = "http://localhost:5000/";
    _dio.options.connectTimeout = 5000; //5s
    _dio.options.receiveTimeout = 5000;
    _loadTokenFromPersistence().then(
        (value) => _dio.options.headers["Authorization"] = "Bearer $value");
    return _singleton;
  }

  Api._internal();

  Future<dynamic> register({
    required String username,
    required String password,
    required String firstname,
    required String lastname,
    required String email,
    required String phone,
    required String city,
  }) async {
    try {
      final response = await _dio.post('user', data: {
        "username": username,
        "password": password,
        "firstName": firstname,
        "lastName": lastname,
        "email": email,
        "phone": phone,
        "city": city,
      });

      if (response.statusCode == HttpStatus.ok) {
        // await _onLoginSuccess(response.data["access_token"]);

        return response.data;
      } else {
        return response.statusMessage;
      }
    } on DioError catch (e) {
      return e;
    }
  }

  Future<dynamic> updateUser({
    String? username,
    String? password,
    String? firstname,
    String? lastname,
    String? email,
    String? phone,
    String? city,
  }) async {
    final data = {
      "username": username,
      "password": password,
      "firstName": firstname,
      "lastName": lastname,
      "email": email,
      "phone": phone,
      "city": city,
    };
    data.removeWhere((key, value) => value == null || value.isEmpty);
    try {
      final response = await _dio.put('user', data: data);

      if (response.statusCode == HttpStatus.ok) {
        // await _onLoginSuccess(response.data["access_token"]);

        return response.data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      return e;
    }
  }

  /// Returns non-null string on error
  Future<dynamic> login(
      {required String username, required String password}) async {
    try {
      final response = await _dio.post('login', data: {
        "username": username,
        "password": password,
      });

      if (response.statusCode == HttpStatus.ok) {
        await _onLoginSuccess(response.data["access_token"]);
        return response.data["access_token"];
      } else {
        return response.statusMessage;
      }
    } on DioError catch (e) {
      return e;
    }
  }

  Future<String?> addAnnouncement(Announcement announcement) async {
    try {
      final response = await _dio.post('announcement', data: {
        'tittle': announcement.tittle,
        'content': announcement.content,
        'isLocal': announcement.isLocal
      });
      if (response.statusCode != 200) {
        return 'Error';
      }
    } on DioError catch (e) {
      log(e.message);
      return 'Error';
    }
  }

  Future<String?> editAnnouncement(Announcement announcement) async {
    try {
      final response = await _dio.put('announcement/${announcement.id}', data: {
        'tittle': announcement.tittle,
        'content': announcement.content,
        // 'isLocal': announcement.isLocal
      });
      if (response.statusCode != 200) {
        return 'Error';
      }
    } on DioError catch (e) {
      log(e.message);
      return 'Error';
    }
  }

  Future<String?> deleteAnnouncement(int id) async {
    try {
      final response = await _dio.delete('announcement/${id}');
      if (response.statusCode != 200) {
        return 'Error';
      }
    } on DioError catch (e) {
      log(e.message);
      return 'Error';
    }
  }

  Future<List<Announcement>> getAnnouncements() async {
    try {
      final response = await _dio.get('announcement');
      final result = <Announcement>[];
      for (final ann in response.data["announcement_list"] as List<dynamic>) {
        print(ann as Map<String, dynamic>);
        result.add(Announcement.fromJson(ann));
      }
      return result;
    } on DioError catch (e) {
      log(e.message);
      return [];
      // return e.message;
    }
  }

  Future<List<Announcement>> getLocalAnnouncements() async {
    try {
      final response = await _dio.get('announcement/local');
      final result = <Announcement>[];
      for (final ann in response.data["announcement_list"] as List<dynamic>) {
        print(ann as Map<String, dynamic>);
        result.add(Announcement.fromJson(ann));
      }
      return result;
    } on DioError catch (e) {
      log(e.message);
      return [];
      // return e.message;
    }
  }

  static Future<String?> _loadTokenFromPersistence() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    return accessToken;
  }

  _onLoginSuccess(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', accessToken);
    _dio.options.headers["Authorization"] = "Bearer $accessToken";
  }
}
