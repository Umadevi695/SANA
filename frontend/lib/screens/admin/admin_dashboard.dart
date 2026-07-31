// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'upload_notice_screen.dart';
import 'manage_notices_screen.dart';
import 'review_pending_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_analytics_screen.dart';
import '../../data/notice_repository.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  void _changeScreen(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _AdminHomeContent(onNavigate: _changeScreen),
      const ReviewPendingScreen(),
      const UploadNoticeScreen(),
      const ManageNoticesScreen(),
      const AdminProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      body: IndexedStack(index: selectedIndex, children: screens),

      floatingActionButton: Transform.translate(
        offset: const Offset(0, 20),
        child: FloatingActionButton(
          onPressed: () => _changeScreen(2),
          backgroundColor: AppColors.primary,
          elevation: 8,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 34),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: AppColors.card,
        elevation: 14,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AdminBottomItem(
                icon: Icons.home_rounded,
                label: "Home",
                isSelected: selectedIndex == 0,
                onTap: () => _changeScreen(0),
              ),
              _AdminBottomItem(
                icon: Icons.fact_check_outlined,
                label: "Review",
                isSelected: selectedIndex == 1,
                onTap: () => _changeScreen(1),
              ),
              const SizedBox(width: 46),
              _AdminBottomItem(
                icon: Icons.folder_copy_outlined,
                label: "Manage",
                isSelected: selectedIndex == 3,
                onTap: () => _changeScreen(3),
              ),
              _AdminBottomItem(
                icon: Icons.person_outline_rounded,
                label: "Profile",
                isSelected: selectedIndex == 4,
                onTap: () => _changeScreen(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminHomeContent extends StatelessWidget {
  final void Function(int index) onNavigate;

  const _AdminHomeContent({required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NoticeRepository.notifier,
      builder: (context, value, child) {
        final pendingCount = NoticeRepository.pendingNotices.length;
        final publishedCount = NoticeRepository.approvedNotices.length;
        final totalCount = pendingCount + publishedCount;

        final recentPublished = NoticeRepository.approvedNotices.reversed
            .take(2)
            .toList();

        final recentPending = NoticeRepository.pendingNotices.reversed
            .take(2)
            .toList();

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Admin Dashboard 👨‍💼",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Upload, review and publish academic notices",
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.22),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "Notice Control Center",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Manage notice uploads, reviews, publishing and analytics from one place.",
                        style: TextStyle(color: Colors.white70, height: 1.45),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _HeroMiniStat(
                              value: pendingCount.toString(),
                              label: "Pending",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _HeroMiniStat(
                              value: publishedCount.toString(),
                              label: "Published",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.10,
                  children: [
                    _AdminStatCard(
                      number: totalCount.toString(),
                      label: "Total Notices",
                      icon: Icons.description_rounded,
                      color: AppColors.primary,
                    ),
                    _AdminStatCard(
                      number: publishedCount.toString(),
                      label: "Published",
                      icon: Icons.publish_rounded,
                      color: AppColors.success,
                    ),
                    _AdminStatCard(
                      number: pendingCount.toString(),
                      label: "Pending Review",
                      icon: Icons.pending_actions_rounded,
                      color: AppColors.warning,
                    ),
                    const _AdminStatCard(
                      number: "1.2K",
                      label: "Students Reached",
                      icon: Icons.groups_rounded,
                      color: Colors.purple,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 10),

                _ActionCard(
                  title: "Upload Notice",
                  subtitle: "Upload PDF, image, or text notice",
                  icon: Icons.upload_file_rounded,
                  color: AppColors.primary,
                  onTap: () => onNavigate(2),
                ),

                _ActionCard(
                  title: "Review Pending Notices",
                  subtitle: "$pendingCount notice(s) waiting for approval",
                  icon: Icons.fact_check_rounded,
                  color: AppColors.warning,
                  onTap: () => onNavigate(1),
                ),

                _ActionCard(
                  title: "Manage Published Notices",
                  subtitle: "$publishedCount published notice(s) available",
                  icon: Icons.folder_copy_rounded,
                  color: AppColors.success,
                  onTap: () => onNavigate(3),
                ),

                _ActionCard(
                  title: "Analytics Dashboard",
                  subtitle: "View notice activity and deadline insights",
                  icon: Icons.analytics_rounded,
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminAnalyticsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                const Text(
                  "Recent Admin Activity",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 14),

                if (recentPublished.isEmpty && recentPending.isEmpty)
                  const _ActivityTile(
                    title: "No recent activity yet",
                    subtitle: "Upload or approve notices to see activity here",
                    icon: Icons.history_rounded,
                    color: AppColors.textLight,
                  )
                else ...[
                  ...recentPublished.map(
                    (notice) => _ActivityTile(
                      title: "${notice.title} Published",
                      subtitle: "${notice.category} notice visible to students",
                      icon: Icons.check_circle_rounded,
                      color: AppColors.success,
                    ),
                  ),
                  ...recentPending.map(
                    (notice) => _ActivityTile(
                      title: "${notice.title} Uploaded",
                      subtitle: "Waiting for admin review",
                      icon: Icons.pending_rounded,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroMiniStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeroMiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _AdminBottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AdminBottomItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.textLight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 62,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminStatCard extends StatelessWidget {
  final String number;
  final String label;
  final IconData icon;
  final Color color;

  const _AdminStatCard({
    required this.number,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            number,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
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
        margin: const EdgeInsets.only(bottom: 14),
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
              radius: 25,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
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

class _ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ActivityTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        ],
      ),
    );
  }
}
