import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../auth/login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            children: [
              const Spacer(),
              const Icon(
                Icons.school_rounded,
                size: 80,
                color: AppColors.primary,
              ),

              const SizedBox(height: 20),

              const Text(
                "SANA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                  letterSpacing: -1,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Smart Academic Notice Analyzer\n& Deadline Tracker",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textLight,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              _RoleButton(
                title: "Student",
                icon: Icons.person_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(role: "student"),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              _RoleButton(
                title: "Admin",
                icon: Icons.admin_panel_settings_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(role: "admin"),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              Text(
                "v1.0.0",
                style: TextStyle(
                  color: AppColors.textLight.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.045),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.11),
                child: Icon(icon, color: AppColors.primary, size: 25),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Text(
                  "Continue as $title",
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
