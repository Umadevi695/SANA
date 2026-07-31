import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/notice_model.dart';
import '../services/api_service.dart';
import '../services/user_session.dart';

class NoticeService {
  static Future<List<NoticeModel>> getStudentNotices() async {
    final response = await http.get(
      Uri.parse("${ApiService.baseUrl}/notices/student/notices"),
      headers: {
        "Authorization": "Bearer ${UserSession.token}",
      },
    );

    final data = jsonDecode(response.body);

    print("NOTICE RESPONSE:");
    print(data);

    if (data["success"] != true) {
      return [];
    }

    final List notices = data["notices"];

    return notices.map((notice) {
      return NoticeModel(
        id: notice["id"] ?? "",
        title: notice["title"] ?? "No Title",
        description: notice["summary"] ?? "",
        category: notice["category"] ?? "Other",
        date: notice["deadline"] ?? "",
        attachmentName: notice["fileName"] ?? "No attachment",
        filePath: notice["filePath"] ?? "",
        isApproved: true,
        
      );
    }).toList();
  }
}