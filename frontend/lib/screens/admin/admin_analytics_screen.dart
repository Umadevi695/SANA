// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/notice_repository.dart';
import '../../models/notice_model.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NoticeRepository.notifier,
      builder: (context, value, child) {
        final pending = NoticeRepository.pendingNotices.length;
        final published = NoticeRepository.approvedNotices.length;
        final total = pending + published;
        final upcoming = _upcomingDeadlineCount(
          NoticeRepository.approvedNotices,
        );
        final urgent = _urgentDeadlineCount(NoticeRepository.approvedNotices);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Analytics",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Overview of notice activity and deadlines",
                    style: TextStyle(color: AppColors.textLight, fontSize: 14),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _AnalyticsCard(
                          title: "Total",
                          value: total.toString(),
                          icon: Icons.description_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AnalyticsCard(
                          title: "Pending",
                          value: pending.toString(),
                          icon: Icons.pending_actions_rounded,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _AnalyticsCard(
                          title: "Published",
                          value: published.toString(),
                          icon: Icons.verified_rounded,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AnalyticsCard(
                          title: "Upcoming",
                          value: upcoming.toString(),
                          icon: Icons.calendar_month_rounded,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _AnalyticsCard(
                          title: "Urgent",
                          value: urgent.toString(),
                          icon: Icons.warning_rounded,
                          color: AppColors.urgent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: _AnalyticsCard(
                          title: "Students",
                          value: "1.2K",
                          icon: Icons.groups_rounded,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "Notice Health",
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _ProgressTile(
                    title: "Published Ratio",
                    value: total == 0 ? 0 : published / total,
                    label: "$published of $total notices published",
                    color: AppColors.success,
                  ),

                  _ProgressTile(
                    title: "Pending Ratio",
                    value: total == 0 ? 0 : pending / total,
                    label: "$pending notices waiting for review",
                    color: AppColors.warning,
                  ),

                  _ProgressTile(
                    title: "Urgent Deadline Load",
                    value: published == 0 ? 0 : urgent / published,
                    label: "$urgent urgent notices detected",
                    color: AppColors.urgent,
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "System Insights",
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const _InsightTile(
                    icon: Icons.auto_graph_rounded,
                    title: "Notice Flow",
                    subtitle: "Admin upload, review and publishing flow active",
                    color: AppColors.primary,
                  ),

                  const _InsightTile(
                    icon: Icons.notifications_active_rounded,
                    title: "Notifications",
                    subtitle: "Students receive alerts for published notices",
                    color: AppColors.success,
                  ),

                  const _InsightTile(
                    icon: Icons.track_changes_rounded,
                    title: "Deadline Tracker",
                    subtitle: "Approved notices are used for deadline tracking",
                    color: AppColors.warning,
                  ),

                  const _InsightTile(
                    icon: Icons.storage_rounded,
                    title: "Storage Mode",
                    subtitle: "Currently using local prototype repository",
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressTile extends StatelessWidget {
  final String title;
  final double value;
  final String label;
  final Color color;

  const _ProgressTile({
    required this.title,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue = value.clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: AppColors.textLight, fontSize: 12),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: safeValue,
              minHeight: 9,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _InsightTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

DateTime? _parseDeadlineDate(String dateString) {
  try {
    if (dateString.contains('/')) {
      final parts = dateString.split('/');
      if (parts.length != 3) return null;

      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    }

    final parts = dateString.split(' ');
    if (parts.length != 3) return null;

    const months = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'June': 6,
      'Jul': 7,
      'July': 7,
      'Aug': 8,
      'Sep': 9,
      'Sept': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };

    final month = months[parts[1]];
    if (month == null) return null;

    return DateTime(int.parse(parts[2]), month, int.parse(parts[0]));
  } catch (_) {
    return null;
  }
}

int _upcomingDeadlineCount(List<NoticeModel> notices) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return notices.where((notice) {
    final deadline = _parseDeadlineDate(notice.date);
    if (deadline == null) return false;
    return !deadline.isBefore(today);
  }).length;
}

int _urgentDeadlineCount(List<NoticeModel> notices) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return notices.where((notice) {
    final deadline = _parseDeadlineDate(notice.date);
    if (deadline == null) return false;

    final days = deadline.difference(today).inDays;
    return days >= 0 && days <= 7;
  }).length;
}
