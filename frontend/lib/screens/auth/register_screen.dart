import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String selectedBranch = "CSE";
  String selectedYear = "1";

  final List<String> branches = [
    "CSE",
    "ECE",
    "EEE",
    "MECH",
    "CIVIL",
  ];

  final List<String> years = [
    "1",
    "2",
    "3",
    "4",
  ];

  bool isLoading = false;

  Future<void> register() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await AuthService.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        selectedBranch,
        selectedYear,
      );

      if (result["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration Successful"),
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result["message"] ?? "Registration Failed"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
Widget build(BuildContext context) {
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

        const SizedBox(height: 20),

        Container(
          height: 74,
          width: 74,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.person_add_alt_1_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),

        const SizedBox(height: 28),

        const Text(
          "Create Account",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.textDark,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          "Register to receive academic notices, reminders and updates.",
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textLight,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 30),

        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: "Full Name",
            prefixIcon: const Icon(Icons.person_rounded),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email",
            prefixIcon: const Icon(Icons.email_rounded),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Password",
            prefixIcon: const Icon(Icons.lock_rounded),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          value: selectedBranch,
          decoration: InputDecoration(
            labelText: "Branch",
            prefixIcon: const Icon(Icons.school_rounded),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
          items: branches.map((branch) {
            return DropdownMenuItem(
              value: branch,
              child: Text(branch),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedBranch = value!;
            });
          },
        ),

        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          value: selectedYear,
          decoration: InputDecoration(
            labelText: "Year",
            prefixIcon: const Icon(Icons.calendar_today_rounded),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
          items: years.map((year) {
            return DropdownMenuItem(
              value: year,
              child: Text("Year $year"),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedYear = value!;
            });
          },
        ),

        const SizedBox(height: 30),

        GestureDetector(
          onTap: isLoading ? null : register,
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
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      "Create Account",
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

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account?",
              style: TextStyle(
                color: AppColors.textLight,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Login"),
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