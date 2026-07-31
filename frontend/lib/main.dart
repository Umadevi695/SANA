import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'screens/role_selection/role_selection_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/fcm_service.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FCMService.initialize();

  runApp(const SmartNoticeApp());
}

class SmartNoticeApp extends StatelessWidget {
  const SmartNoticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Notice Analyzer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: const RoleSelectionScreen(),
    );
  }
}
