// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/notice_repository.dart';
import '../role_selection/role_selection_screen.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pop(context);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NoticeRepository.notifier,
      builder: (context, value, child) {
        final pendingCount = NoticeRepository.pendingNotices.length;
        final publishedCount = NoticeRepository.approvedNotices.length;
        final totalCount = pendingCount + publishedCount;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Admin Profile",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Manage your admin account and notice activity",
                    style: TextStyle(color: AppColors.textLight, fontSize: 14),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            const CircleAvatar(
                              radius: 46,
                              backgroundColor: AppColors.primary,
                              child: Icon(
                                Icons.admin_panel_settings_rounded,
                                color: Colors.white,
                                size: 46,
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
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "College Admin",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "admin@college.edu",
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            "Administrator Access Active",
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

                  const _SectionTitle(title: "Admin Analytics"),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _ProfileStatCard(
                          title: "Total Notices",
                          value: totalCount.toString(),
                          icon: Icons.description_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ProfileStatCard(
                          title: "Pending",
                          value: pendingCount.toString(),
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
                        child: _ProfileStatCard(
                          title: "Published",
                          value: publishedCount.toString(),
                          icon: Icons.verified_rounded,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: _ProfileStatCard(
                          title: "Students",
                          value: "1.2K",
                          icon: Icons.groups_rounded,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  const _SectionTitle(title: "Account Details"),

                  const SizedBox(height: 14),

                  const _ProfileOption(
                    icon: Icons.badge_rounded,
                    title: "Role",
                    subtitle: "Administrator",
                    color: AppColors.primary,
                  ),

                  const _ProfileOption(
                    icon: Icons.security_rounded,
                    title: "Access Level",
                    subtitle: "Upload, review, publish and manage notices",
                    color: AppColors.success,
                  ),

                  const _ProfileOption(
                    icon: Icons.notifications_active_rounded,
                    title: "Notifications",
                    subtitle: "Notice activity alerts enabled",
                    color: AppColors.warning,
                  ),

                  const _ProfileOption(
                    icon: Icons.cloud_done_rounded,
                    title: "Data Mode",
                    subtitle: "Local prototype repository active",
                    color: Colors.purple,
                  ),

                  const SizedBox(height: 26),

                  const _SectionTitle(title: "System Status"),

                  const SizedBox(height: 14),

                  const _ProfileOption(
                    icon: Icons.check_circle_rounded,
                    title: "Notice Service",
                    subtitle: "Online and operational",
                    color: AppColors.success,
                  ),

                  const _ProfileOption(
                    icon: Icons.notifications_active_rounded,
                    title: "Notification Engine",
                    subtitle: "Delivering student alerts",
                    color: AppColors.primary,
                  ),

                  const _ProfileOption(
                    icon: Icons.track_changes_rounded,
                    title: "Deadline Tracker",
                    subtitle: "Running successfully",
                    color: AppColors.warning,
                  ),

                  const _ProfileOption(
                    icon: Icons.groups_rounded,
                    title: "Student Portal",
                    subtitle: "Connected and active",
                    color: Colors.purple,
                  ),

                  const SizedBox(height: 26),

                  const _SectionTitle(title: "Permissions"),

                  const SizedBox(height: 14),

                  const _ProfileOption(
                    icon: Icons.upload_file_rounded,
                    title: "Upload Notices",
                    subtitle: "Create new academic notice entries",
                    color: AppColors.primary,
                  ),

                  const _ProfileOption(
                    icon: Icons.pending_actions_rounded,
                    title: "Review Notices",
                    subtitle: "Approve or reject pending notices",
                    color: AppColors.warning,
                  ),

                  const _ProfileOption(
                    icon: Icons.verified_rounded,
                    title: "Publish Notices",
                    subtitle: "Make approved notices visible to students",
                    color: AppColors.success,
                  ),

                  const _ProfileOption(
                    icon: Icons.delete_outline_rounded,
                    title: "Notice Removal",
                    subtitle: "Delete published notices when required",
                    color: AppColors.urgent,
                  ),

                  const SizedBox(height: 26),

                  const _SectionTitle(title: "Application Information"),

                  const SizedBox(height: 14),

                  const _ProfileOption(
                    icon: Icons.info_rounded,
                    title: "Version",
                    subtitle: "1.0.0 Prototype",
                    color: AppColors.primary,
                  ),

                  const _ProfileOption(
                    icon: Icons.storage_rounded,
                    title: "Repository",
                    subtitle: "Local memory storage",
                    color: Colors.purple,
                  ),

                  const _ProfileOption(
                    icon: Icons.security_rounded,
                    title: "Authentication",
                    subtitle: "Role-based login system active",
                    color: AppColors.success,
                  ),

                  const _ProfileOption(
                    icon: Icons.psychology_rounded,
                    title: "AI Analyzer",
                    subtitle: "Notice summary engine ready for integration",
                    color: AppColors.warning,
                  ),

                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () =>
                        _showLogoutSheet(context, () => _logout(context)),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: AppColors.urgent.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded, color: AppColors.urgent),
                          SizedBox(width: 10),
                          Text(
                            "Logout",
                            style: TextStyle(
                              color: AppColors.urgent,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
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
          const SizedBox(height: 10),
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

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ProfileOption({
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
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
                    fontSize: 15,
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
                  fontWeight: FontWeight.w900,
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
