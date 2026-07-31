// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../data/notice_repository.dart';
import '../../models/notice_model.dart';
//import '../../services/api_service.dart';
import 'pdf_viewer_screen.dart';
import 'image_viewer_screen.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  String selectedCategory = "All";
  String searchQuery = "";

Future<void> _openFile(String fileName) async {
  final url = "http://10.0.2.2:5000/uploads/$fileName";

  /*print("OPENING URL: $url");

  final uri = Uri.parse(url);

  await launchUrl(
    uri,
    mode: LaunchMode.inAppBrowserView,
  );*/
   
     if (fileName.toLowerCase().endsWith(".pdf")) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerScreen(
          pdfUrl: url,
        ),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageViewerScreen(
          imageUrl: url,
        ),
      ),
    );
  }

}
  List<NoticeModel> get filteredNotices {
    return NoticeRepository.approvedNotices
        .where((notice) {
          final matchesCategory =
    selectedCategory == "All" ||
    notice.category.toLowerCase().contains(
      selectedCategory.toLowerCase(),
    );

          final query = searchQuery.toLowerCase();

          final matchesSearch =
              notice.title.toLowerCase().contains(query) ||
              notice.category.toLowerCase().contains(query) ||
              notice.description.toLowerCase().contains(query) ||
              notice.date.toLowerCase().contains(query) ||
              notice.attachmentName.toLowerCase().contains(query);

          return matchesCategory && matchesSearch;
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NoticeRepository.notifier,
      builder: (context, value, child) {
        final displayedNotices = filteredNotices;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Academic Notices",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              


              const SizedBox(height: 6),

              const Text(
                "Stay updated with important academic announcements",
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryChip(
                      label: "All",
                      isSelected: selectedCategory == "All",
                      onTap: () => _selectCategory("All"),
                    ),
                    _CategoryChip(
                      label: "Fee",
                      isSelected: selectedCategory == "Fee",
                      onTap: () => _selectCategory("Fee"),
                    ),
                    _CategoryChip(
                      label: "Scholarship",
                      isSelected: selectedCategory == "Scholarship",
                      onTap: () => _selectCategory("Scholarship"),
                    ),
                    _CategoryChip(
                      label: "Transport",
                      isSelected: selectedCategory == "Transport",
                      onTap: () => _selectCategory("Transport"),
                    ),
                    _CategoryChip(
                      label: "Assignment",
                      isSelected: selectedCategory == "Assignment",
                      onTap: () => _selectCategory("Assignment"),
                    ),
                    _CategoryChip(
                      label: "Placement",
                      isSelected: selectedCategory == "Placement",
                      onTap: () => _selectCategory("Placement"),
                    ),
                    _CategoryChip(
                      label: "Event",
                      isSelected: selectedCategory == "Event",
                      onTap: () => _selectCategory("Event"),
                    ),
                    _CategoryChip(
                      label: "Other",
                      isSelected: selectedCategory == "Other",
                      onTap: () => _selectCategory("Other"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              if (displayedNotices.isEmpty)
                const _EmptyState()
              else
                ...displayedNotices.map(
                  (notice) => _NoticeCard(
                    notice: notice,
                    onTap: () => _showNoticeDetails(context, notice),
                  ),
                ),

              const SizedBox(height: 90),
            ],
          ),
        );
      },
    );
  }

  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _showNoticeDetails(BuildContext context, NoticeModel notice) {
    NoticeRepository.markAsRead(notice);

    final latestNotice = NoticeRepository.approvedNotices.firstWhere(
      (item) => item.id == notice.id,
      orElse: () => notice,
    );

    final color = _categoryColor(latestNotice.category);
    final icon = _categoryIcon(latestNotice.category);
    final priority = _priorityFromCategory(latestNotice.category);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: color.withOpacity(0.12),
                        child: Icon(icon, color: color, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          latestNotice.title,
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

                  const SizedBox(height: 18),

                  Text(
                    "${latestNotice.category} Department • Recently Published",
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      _InfoBadge(label: latestNotice.category, color: color),
                      const SizedBox(width: 10),
                      _InfoBadge(
                        label: priority,
                        color: priority == "High"
                            ? AppColors.urgent
                            : AppColors.warning,
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    "AI Summary",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    latestNotice.description,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      height: 1.5,
                    ),
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
                        const Icon(
                          Icons.calendar_month_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Extracted Deadline: ${latestNotice.date}",
                            style: const TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.picture_as_pdf_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            latestNotice.attachmentName,
                            style: const TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

  GestureDetector(
  onTap: () {
    NoticeRepository.markAsDownloaded(latestNotice);

    final fileName = latestNotice.attachmentName;

    Navigator.pop(context);

    Future.delayed(const Duration(milliseconds: 300), () {
      _openFile(fileName);
    });
  },
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.22),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: const Center(
      child: Text(
        "View Notice",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  ),
),     
const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final NoticeModel notice;
  final VoidCallback onTap;

  const _NoticeCard({required this.notice, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(notice.category);
    final icon = _categoryIcon(notice.category);
    final isRead = notice.isRead == true;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isRead
                ? Colors.transparent
                : AppColors.primary.withOpacity(0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: isRead
                  ? Colors.black.withOpacity(0.05)
                  : AppColors.primary.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color, size: 24),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
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
                      if (!isRead) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.urgent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "NEW",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    notice.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (notice.attachmentName != "No attachment")
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_file_rounded,
                          color: AppColors.textLight,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            notice.attachmentName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textLight,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          notice.category,
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          notice.date,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.keyboard_arrow_up_rounded,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoBadge({required this.label, required this.color});

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
          Icon(Icons.search_off_rounded, size: 42, color: AppColors.textLight),
          SizedBox(height: 12),
          Text(
            "No notices found",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Approved notices from admin will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}

Color _categoryColor(String category) {
  switch (category) {
    case "Exam":
      return Colors.blue;

    case "Fee":
    case "Fee Payment":
      return Colors.orange;

    case "Event":
      return Colors.green;

    case "Assignment":
      return Colors.purple;

    case "Placement":
      return Colors.teal;

    case "Scholarship":
      return Colors.indigo;

    default:
      return AppColors.primary;
  }
}

IconData _categoryIcon(String category) {
  switch (category) {
    case "Exam":
      return Icons.assignment_rounded;
    case "Fee":  
    case "Fee Payment":
      return Icons.payments_rounded;
    case "Event":
      return Icons.event_rounded;
    case "Assignment":
      return Icons.task_alt_rounded;
    case "Placement":
      return Icons.work_rounded;
    case "Scholarship":
      return Icons.school_rounded;
    default:
      return Icons.description_rounded;
  }
}

String _priorityFromCategory(String category) {
  final urgentCategories = ["Exam", "Fee", "Assignment"];
  return urgentCategories.contains(category) ? "High" : "Medium";
}
