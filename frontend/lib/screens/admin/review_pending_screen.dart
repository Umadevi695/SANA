// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/notice_repository.dart';
import '../../models/notice_model.dart';

class ReviewPendingScreen extends StatefulWidget {
  const ReviewPendingScreen({super.key});

  @override
  State<ReviewPendingScreen> createState() => _ReviewPendingScreenState();
}

class _ReviewPendingScreenState extends State<ReviewPendingScreen> {
  void _approveNotice(NoticeModel notice) {
    NoticeRepository.approveNotice(notice);
    _showSnackBar('Notice approved successfully', Colors.green);
  }

  void _rejectNotice(NoticeModel notice) {
    NoticeRepository.rejectNotice(notice);
    _showSnackBar('Notice rejected', Colors.red);
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const Text(
          'Review Pending Notices',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: NoticeRepository.notifier,
        builder: (context, value, child) {
          final pendingNotices = NoticeRepository.pendingNotices.reversed
              .toList();

          if (pendingNotices.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            itemCount: pendingNotices.length,
            itemBuilder: (context, index) {
              final notice = pendingNotices[index];

              return KeyedSubtree(
                key: ValueKey(notice.id),
                child: _buildNoticeCard(notice),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNoticeCard(NoticeModel notice) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: AppColors.warning.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.warning.withOpacity(0.12),
                child: const Icon(
                  Icons.pending_actions_rounded,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  notice.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            notice.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.textLight,
            ),
          ),

          const SizedBox(height: 14),

          _infoRow(Icons.category_rounded, 'Category', notice.category),
          const SizedBox(height: 8),
          _infoRow(Icons.calendar_today_rounded, 'Date', notice.date),
          const SizedBox(height: 8),
          _infoRow(Icons.hourglass_top_rounded, 'Status', 'Pending Review'),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _approveNotice(notice),
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Approve'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _rejectNotice(notice),
                  icon: const Icon(Icons.cancel_rounded),
                  label: const Text('Reject'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade800),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_rounded,
              size: 90,
              color: AppColors.primary.withOpacity(0.8),
            ),
            const SizedBox(height: 18),
            const Text(
              'All Clear!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No pending notices are waiting for review.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
