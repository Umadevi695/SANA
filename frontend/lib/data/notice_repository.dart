import '../services/notice_service.dart';
import 'package:flutter/material.dart';
import '../models/notice_model.dart';
import 'notification_repository.dart';

class NoticeRepository {
  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);

  static List<NoticeModel> pendingNotices = [
    NoticeModel(
      id: '1',
      title: 'Mid Semester Exam Timetable',
      description: 'Exam schedule for all CSE students.',
      category: 'Exam',
      date: '08 Jun 2026',
      attachmentName: 'mid_sem_exam_timetable.pdf',
      filePath: "",
    ),
    NoticeModel(
      id: '2',
      title: 'AI Workshop Registration',
      description: 'Register before deadline.',
      category: 'Event',
      date: '12 Jun 2026',
      attachmentName: 'ai_workshop_registration.pdf',
      filePath: "",
    ),
  ];

  static List<NoticeModel> approvedNotices = [];

  static List<NoticeModel> get downloadedNotices {
    return approvedNotices
        .where((notice) => notice.isDownloaded)
        .toList()
        .reversed
        .toList();
  }

  static int get unreadCount {
    return approvedNotices.where((notice) => !notice.isRead).length;
  }

  static void _refresh() {
    notifier.value++;
  }

  static void addNotice(NoticeModel notice) {
    pendingNotices.add(notice);
    _refresh();
  }

  static void approveNotice(NoticeModel notice) {
    pendingNotices.removeWhere((item) => item.id == notice.id);

    final alreadyApproved = approvedNotices.any((item) => item.id == notice.id);

    if (!alreadyApproved) {
      approvedNotices.add(
        notice.copyWith(isApproved: true, isRead: false, isDownloaded: false),
      );

      NotificationRepository.addNotification();
    }

    _refresh();
  }

  static void rejectNotice(NoticeModel notice) {
    pendingNotices.removeWhere((item) => item.id == notice.id);
    _refresh();
  }

  static void updateApprovedNotice(NoticeModel updatedNotice) {
    final index = approvedNotices.indexWhere(
      (item) => item.id == updatedNotice.id,
    );

    if (index != -1) {
      approvedNotices[index] = updatedNotice.copyWith(isApproved: true);
      _refresh();
    }
  }

  static void markAsRead(NoticeModel notice) {
    final index = approvedNotices.indexWhere((item) => item.id == notice.id);

    if (index != -1) {
      approvedNotices[index] = approvedNotices[index].copyWith(isRead: true);
      _refresh();
    }
  }

  static void markAsDownloaded(NoticeModel notice) {
    final index = approvedNotices.indexWhere((item) => item.id == notice.id);

    if (index != -1) {
      approvedNotices[index] = approvedNotices[index].copyWith(
        isDownloaded: true,
        isRead: true,
      );
      _refresh();
    }
  }

  static void deleteApprovedNotice(NoticeModel notice) {
    approvedNotices.removeWhere((item) => item.id == notice.id);
    _refresh();
  }
  static Future<void> loadStudentNotices() async {
  approvedNotices = await NoticeService.getStudentNotices();
  notifier.value++;
}
}
