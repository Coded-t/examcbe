import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActiveExamsSection extends StatelessWidget {
  final List<Map<String, dynamic>> activeExams;
  final Function(Map<String, dynamic>) onExamTap;
  final Function(Map<String, dynamic>) onExamLongPress;

  const ActiveExamsSection({
    Key? key,
    required this.activeExams,
    required this.onExamTap,
    required this.onExamLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Exams',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              CustomIconWidget(
                iconName: 'timer',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          activeExams.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeExams.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
                  itemBuilder: (context, index) {
                    final exam = activeExams[index];
                    return _buildExamCard(context, exam);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'quiz',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 32,
          ),
          SizedBox(height: 1.h),
          Text(
            'No active exams',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Create an exam to get started',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, Map<String, dynamic> exam) {
    final String examName = exam['name'] as String? ?? '';
    final String courseName = exam['courseName'] as String? ?? '';
    final int participantCount = exam['participantCount'] as int? ?? 0;
    final DateTime endTime = exam['endTime'] as DateTime? ?? DateTime.now();
    final String status = exam['status'] as String? ?? 'active';

    final timeRemaining = endTime.difference(DateTime.now());
    final isExpiringSoon =
        timeRemaining.inHours < 1 && timeRemaining.inMinutes > 0;
    final isExpired = timeRemaining.isNegative;

    return GestureDetector(
      onTap: () => onExamTap(exam),
      onLongPress: () => onExamLongPress(exam),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          border: Border.all(
            color: isExpired
                ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3)
                : isExpiringSoon
                    ? AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        examName,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        courseName,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(status, isExpired, isExpiringSoon),
              ],
            ),
            SizedBox(height: 1.5.h),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'people',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '$participantCount participants',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: isExpired
                          ? AppTheme.lightTheme.colorScheme.error
                          : isExpiringSoon
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _formatTimeRemaining(timeRemaining),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isExpired
                            ? AppTheme.lightTheme.colorScheme.error
                            : isExpiringSoon
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: isExpiringSoon || isExpired
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, bool isExpired, bool isExpiringSoon) {
    Color backgroundColor;
    Color textColor;
    String displayStatus;

    if (isExpired) {
      backgroundColor =
          AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
      textColor = AppTheme.lightTheme.colorScheme.error;
      displayStatus = 'Expired';
    } else if (isExpiringSoon) {
      backgroundColor =
          AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
      textColor = AppTheme.lightTheme.colorScheme.error;
      displayStatus = 'Expiring Soon';
    } else {
      backgroundColor =
          AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
      textColor = AppTheme.lightTheme.colorScheme.tertiary;
      displayStatus = 'Active';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        displayStatus,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatTimeRemaining(Duration timeRemaining) {
    if (timeRemaining.isNegative) {
      return 'Expired';
    } else if (timeRemaining.inDays > 0) {
      return '${timeRemaining.inDays}d ${timeRemaining.inHours % 24}h left';
    } else if (timeRemaining.inHours > 0) {
      return '${timeRemaining.inHours}h ${timeRemaining.inMinutes % 60}m left';
    } else if (timeRemaining.inMinutes > 0) {
      return '${timeRemaining.inMinutes}m left';
    } else {
      return 'Ending soon';
    }
  }
}
