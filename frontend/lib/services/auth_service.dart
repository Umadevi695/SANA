import 'dart:convert';

import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {

  static Future<Map<String, dynamic>> login(
  String email,
  String password,
) async {
  final response = await http.post(
    Uri.parse("${ApiService.baseUrl}/auth/login"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  final data = jsonDecode(response.body);

  print("LOGIN RESPONSE:");
  print(data);

  if (data["success"] == true) {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    await http.post(
      Uri.parse("${ApiService.baseUrl}/auth/save-fcm-token"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "userId": data["user"]["id"],
        "fcmToken": fcmToken,
      }),
    );

    print("FCM TOKEN SAVED");
  }

  return data;
}

static Future<Map<String, dynamic>> register(
  String name,
  String email,
  String password,
  String branch,
  String year,
) async {

  final response = await http.post(
    Uri.parse("${ApiService.baseUrl}/auth/register"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "name": name,
      "email": email,
      "password": password,
      "role": "student",
      "branch": branch,
      "year": year,
    }),
  );

  return jsonDecode(response.body);
}

}