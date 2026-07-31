// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_colors.dart';
import '../../services/api_service.dart';
import '../../services/user_session.dart';
import '../../widgets/multi_select_field.dart';

class UploadNoticeScreen extends StatefulWidget {
  const UploadNoticeScreen({super.key});

  @override
  State<UploadNoticeScreen> createState() => _UploadNoticeScreenState();
}

class _UploadNoticeScreenState extends State<UploadNoticeScreen> {
  String selectedCategory = "Exam";

  DateTime? selectedDeadline;

  String selectedFileName = "No file selected";

  File? selectedFile;

  final TextEditingController titleController =
      TextEditingController();

  // ---------------- Categories ----------------

  final List<String> categories = [
    "Exam",
    "Examination Schedule",
    "Fee Payment",
    "Scholarship",
    "Assignment",
    "Project",
    "Project Review",
    "Seminar",
    "Workshop",
    "Internship",
    "Placement",
    "Training",
    "Hackathon",
    "Transport",
    "Library",
    "Hostel",
    "Sports",
    "Cultural Event",
    "Club Activity",
    "Industrial Visit",
    "Academic Calendar",
    "Holiday",
    "NSS/NCC",
    "General Notice",
    "Other",
  ];

  // ---------------- Branch ----------------

  List<String> selectedBranches = [];

  final List<String> branches = [
    "ALL",
    "CSE",
    "CSM",
    "CSD",
    "AI&ML",
    "AIDS",
    "ECE",
    "EEE",
    "MECH",
    "CIVIL",
  ];

  // ---------------- Year ----------------

  List<String> selectedYears = [];

  final List<String> years = [
    "ALL",
    "1st Year",
    "2nd Year",
    "3rd Year",
    "4th Year",
  ];

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------

  Future<void> _pickDeadline() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 3),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDeadline = pickedDate;
      });
    }
  }

  // -------------------------------------------------------------

  Future<void> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        selectedFileName = result.files.single.name;
      });
    }
  }

  // -------------------------------------------------------------

  String _formattedDeadline() {
    if (selectedDeadline == null) {
      return "Select deadline";
    }

    return "${selectedDeadline!.day}/${selectedDeadline!.month}/${selectedDeadline!.year}";
  }

  // -------------------------------------------------------------

  Future<void> _publishNotice() async {
    if (selectedFile == null) {
      _showSnackBar(
        "Please select a notice file",
        AppColors.urgent,
      );
      return;
    }

    if (selectedBranches.isEmpty) {
      _showSnackBar(
        "Please select at least one branch",
        Colors.red,
      );
      return;
    }

    if (selectedYears.isEmpty) {
      _showSnackBar(
        "Please select at least one year",
        Colors.red,
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
          "${ApiService.baseUrl}/notices/upload",
        ),
      );

      request.headers["Authorization"] =
          "Bearer ${UserSession.token}";

      request.files.add(
        await http.MultipartFile.fromPath(
          "noticeFile",
          selectedFile!.path,
        ),
      );

      // ---------- Admin Inputs ----------

      request.fields["title"] =
          titleController.text.trim();

      request.fields["category"] =
          selectedCategory;

      request.fields["branch"] =
          selectedBranches.join(",");

      request.fields["year"] =
          selectedYears.join(",");

      if (selectedDeadline != null) {
        request.fields["deadline"] =
            selectedDeadline!
                .toIso8601String();
      }

      var response = await request.send();

      String responseBody =
          await response.stream.bytesToString();

      print(response.statusCode);
      print(responseBody);

     if (response.statusCode == 201) {
  _showSnackBar(
    "Notice uploaded successfully",
    Colors.green,
  );

  _showSuccessSheet();
} else if (response.statusCode == 409) {
  _showSnackBar(
    "This notice has already been uploaded.",
    Colors.orange,
  );
} else {
  _showSnackBar(
    "Upload Failed",
    Colors.red,
  );
}
    } catch (e) {
      print(e);

      _showSnackBar(
        "Server Error",
        Colors.red,
      );
    }
  }

  // -------------------------------------------------------------

  void _showSnackBar(
    String message,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior:
            SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    );
  }

  // -------------------------------------------------------------

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: AppColors.card,
            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(.12),
                    borderRadius:
                        BorderRadius.circular(
                            20),
                  ),
                ),

                const SizedBox(height: 22),

                CircleAvatar(
                  radius: 36,
                  backgroundColor:
                      AppColors.success
                          .withOpacity(.12),
                  child: const Icon(
                    Icons
                        .check_circle_rounded,
                    size: 42,
                    color:
                        AppColors.success,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Notice Uploaded Successfully",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Students will receive this notice according to the selected branches and years.",
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    color:
                        AppColors.textLight,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------------- Header ----------------

              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      "Upload Notice",
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              const Text(
                "Create and send academic notices for students",
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              // ---------------- Title ----------------

              const _InputLabel("Notice Title"),

              _TextInput(
                controller: titleController,
                hintText: "Enter notice title",
              ),

              const SizedBox(height: 18),

              // ---------------- Category ----------------

              const _InputLabel("Category"),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(18),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ---------------- Branch ----------------

              const _InputLabel("Branches"),

              MultiSelectField(
                title: "Branches",
                items: branches,
                selectedItems: selectedBranches,
                onSelectionChanged: (values) {
                  setState(() {
                    selectedBranches = values;
                  });
                },
              ),

              const SizedBox(height: 18),

              // ---------------- Year ----------------

              const _InputLabel("Years"),

              MultiSelectField(
                title: "Years",
                items: years,
                selectedItems: selectedYears,
                onSelectionChanged: (values) {
                  setState(() {
                    selectedYears = values;
                  });
                },
              ),

              const SizedBox(height: 18),

              // ---------------- Deadline ----------------

              const _InputLabel("Deadline"),

              GestureDetector(
                onTap: _pickDeadline,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formattedDeadline(),
                        style: TextStyle(
                          color: selectedDeadline == null
                              ? AppColors.textLight
                              : AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ---------------- Attachment ----------------

              const _InputLabel("Attachment"),

              GestureDetector(
                onTap: pickFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            AppColors.primary.withOpacity(.12),
                        child: const Icon(
                          Icons.attach_file_rounded,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          selectedFileName,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.upload_file_rounded,
                        color: AppColors.textLight,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ---------------- Upload Button ----------------

              GestureDetector(
                onTap: _publishNotice,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:
                            AppColors.primary.withOpacity(.25),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Upload Notice",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------

class _InputLabel extends StatelessWidget {
  final String label;

  const _InputLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );
  }
}

// -------------------------------------------------------------

class _TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const _TextInput({
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.textLight,
          fontSize: 14,
        ),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(18),
      ),
    );
  }
}
