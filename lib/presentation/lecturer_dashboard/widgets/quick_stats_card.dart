import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsCard extends StatelessWidget {
  final int totalCourses;
  final int activeExams;
  final int studentCount;
  final VoidCallback? onTap;

  const QuickStatsCard({
    Key? key,
    required this.totalCourses,
    required this.activeExams,
    required this.studentCount,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  'Quick Stats',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'analytics',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Courses',
                    totalCourses.toString(),
                    'school',
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 6.h,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Active Exams',
                    activeExams.toString(),
                    'quiz',
                    AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 6.h,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Students',
                    studentCount.toString(),
                    'people',
                    AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, String iconName, Color color) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
