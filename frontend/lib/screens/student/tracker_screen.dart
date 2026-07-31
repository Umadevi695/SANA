// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/notice_repository.dart';
import '../../models/notice_model.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NoticeRepository.notifier,
      builder: (context, value, child) {
        final notices = NoticeRepository.approvedNotices;

        final urgentNotices = notices
            .where((notice) => _priorityFromDate(notice.date) == "Urgent")
            .toList()
            .reversed
            .toList();

        final upcomingNotices = notices
            .where((notice) => _priorityFromDate(notice.date) == "Upcoming")
            .toList()
            .reversed
            .toList();

        final expiredNotices = notices
            .where((notice) => _priorityFromDate(notice.date) == "Expired")
            .toList()
            .reversed
            .toList();

        final totalDeadlines = notices.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Deadline Tracker",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Track urgent, upcoming, and expired academic deadlines",
                style: TextStyle(color: AppColors.textLight, fontSize: 14),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: "Total",
                      value: totalDeadlines.toString(),
                      icon: Icons.track_changes_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      title: "Urgent",
                      value: urgentNotices.length.toString(),
                      icon: Icons.warning_rounded,
                      color: AppColors.urgent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: "Upcoming",
                      value: upcomingNotices.length.toString(),
                      icon: Icons.schedule_rounded,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SummaryCard(
                      title: "Expired",
                      value: expiredNotices.length.toString(),
                      icon: Icons.history_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              if (notices.isEmpty)
                const _MainEmptyState()
              else ...[
                _sectionTitle(
                  "Urgent",
                  AppColors.urgent,
                  Icons.warning_rounded,
                ),
                const SizedBox(height: 14),

                if (urgentNotices.isEmpty)
                  const _EmptyMiniCard(
                    message: "No urgent deadlines yet",
                    icon: Icons.check_circle_outline_rounded,
                  )
                else
                  ...urgentNotices.map(
                    (notice) => _DeadlineCard(
                      notice: notice,
                      status: "Urgent",
                      statusColor: AppColors.urgent,
                      icon: _categoryIcon(notice.category),
                    ),
                  ),

                const SizedBox(height: 24),

                _sectionTitle(
                  "Upcoming",
                  AppColors.warning,
                  Icons.schedule_rounded,
                ),
                const SizedBox(height: 14),

                if (upcomingNotices.isEmpty)
                  const _EmptyMiniCard(
                    message: "No upcoming deadlines yet",
                    icon: Icons.event_available_rounded,
                  )
                else
                  ...upcomingNotices.map(
                    (notice) => _DeadlineCard(
                      notice: notice,
                      status: "Upcoming",
                      statusColor: AppColors.warning,
                      icon: _categoryIcon(notice.category),
                    ),
                  ),

                const SizedBox(height: 24),

                _sectionTitle("Expired", Colors.grey, Icons.history_rounded),
                const SizedBox(height: 14),

                if (expiredNotices.isEmpty)
                  const _EmptyMiniCard(
                    message: "No expired deadlines",
                    icon: Icons.history_toggle_off_rounded,
                  )
                else
                  ...expiredNotices.map(
                    (notice) => _DeadlineCard(
                      notice: notice,
                      status: "Expired",
                      statusColor: Colors.grey,
                      icon: _categoryIcon(notice.category),
                    ),
                  ),
              ],

              const SizedBox(height: 90),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
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
            radius: 22,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _sectionTitle(String title, Color color, IconData icon) {
  return Row(
    children: [
      CircleAvatar(
        radius: 16,
        backgroundColor: color.withOpacity(0.12),
        child: Icon(icon, color: color, size: 18),
      ),
      const SizedBox(width: 10),
      Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.textDark,
        ),
      ),
    ],
  );
}

class _DeadlineCard extends StatelessWidget {
  final NoticeModel notice;
  final String status;
  final Color statusColor;
  final IconData icon;

  const _DeadlineCard({
    required this.notice,
    required this.status,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDeadlineDetails(context, notice, status, statusColor),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: statusColor.withOpacity(0.12),
              child: Icon(icon, color: statusColor, size: 25),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.title,
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "${notice.category} Department",
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 15,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          notice.date,
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          _daysLeftText(notice.date),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMiniCard extends StatelessWidget {
  final String message;
  final IconData icon;

  const _EmptyMiniCard({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textLight),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainEmptyState extends StatelessWidget {
  const _MainEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        children: [
          Icon(Icons.event_busy_rounded, size: 46, color: AppColors.textLight),
          SizedBox(height: 14),
          Text(
            "No deadlines yet",
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Approved notices with deadlines will automatically appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textLight, height: 1.5),
          ),
        ],
      ),
    );
  }
}

void _showDeadlineDetails(
  BuildContext context,
  NoticeModel notice,
  String status,
  Color statusColor,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: statusColor.withOpacity(0.12),
                      child: Icon(
                        _categoryIcon(notice.category),
                        color: statusColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        notice.title,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  "${notice.category} Department",
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _InfoBadge(
                      label: notice.category,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    _InfoBadge(label: status, color: statusColor),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  "Deadline Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notice.description,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Extracted Deadline: ${notice.date}",
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timer_rounded, color: statusColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _daysLeftText(notice.date),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

DateTime? _parseDeadlineDate(String dateString) {
  try {
    if (dateString.contains('-')) {
  final parts = dateString.split('-');

  if (parts.length != 3) return null;

  final day = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final year = int.parse(parts[2]);

  return DateTime(year, month, day);
}
    if (dateString.contains('/')) {
      final parts = dateString.split('/');

      if (parts.length != 3) return null;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      return DateTime(year, month, day);
    }

    final parts = dateString.split(' ');

    if (parts.length != 3) return null;

    final day = int.parse(parts[0]);

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

    final year = int.parse(parts[2]);

    return DateTime(year, month, day);
  } catch (_) {
    return null;
  }
}

String _priorityFromDate(String dateString) {
  final deadline = _parseDeadlineDate(dateString);

  if (deadline == null) return "Upcoming";

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final difference = deadline.difference(today).inDays;

  if (difference < 0) return "Expired";
  if (difference <= 7) return "Urgent";

  return "Upcoming";
}

String _daysLeftText(String dateString) {
  final deadline = _parseDeadlineDate(dateString);

  if (deadline == null) return "Deadline: $dateString";

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final days = deadline.difference(today).inDays;

  if (days < 0) return "Expired";
  if (days == 0) return "Today";
  if (days == 1) return "1 Day Left";

  return "$days Days Left";
}
IconData _categoryIcon(String category) {
  switch (category) {
    case "Exam":
      return Icons.assignment_rounded;

    case "Fee":
    case "Fee Payment":
      return Icons.payments_rounded;

    case "Event":
      return Icons.event_rounded;

    case "Assignment":
      return Icons.task_alt_rounded;

    case "Placement":
      return Icons.work_rounded;

    case "Scholarship":
      return Icons.school_rounded;

    default:
      return Icons.description_rounded;
  }
}

