import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CourseCardWidget extends StatelessWidget {
  final Map<String, dynamic> course;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;

  const CourseCardWidget({
    Key? key,
    required this.course,
    this.onTap,
    this.onEdit,
    this.onArchive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String courseName = course['name'] as String? ?? '';
    final String courseCode = course['code'] as String? ?? '';
    final int studentCount = course['studentCount'] as int? ?? 0;
    final int examCount = course['examCount'] as int? ?? 0;
    final String status = course['status'] as String? ?? 'active';
    final DateTime lastActivity =
        course['lastActivity'] as DateTime? ?? DateTime.now();

    return Dismissible(
      key: Key(course['id']?.toString() ?? courseName),
      background: _buildSwipeBackground(true),
      secondaryBackground: _buildSwipeBackground(false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd && onEdit != null) {
          onEdit!();
        } else if (direction == DismissDirection.endToStart &&
            onArchive != null) {
          onArchive!();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.08),
                blurRadius: 6,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          courseName,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          courseCode,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(status),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      'people',
                      '$studentCount Students',
                      AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: _buildInfoItem(
                      'quiz',
                      '$examCount Exams',
                      AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Last activity: ${_formatLastActivity(lastActivity)}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(bool isLeftSwipe) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: isLeftSwipe
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment:
            isLeftSwipe ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeftSwipe ? 'edit' : 'archive',
                color: isLeftSwipe
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeftSwipe ? 'Edit' : 'Archive',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: isLeftSwipe
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    String displayStatus;

    switch (status.toLowerCase()) {
      case 'active':
        backgroundColor =
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.tertiary;
        displayStatus = 'Active';
        break;
      case 'archived':
        backgroundColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant
            .withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        displayStatus = 'Archived';
        break;
      case 'draft':
        backgroundColor =
            AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.error;
        displayStatus = 'Draft';
        break;
      default:
        backgroundColor =
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1);
        textColor = AppTheme.lightTheme.colorScheme.primary;
        displayStatus = status;
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

  Widget _buildInfoItem(String iconName, String text, Color color) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatLastActivity(DateTime lastActivity) {
    final now = DateTime.now();
    final difference = now.difference(lastActivity);

    if (difference.inDays > 7) {
      return '${lastActivity.day}/${lastActivity.month}/${lastActivity.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
