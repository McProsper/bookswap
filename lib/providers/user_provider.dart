import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:second_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _token;
  String? _fcmToken;

  Map<String, dynamic>? get user => _user;
  String? get token => _token;

  Future<void> setUser(Map<String, dynamic> user, String token) async {
    _user = user;
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(user));

    // Save FCM token
    _fcmToken = await FirebaseMessaging.instance.getToken();
    if (_fcmToken != null) {
      await ApiService().saveFcmToken(_fcmToken!);
      await prefs.setString('fcmToken', _fcmToken!);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _fcmToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.remove('fcmToken');
    notifyListeners();
  }

  Future<bool> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userJson = prefs.getString('user');
    final fcmToken = prefs.getString('fcmToken');
    if (token != null && userJson != null) {
      _token = token;
      _user = jsonDecode(userJson);
      _fcmToken = fcmToken;
      notifyListeners();
      return true;
    }
    return false;
  }
}