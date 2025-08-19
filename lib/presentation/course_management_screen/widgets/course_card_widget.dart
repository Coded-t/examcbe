import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class CourseCardWidget extends StatelessWidget {
  final Map<String, dynamic> course;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final VoidCallback? onSettings;
  final VoidCallback? onShare;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  const CourseCardWidget({
    Key? key,
    required this.course,
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onSettings,
    this.onShare,
    this.onArchive,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = course['title'] as String? ?? '';
    final String code = course['code'] as String? ?? '';
    final String description = course['description'] as String? ?? '';
    final int studentCount = course['studentCount'] as int? ?? 0;
    final DateTime createdDate =
        course['createdDate'] as DateTime? ?? DateTime.now();
    final String status = course['status'] as String? ?? 'draft';
    final String enrollmentSettings =
        course['enrollmentSettings'] as String? ?? 'open';

    return Dismissible(
      key: Key(course['id']?.toString() ?? title),
      background: _buildSwipeBackground(true),
      secondaryBackground: _buildSwipeBackground(false),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Right swipe - Edit/Settings/Share
          _showRightSwipeOptions(context);
          return false;
        } else {
          // Left swipe - Archive/Delete
          _showLeftSwipeOptions(context);
          return false;
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 2.h),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            code,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(status),
                ],
              ),
              if (description.isNotEmpty) ...[
                SizedBox(height: 1.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
                      'settings',
                      _getEnrollmentText(enrollmentSettings),
                      _getEnrollmentColor(enrollmentSettings),
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
                        'Created ${_formatDate(createdDate)}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: onLongPress,
                    child: CustomIconWidget(
                      iconName: 'more_vert',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
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
    final List<Map<String, dynamic>> actions = isLeftSwipe
        ? [
            {'icon': 'edit', 'label': 'Edit', 'color': Colors.blue},
            {'icon': 'settings', 'label': 'Settings', 'color': Colors.orange},
            {'icon': 'share', 'label': 'Share', 'color': Colors.green},
          ]
        : [
            {'icon': 'archive', 'label': 'Archive', 'color': Colors.grey},
            {'icon': 'delete', 'label': 'Delete', 'color': Colors.red},
          ];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
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
        children: actions
            .map((action) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color:
                              (action['color'] as Color).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: action['icon'] as String,
                          color: action['color'] as Color,
                          size: 20,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        action['label'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: action['color'] as Color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  void _showRightSwipeOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildBottomSheetOption('Edit Course', 'edit', onEdit),
            _buildBottomSheetOption('Course Settings', 'settings', onSettings),
            _buildBottomSheetOption('Share Course', 'share', onShare),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showLeftSwipeOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            if (course['status'] == 'active')
              _buildBottomSheetOption('Archive Course', 'archive', onArchive),
            _buildBottomSheetOption('Delete Course', 'delete', onDelete,
                isDestructive: true),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption(
      String title, String iconName, VoidCallback? onTap,
      {bool isDestructive = false}) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDestructive ? AppTheme.lightTheme.colorScheme.error : null,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
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
        borderRadius: BorderRadius.circular(6),
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

  String _getEnrollmentText(String enrollmentSettings) {
    switch (enrollmentSettings.toLowerCase()) {
      case 'open':
        return 'Open Enrollment';
      case 'restricted':
        return 'Restricted';
      case 'closed':
        return 'Closed';
      default:
        return 'Open Enrollment';
    }
  }

  Color _getEnrollmentColor(String enrollmentSettings) {
    switch (enrollmentSettings.toLowerCase()) {
      case 'open':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'restricted':
        return Colors.orange;
      case 'closed':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.tertiary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}