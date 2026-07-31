// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'admin_dashboard.dart';
import 'upload_notice_screen.dart';
import 'review_pending_screen.dart';
import 'manage_notices_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    AdminDashboard(),
    ReviewPendingScreen(),
    UploadNoticeScreen(),
    ManageNoticesScreen(),
    _AdminProfileScreen(),
  ];

  void _changeScreen(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: IndexedStack(index: selectedIndex, children: screens),

      floatingActionButton: Transform.translate(
        offset: const Offset(0, 10),
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
              _BottomItem(
                icon: Icons.home_rounded,
                label: "Home",
                isSelected: selectedIndex == 0,
                onTap: () => _changeScreen(0),
              ),
              _BottomItem(
                icon: Icons.fact_check_outlined,
                label: "Review",
                isSelected: selectedIndex == 1,
                onTap: () => _changeScreen(1),
              ),
              const SizedBox(width: 46),
              _BottomItem(
                icon: Icons.folder_copy_outlined,
                label: "Manage",
                isSelected: selectedIndex == 3,
                onTap: () => _changeScreen(3),
              ),
              _BottomItem(
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

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
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

class _AdminProfileScreen extends StatelessWidget {
  const _AdminProfileScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Text(
            "Admin Profile Coming Soon",
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
