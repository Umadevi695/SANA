import '../../services/auth_service.dart';
import '../../services/user_session.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../admin/admin_dashboard.dart';
import '../student/student_dashboard.dart';
import '../auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;

  Future<void> _login() async {
     print("LOGIN BUTTON PRESSED");
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    _showMessage("Please enter email and password");
    return;
  }

  try {
    print("Calling backend...");
    final result = await AuthService.login(
      email,
      password,
    );

    if (result["success"] == true) {

      final user = result["user"];

      print("Logged in user:");
      print(user);
      UserSession.id = user["id"] ?? "";
UserSession.name = user["name"] ?? "";
UserSession.email = user["email"] ?? "";
UserSession.role = user["role"] ?? "";
UserSession.branch = user["branch"] ?? "";
UserSession.year = user["year"] ?? "";
UserSession.token = result["token"] ?? "";

print("Stored User: ${UserSession.name}");
print("Branch: ${UserSession.branch}");
print("Year: ${UserSession.year}");
print("Token: ${UserSession.token}");

      if (user["role"] == "student") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const StudentDashboard(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminDashboard(),
          ),
        );
      }

    } else {
      _showMessage("Invalid Credentials");
    }

  } catch (e) {
    print(e);
    _showMessage("Cannot connect to backend");
  }
}
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = widget.role == "student";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
              ),

              const SizedBox(height: 28),

              Container(
                height: 74,
                width: 74,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  isStudent
                      ? Icons.person_rounded
                      : Icons.admin_panel_settings_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              const SizedBox(height: 28),

              Text(
                isStudent ? "Student Login" : "Admin Login",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                isStudent
                    ? "Access notices, deadlines and reminders."
                    : "Upload, review and publish academic notices.",
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textLight,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 34),

              _InputField(
                controller: emailController,
                label: "Email",
                hint: "Enter your email",
                icon: Icons.email_rounded,
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: isPasswordHidden,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  prefixIcon: const Icon(Icons.lock_rounded),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              GestureDetector(
                onTap: _login,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

if (isStudent)
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Don't have an account?",
        style: TextStyle(
          color: AppColors.textLight,
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegisterScreen(),
            ),
          );
        },
        child: const Text(
          "Create Account",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    ],
  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}