import '../../services/user_session.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/notice_repository.dart';
import '../../data/notification_repository.dart';
import '../../models/notice_model.dart';
import 'notices_screen.dart';
import 'profile_screen.dart';
import 'tracker_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;
  @override
void initState() {
  super.initState();

  NoticeRepository.loadStudentNotices();
}

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _navItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      label: label,
      icon: AnimatedScale(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        scale: isSelected ? 1.18 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: isSelected ? 26 : 22),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _HomeContent(onTabChange: _changeTab),
      const NoticesScreen(),
      const TrackerScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: KeyedSubtree(
            key: ValueKey<int>(_selectedIndex),
            child: screens[_selectedIndex],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _changeTab,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.card,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textLight,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            items: [
              _navItem(Icons.home_rounded, 'Home', 0),
              _navItem(Icons.description_rounded, 'Notices', 1),
              _navItem(Icons.calendar_month_rounded, 'Tracker', 2),
              _navItem(Icons.person_rounded, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final void Function(int index) onTabChange;

  const _HomeContent({required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NoticeRepository.notifier,
      builder: (context, value, child) {
        final approvedNotices = NoticeRepository.approvedNotices;
        final recentNotices = approvedNotices.reversed.take(3).toList();

        final upcomingDeadlines = approvedNotices.where((notice) {
  final deadline = _parseDeadlineDate(notice.date);
  if (deadline == null) return false;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return deadline.isAfter(today); 
}).toList();
     final completedNotices =
    approvedNotices.where((notice) {
      
              final deadline = _parseDeadlineDate(notice.date);
              if (deadline == null) return false;

              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);

              return deadline.isBefore(today);
            }).toList();/*..sort((a, b) {
              final dateA = _parseDeadlineDate(a.date) ?? DateTime(2100);
              final dateB = _parseDeadlineDate(b.date) ?? DateTime(2100);
              return dateA.compareTo(dateB);
            });*/

        //final urgentCount = _urgentDeadlineCount(upcomingDeadlines);
        final urgentCount = approvedNotices
    .where((notice) => _priorityFromDate(notice.date) == "Urgent")
    .length;

        final notificationCount = NotificationRepository.unreadCount > 9
            ? "9+"
            : NotificationRepository.unreadCount.toString();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HomeHeader(
                notificationCount: notificationCount,
                hasUnread: NotificationRepository.unreadCount > 0,
                onNotificationTap: () {
                  NotificationRepository.markAllAsRead();
                  _showNotifications(context, approvedNotices);
                },
              ),

              const SizedBox(height: 22),

              _HeroSummaryCard(
                totalNotices: approvedNotices.length,
                urgentCount: urgentCount,
                nextDeadlineText: upcomingDeadlines.isEmpty
                    ? "No upcoming deadlines"
                    : _daysLeftText(upcomingDeadlines.first.date),
                onTrackerTap: () => onTabChange(2),
              ),

              const SizedBox(height: 22),

              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .78,
                children: [
                  _StatCard(
                    number: approvedNotices.length.toString(),
                    label: "Notices",
                    color: Colors.green,
                    icon: Icons.description_rounded,
                  ),
                  _StatCard(
                    number: upcomingDeadlines.length.toString(),
                    label: "Deadlines",
                    color: Colors.blue,
                    icon: Icons.calendar_month_rounded,
                  ),
                  _StatCard(
                    number: urgentCount.toString(),
                    label: "Urgent",
                    color: Colors.red,
                    icon: Icons.warning_rounded,
                  ),
                 _StatCard(
  number: completedNotices.length.toString(),
  label: "Completed",
  color: Colors.orange,
  icon: Icons.check_circle_rounded,
),
                ],
              ),

              const SizedBox(height: 26),

              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      title: "Notices",
                      subtitle: "Browse all",
                      icon: Icons.description_rounded,
                      color: AppColors.primary,
                      onTap: () => onTabChange(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionCard(
                      title: "Tracker",
                      subtitle: "View deadlines",
                      icon: Icons.track_changes_rounded,
                      color: AppColors.warning,
                      onTap: () => onTabChange(2),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              _sectionHeader(
                "Upcoming Deadlines",
                "View All",
                onTap: () => onTabChange(2),
              ),

              const SizedBox(height: 14),

              if (upcomingDeadlines.isEmpty)
                const _NoUpcomingDeadlinesCard()
              else
                ...upcomingDeadlines
                    .take(3)
                    .map((notice) => _deadlineCardFromNotice(context, notice)),

              const SizedBox(height: 28),

              _sectionHeader(
                "Recent Notices",
                "View All",
                onTap: () => onTabChange(1),
              ),

              const SizedBox(height: 14),

              if (recentNotices.isEmpty)
                const _NoApprovedNoticesCard()
              else
                ...recentNotices.map(
                  (notice) => _noticeCardFromModel(context, notice),
                ),

              const SizedBox(height: 90),
            ],
          ),
        );
      },
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final String notificationCount;
  final bool hasUnread;
  final VoidCallback onNotificationTap;

  const _HomeHeader({
    required this.notificationCount,
    required this.hasUnread,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello 👋",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                UserSession.name.isEmpty
      ? "Student"
      : UserSession.name,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Stay updated with academic notices",
                style: TextStyle(color: AppColors.textLight, fontSize: 13),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onNotificationTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 28,
                  color: AppColors.textDark,
                ),
              ),
              if (hasUnread)
                Positioned(
                  right: -3,
                  top: -3,
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        notificationCount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroSummaryCard extends StatelessWidget {
  final int totalNotices;
  final int urgentCount;
  final String nextDeadlineText;
  final VoidCallback onTrackerTap;

  const _HeroSummaryCard({
    required this.totalNotices,
    required this.urgentCount,
    required this.nextDeadlineText,
    required this.onTrackerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.24),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 32),
          const SizedBox(height: 16),
          const Text(
            "Smart Notice Hub",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "All approved notices, deadlines, and reminders are organized in one place.",
            style: TextStyle(color: Colors.white70, height: 1.45),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _HeroMiniStat(value: totalNotices.toString(), label: "Notices"),
              const SizedBox(width: 12),
              _HeroMiniStat(value: urgentCount.toString(), label: "Urgent"),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onTrackerTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Next deadline: $nextDeadlineText",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMiniStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeroMiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.13),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
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
                  const SizedBox(height: 3),
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
          ],
        ),
      ),
    );
  }
}

Widget _sectionHeader(String title, String actionText, {VoidCallback? onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
      GestureDetector(
        onTap: onTap,
        child: Text(
          actionText,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    ],
  );
}

Widget _deadlineCardFromNotice(BuildContext context, NoticeModel notice) {
  final daysText = _daysLeftText(notice.date);
  final priority = _priorityFromDate(notice.date);
  final isUrgent = priority == "Urgent";

  return GestureDetector(
    onTap: () {
      _showDeadlineDetails(
        context,
        title: notice.title,
        department: "${notice.category} Department",
        deadline: notice.date,
        priority: priority,
        description: notice.description,
        status: "Pending",
      );
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: (isUrgent ? AppColors.urgent : AppColors.warning)
                .withOpacity(0.12),
            child: Icon(
              isUrgent ? Icons.warning_rounded : Icons.calendar_today_rounded,
              color: isUrgent ? AppColors.urgent : AppColors.warning,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notice.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${notice.category} • $daysText",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

Widget _noticeCardFromModel(BuildContext context, NoticeModel notice) {
  return GestureDetector(
    onTap: () {
      _showNoticeDetails(
        context,
        title: notice.title,
        department: "${notice.category} Department",
        posted: "Recently",
        category: notice.category,
        summary: notice.description,
        deadline: notice.date,
        priority: _priorityFromCategory(notice.category),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: const Icon(
              Icons.description_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notice.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${notice.category} • Deadline: ${notice.date}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

String _priorityFromCategory(String category) {
  final urgentCategories = ["Exam", "Fee", "Assignment"];
  return urgentCategories.contains(category) ? "High" : "Medium";
}

void _showNotifications(BuildContext context, List<NoticeModel> notices) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      final latestNotices = notices.reversed.take(5).toList();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),
              if (latestNotices.isEmpty)
                const _NotificationTile(
                  title: "No new notifications",
                  subtitle: "Approved notices will appear here.",
                  icon: Icons.notifications_off_rounded,
                  color: AppColors.textLight,
                )
              else
                ...latestNotices.map(
                  (notice) => _NotificationTile(
                    title: notice.title,
                    subtitle: "New ${notice.category} notice published.",
                    icon: Icons.description_rounded,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

void _showDeadlineDetails(
  BuildContext context, {
  required String title,
  required String department,
  required String deadline,
  required String priority,
  required String description,
  required String status,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return _DetailsSheet(
        icon: Icons.calendar_month_rounded,
        iconColor: priority == "High" || priority == "Urgent"
            ? AppColors.urgent
            : AppColors.warning,
        title: title,
        subtitle: department,
        badges: [
          _SheetBadge(
            label: priority,
            color: priority == "High" || priority == "Urgent"
                ? AppColors.urgent
                : AppColors.warning,
          ),
          _SheetBadge(label: status, color: AppColors.primary),
        ],
        sectionTitle: "Deadline Details",
        body: description,
        footerIcon: Icons.event_available_rounded,
        footerText: "Extracted Deadline: $deadline",
      );
    },
  );
}

void _showNoticeDetails(
  BuildContext context, {
  required String title,
  required String department,
  required String posted,
  required String category,
  required String summary,
  required String deadline,
  required String priority,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return _DetailsSheet(
        icon: Icons.description_rounded,
        iconColor: AppColors.primary,
        title: title,
        subtitle: "$department • $posted",
        badges: [
          _SheetBadge(label: category, color: AppColors.primary),
          _SheetBadge(
            label: priority,
            color: priority == "High" ? AppColors.urgent : AppColors.warning,
          ),
        ],
        sectionTitle: "AI Summary",
        body: summary,
        footerIcon: Icons.calendar_month_rounded,
        footerText: "Extracted Deadline: $deadline",
      );
    },
  );
}

class _NoUpcomingDeadlinesCard extends StatelessWidget {
  const _NoUpcomingDeadlinesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.event_available_rounded,
            size: 42,
            color: AppColors.textLight,
          ),
          SizedBox(height: 10),
          Text(
            "No upcoming deadlines",
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Approved notice deadlines will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}

class _NoApprovedNoticesCard extends StatelessWidget {
  const _NoApprovedNoticesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(Icons.inbox_rounded, size: 42, color: AppColors.textLight),
          SizedBox(height: 10),
          Text(
            "No approved notices yet",
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Published notices from admin will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _NotificationTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
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
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 13,
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

class _DetailsSheet extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<_SheetBadge> badges;
  final String sectionTitle;
  final String body;
  final IconData footerIcon;
  final String footerText;

  const _DetailsSheet({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badges,
    required this.sectionTitle,
    required this.body,
    required this.footerIcon,
    required this.footerText,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: iconColor.withOpacity(0.12),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
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
            const SizedBox(height: 14),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.textLight, fontSize: 14),
            ),
            const SizedBox(height: 18),
            Wrap(spacing: 10, runSpacing: 10, children: badges),
            const SizedBox(height: 22),
            Text(
              sectionTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: const TextStyle(color: AppColors.textLight, height: 1.5),
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
                  Icon(footerIcon, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      footerText,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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

class _SheetBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _SheetBadge({required this.label, required this.color});

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

class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.number,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 7),
          Text(
            number,
            style: TextStyle(
              color: color,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: AppColors.textLight),
          ),
        ],
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

String _daysLeftText(String dateString) {
  final deadline = _parseDeadlineDate(dateString);

  if (deadline == null) return "Deadline: $dateString";

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final days = deadline.difference(today).inDays;

  if (days < 0) return "Expired";
  if (days == 0) return "Due today";
  if (days == 1) return "Due tomorrow";

  return "Due in $days days";
}

/*String _priorityFromDate(String dateString) {
  final deadline = _parseDeadlineDate(dateString);

  if (deadline == null) return "Medium";

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final days = deadline.difference(today).inDays;

  if (days <= 7) return "Urgent";

  return "Medium";
}*/
String _priorityFromDate(String dateString) {
  final deadline = _parseDeadlineDate(dateString);

  if (deadline == null) return "Upcoming";

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final difference = deadline.difference(today).inDays;

  if (difference < 0) {
    return "Expired";
  } else if (difference <= 3) {
    return "Urgent";
  } else {
    return "Upcoming";
  }
}

int _urgentDeadlineCount(List<NoticeModel> notices) {
  return notices
      .where((notice) => _priorityFromDate(notice.date) == "Urgent")
      .length;
}
