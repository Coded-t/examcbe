import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UpcomingDeadlinesCard extends StatelessWidget {
  final List<Map<String, dynamic>> deadlines;
  final Function(Map<String, dynamic>) onDeadlineTap;

  const UpcomingDeadlinesCard({
    Key? key,
    required this.deadlines,
    required this.onDeadlineTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.warningLight,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Upcoming Deadlines',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            deadlines.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: deadlines.length > 5 ? 5 : deadlines.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final deadline = deadlines[index];
                      return _buildDeadlineItem(deadline);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'event_available',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No upcoming deadlines',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'You\'re all caught up!',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem(Map<String, dynamic> deadline) {
    final dueDate = deadline['dueDate'] as DateTime;
    final timeRemaining = _getTimeRemaining(dueDate);
    final urgency = _getUrgency(dueDate);
    final isOverdue = dueDate.isBefore(DateTime.now());

    return GestureDetector(
      onTap: () => onDeadlineTap(deadline),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getUrgencyColor(urgency).withValues(alpha: 0.3),
            width: isOverdue ? 2 : 1,
          ),
          boxShadow: isOverdue
              ? [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 8.h,
              decoration: BoxDecoration(
                color: _getUrgencyColor(urgency),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          deadline['examTitle'] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildUrgencyBadge(urgency, isOverdue),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    deadline['courseName'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'access_time',
                        color: _getUrgencyColor(urgency),
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        isOverdue ? 'Overdue' : timeRemaining,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: _getUrgencyColor(urgency),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDueDate(dueDate),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),
            _buildCountdownTimer(dueDate, urgency),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgencyBadge(String urgency, bool isOverdue) {
    final color = _getUrgencyColor(urgency);
    final text = isOverdue ? 'OVERDUE' : urgency.toUpperCase();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildCountdownTimer(DateTime dueDate, String urgency) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    final isOverdue = difference.isNegative;

    if (isOverdue) {
      return Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: 'warning',
          color: AppTheme.lightTheme.colorScheme.error,
          size: 24,
        ),
      );
    }

    String timeText;
    if (difference.inDays > 0) {
      timeText = '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      timeText = '${difference.inHours}h';
    } else {
      timeText = '${difference.inMinutes}m';
    }

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: _getUrgencyColor(urgency).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'timer',
            color: _getUrgencyColor(urgency),
            size: 20,
          ),
          SizedBox(height: 0.5.h),
          Text(
            timeText,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: _getUrgencyColor(urgency),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeRemaining(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) return 'Overdue';

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} remaining';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} remaining';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} remaining';
    }
  }

  String _getUrgency(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) return 'overdue';
    if (difference.inHours <= 2) return 'critical';
    if (difference.inHours <= 24) return 'urgent';
    if (difference.inDays <= 3) return 'moderate';
    return 'low';
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'overdue':
      case 'critical':
        return AppTheme.lightTheme.colorScheme.error;
      case 'urgent':
        return AppTheme.warningLight;
      case 'moderate':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'low':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}
