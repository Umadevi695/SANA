// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/notice_repository.dart';
import '../../models/notice_model.dart';

class ManageNoticesScreen extends StatefulWidget {
  const ManageNoticesScreen({super.key});

  @override
  State<ManageNoticesScreen> createState() => _ManageNoticesScreenState();
}

class _ManageNoticesScreenState extends State<ManageNoticesScreen> {
  String selectedCategory = "All";
  String searchQuery = "";

  List<NoticeModel> get notices =>
      List<NoticeModel>.from(NoticeRepository.approvedNotices);

  List<NoticeModel> get filteredNotices {
    return notices.where((notice) {
     final matchesCategory =
    selectedCategory == "All" ||
    notice.category.toLowerCase().contains(
      selectedCategory.toLowerCase(),
    );
      final query = searchQuery.toLowerCase();

      final matchesSearch =
          notice.title.toLowerCase().contains(query) ||
          notice.category.toLowerCase().contains(query) ||
          notice.date.toLowerCase().contains(query) ||
          notice.description.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _deleteNotice(NoticeModel notice) {
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
                _sheetHandle(),
                const SizedBox(height: 22),
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.urgent.withOpacity(0.12),
                  child: const Icon(
                    Icons.delete_rounded,
                    color: AppColors.urgent,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Delete Notice?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Are you sure you want to delete '${notice.title}'?",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.urgent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          NoticeRepository.deleteApprovedNotice(notice);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Delete",
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

  void _editNotice(NoticeModel notice) {
    final titleController = TextEditingController(text: notice.title);
    final descriptionController = TextEditingController(
      text: notice.description,
    );
    final dateController = TextEditingController(text: notice.date);
    String selectedEditCategory = notice.category;

    final categories = [
      "Exam",
      "Fee",
      "Assignment",
      "Scholarship",
      "Placement",
      "Event",
      "Other",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
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
                        _sheetHandle(),

                        const SizedBox(height: 22),

                        const Text(
                          "Edit Notice",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _EditInput(label: "Title", controller: titleController),

                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedEditCategory,
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(18),
                              items: categories.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value == null) return;

                                sheetSetState(() {
                                  selectedEditCategory = value;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        _EditInput(
                          label: "Description",
                          controller: descriptionController,
                          maxLines: 4,
                        ),

                        const SizedBox(height: 12),

                        _EditInput(
                          label: "Deadline",
                          controller: dateController,
                        ),

                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () {
                            final updatedTitle = titleController.text.trim();
                            final updatedDescription = descriptionController
                                .text
                                .trim();
                            final updatedDate = dateController.text.trim();

                            if (updatedTitle.isEmpty ||
                                updatedDescription.isEmpty ||
                                updatedDate.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "Please fill all fields before saving",
                                  ),
                                  backgroundColor: AppColors.urgent,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                              return;
                            }

                            final updatedNotice = notice.copyWith(
                              title: updatedTitle,
                              description: updatedDescription,
                              category: selectedEditCategory,
                              date: updatedDate,
                              isApproved: true,
                            );

                            NoticeRepository.updateApprovedNotice(
                              updatedNotice,
                            );

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "Notice updated successfully",
                                ),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Center(
                              child: Text(
                                "Save Changes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NoticeRepository.notifier,
      builder: (context, value, child) {
        final shownNotices = filteredNotices.reversed.toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Manage Notices",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "View, edit and remove published notices",
                    style: TextStyle(color: AppColors.textLight, fontSize: 14),
                  ),

                  const SizedBox(height: 22),

                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search notices...",
                      hintStyle: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textLight,
                      ),
                      filled: true,
                      fillColor: AppColors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    height: 38,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _Chip("All", selectedCategory, _selectCategory),
                        _Chip("Exam", selectedCategory, _selectCategory),
                        _Chip("Fee", selectedCategory, _selectCategory),
                        _Chip("Assignment", selectedCategory, _selectCategory),
                        _Chip("Placement", selectedCategory, _selectCategory),
                        _Chip("Event", selectedCategory, _selectCategory),
                        _Chip("Academic", selectedCategory, _selectCategory),
                        _Chip("Scholarship", selectedCategory, _selectCategory),
                        _Chip("Other", selectedCategory, _selectCategory),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  if (shownNotices.isEmpty)
                    const _EmptyState()
                  else
                    ...shownNotices.map(
                      (notice) => _AdminNoticeCard(
                        notice: notice,
                        onEdit: () => _editNotice(notice),
                        onDelete: () => _deleteNotice(notice),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final String selected;
  final void Function(String) onTap;

  const _Chip(this.label, this.selected, this.onTap);

  @override
  Widget build(BuildContext context) {
    final isSelected = label == selected;

    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textLight,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _AdminNoticeCard extends StatelessWidget {
  final NoticeModel notice;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AdminNoticeCard({
    required this.notice,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.success.withOpacity(0.12),
                child: const Icon(
                  Icons.verified_rounded,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  notice.title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            notice.description,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.category_rounded,
                color: AppColors.textLight,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  notice.category,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.textLight,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  notice.date,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  "Published",
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded),
                color: AppColors.primary,
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_rounded),
                color: AppColors.urgent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const _EditInput({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textLight),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, color: AppColors.textLight, size: 42),
          SizedBox(height: 12),
          Text(
            "No published notices found",
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Approved notices will appear here after review.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}

Widget _sheetHandle() {
  return Container(
    height: 5,
    width: 48,
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
