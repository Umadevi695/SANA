import 'package:flutter/material.dart';

class NotificationRepository {
  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);

  static int unreadCount = 0;

  static void addNotification() {
    unreadCount++;
    notifier.value++;
  }

  static void markAllAsRead() {
    unreadCount = 0;
    notifier.value++;
  }
}
