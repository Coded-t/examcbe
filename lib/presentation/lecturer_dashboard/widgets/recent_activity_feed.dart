import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityFeed extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const RecentActivityFeed({
    Key? key,
    required this.activities,
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
                'Recent Activity',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          activities.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activities.length > 5 ? 5 : activities.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return _buildActivityItem(activity);
                  },
                ),
          if (activities.length > 5) ...[
            SizedBox(height: 1.h),
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to full activity log
                },
                child: Text(
                  'View All Activities',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
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
            iconName: 'inbox',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 32,
          ),
          SizedBox(height: 1.h),
          Text(
            'No recent activity',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final String type = activity['type'] as String? ?? '';
    final String studentName = activity['studentName'] as String? ?? '';
    final String courseName = activity['courseName'] as String? ?? '';
    final String examName = activity['examName'] as String? ?? '';
    final DateTime timestamp =
        activity['timestamp'] as DateTime? ?? DateTime.now();

    String iconName;
    Color iconColor;
    String description;

    switch (type) {
      case 'submission':
        iconName = 'assignment_turned_in';
        iconColor = AppTheme.lightTheme.colorScheme.tertiary;
        description = '$studentName submitted $examName';
        break;
      case 'completion':
        iconName = 'check_circle';
        iconColor = AppTheme.lightTheme.colorScheme.tertiary;
        description = '$studentName completed $examName';
        break;
      case 'enrollment':
        iconName = 'person_add';
        iconColor = AppTheme.lightTheme.colorScheme.secondary;
        description = '$studentName enrolled in $courseName';
        break;
      default:
        iconName = 'info';
        iconColor = AppTheme.lightTheme.colorScheme.primary;
        description = 'Unknown activity';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: iconName,
              color: iconColor,
              size: 16,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                _formatTimestamp(timestamp),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
