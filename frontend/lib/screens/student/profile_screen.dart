// ignore_for_file: deprecated_member_use
import '../../services/user_session.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/notice_repository.dart';
import '../../models/notice_model.dart';
import '../role_selection/role_selection_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool noticeAlerts = true;
  bool deadlineReminders = true;
  bool priorityAlerts = true;

  String name = "";
String email = "";
String branch = "";
String year = "";

@override
void initState() {
  super.initState();
  loadUserData();
}

void loadUserData() {
  setState(() {
    name = UserSession.name;
    email = UserSession.email;
    branch = UserSession.branch;
    year = UserSession.year;
  });
}

  String reminderTime = "1 day before";

  final Set<String> selectedCategories = {"Exams", "Assignments", "Events"};

  final List<String> categories = [
    "Exams",
    "Assignments",
    "Events",
    "Placements",
    "Scholarships",
    "General",
  ];

  void _logout(BuildContext context) {
    Navigator.pop(context);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false,
    );
  }

  void _showNotificationPreferences() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            return _BottomSheetShell(
              icon: Icons.notifications_rounded,
              title: "Notification Preferences",
              subtitle: "Manage alerts and announcements",
              child: Column(
                children: [
                  _SwitchTile(
                    title: "New Notice Alerts",
                    subtitle: "Get notified when admin uploads notices",
                    value: noticeAlerts,
                    onChanged: (value) {
                      sheetSetState(() => noticeAlerts = value);
                      setState(() {});
                    },
                  ),
                  _SwitchTile(
                    title: "Deadline Reminders",
                    subtitle: "Receive reminders before deadlines",
                    value: deadlineReminders,
                    onChanged: (value) {
                      sheetSetState(() => deadlineReminders = value);
                      setState(() {});
                    },
                  ),
                  _SwitchTile(
                    title: "Priority Alerts",
                    subtitle: "Show urgent academic notices first",
                    value: priorityAlerts,
                    onChanged: (value) {
                      sheetSetState(() => priorityAlerts = value);
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showReminderSettings() {
    final options = [
      "Same day",
      "1 day before",
      "2 days before",
      "1 week before",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            return _BottomSheetShell(
              icon: Icons.access_time_filled_rounded,
              title: "Reminder Settings",
              subtitle: "Deadline reminder configuration",
              child: Column(
                children: options.map((option) {
                  return RadioListTile<String>(
                    value: option,
                    groupValue: reminderTime,
                    activeColor: AppColors.primary,
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    onChanged: (value) {
                      if (value == null) return;
                      sheetSetState(() => reminderTime = value);
                      setState(() {});
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  void _showAcademicCategories() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            return _BottomSheetShell(
              icon: Icons.category_rounded,
              title: "Academic Categories",
              subtitle: "Customize notice categories",
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categories.map((category) {
                  final selected = selectedCategories.contains(category);

                  return FilterChip(
                    label: Text(category),
                    selected: selected,
                    selectedColor: AppColors.primary.withOpacity(0.16),
                    checkmarkColor: AppColors.primary,
                    backgroundColor: AppColors.primary.withOpacity(0.06),
                    labelStyle: TextStyle(
                      color: selected ? AppColors.primary : AppColors.textDark,
                      fontWeight: FontWeight.w800,
                    ),
                    onSelected: (value) {
                      sheetSetState(() {
                        if (value) {
                          selectedCategories.add(category);
                        } else {
                          selectedCategories.remove(category);
                        }
                      });
                      setState(() {});
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  void _showDownloadHistory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _BottomSheetShell(
          icon: Icons.file_download_rounded,
          title: "Download History",
          subtitle: "View downloaded notices",
          child: NoticeRepository.downloadedNotices.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "No downloaded notices yet.",
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : Column(
                  children: NoticeRepository.downloadedNotices.map((notice) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.picture_as_pdf_rounded,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              notice.attachmentName,
                              style: const TextStyle(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.visibility_rounded,
                            color: AppColors.textLight,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NoticeRepository.notifier,
      builder: (context, value, child) {
        final notices = NoticeRepository.approvedNotices;
        final totalNotices = notices.length;
        final upcomingDeadlines = _upcomingDeadlineCount(notices);
        final urgentNotices = _urgentDeadlineCount(notices);
        //const completedTasks = 5;
        final completedTasks = notices.where((notice) {
  final deadline = _parseDeadlineDate(notice.date);
  if (deadline == null) return false;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return deadline.isBefore(today);
}).length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: AppColors.primary.withOpacity(0.12),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 60,
                            color: AppColors.primary,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      UserSession.name.isEmpty
      ? "Student"
      : UserSession.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 6),

                   Text(
  UserSession.branch.isEmpty
      ? "Department Not Available"
      : UserSession.branch,
  style: const TextStyle(
    color: AppColors.textLight,
    fontSize: 14,
  ),
),

                    const SizedBox(height: 10),

                   Text(
  "Year ${UserSession.year} • ${UserSession.branch} • Active",
  style: const TextStyle(
    color: AppColors.textLight,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  ),
),

                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "Student Portal Active",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const _SectionTitle(title: "Statistics"),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _ProfileStatCard(
                      title: "Notices",
                      value: totalNotices.toString(),
                      icon: Icons.description_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ProfileStatCard(
                      title: "Deadlines",
                      value: upcomingDeadlines.toString(),
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
                    child: _ProfileStatCard(
                      title: "Urgent",
                      value: urgentNotices.toString(),
                      icon: Icons.warning_rounded,
                      color: AppColors.urgent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ProfileStatCard(
                      title: "Completed",
                      value: completedTasks.toString(),
                      icon: Icons.check_circle_rounded,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              const _SectionTitle(title: "Academic Summary"),

              const SizedBox(height: 14),

               _ProfileInfoCard(
                title: "Department",
                value: branch,
                icon: Icons.school_rounded,
              ),

              _ProfileInfoCard(
                title: "Year",
                value: year,
                icon: Icons.timeline_rounded,
              ),

              const _ProfileInfoCard(
                title: "Status",
                value: "Good Standing",
                icon: Icons.verified_user_rounded,
              ),

              _ProfileInfoCard(
                title: "Notifications",
                value: noticeAlerts ? "Enabled" : "Disabled",
                icon: Icons.notifications_active_rounded,
              ),

              const SizedBox(height: 26),

              const _SectionTitle(title: "Smart Features"),

              const SizedBox(height: 14),

              _ProfileOptionCard(
                title: "Notification Preferences",
                subtitle: "Manage alerts and announcements",
                icon: Icons.notifications_rounded,
                onTap: _showNotificationPreferences,
              ),

              _ProfileOptionCard(
                title: "Reminder Settings",
                subtitle: "Deadline reminder configuration",
                icon: Icons.access_time_filled_rounded,
                onTap: _showReminderSettings,
              ),

              _ProfileOptionCard(
                title: "Academic Categories",
                subtitle: "Customize notice categories",
                icon: Icons.category_rounded,
                onTap: _showAcademicCategories,
              ),

              _ProfileOptionCard(
                title: "Download History",
                subtitle: "View downloaded notices",
                icon: Icons.file_download_rounded,
                onTap: _showDownloadHistory,
              ),

              const SizedBox(height: 26),

              const _SectionTitle(title: "Application Information"),

              const SizedBox(height: 14),

              const _ProfileInfoCard(
                title: "Version",
                value: "1.0.0",
                icon: Icons.info_rounded,
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: () => _showLogoutSheet(context, () => _logout(context)),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.urgent.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.logout_rounded,
                          color: AppColors.urgent,
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: AppColors.urgent,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: AppColors.urgent,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textDark,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ProfileStatCard({
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

class _ProfileInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _ProfileInfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
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

class _ProfileOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ProfileOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.12),
              child: Icon(icon, color: AppColors.primary),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSheetShell extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const _BottomSheetShell({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
            children: [
              Container(
                height: 5,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 22),
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.primary.withOpacity(0.12),
                child: Icon(icon, color: AppColors.primary, size: 34),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textLight, height: 1.5),
              ),
              const SizedBox(height: 22),
              child,
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
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
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

void _showLogoutSheet(BuildContext context, VoidCallback onLogout) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 22),
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.urgent.withOpacity(0.12),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.urgent,
                  size: 34,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Logout",
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textLight, height: 1.5),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.urgent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
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

int _upcomingDeadlineCount(List<NoticeModel> notices) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return notices.where((notice) {
    final deadline = _parseDeadlineDate(notice.date);
    if (deadline == null) return false;

    return deadline.isAfter(today);
  }).length;
}


int _urgentDeadlineCount(List<NoticeModel> notices) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return notices.where((notice) {
    final deadline = _parseDeadlineDate(notice.date);
    if (deadline == null) return false;

    final difference = deadline.difference(today).inDays;

    return difference >= 0 && difference <= 3;
  }).length;
}