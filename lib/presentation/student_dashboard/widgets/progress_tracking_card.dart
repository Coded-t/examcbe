import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressTrackingCard extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final VoidCallback onViewDetails;

  const ProgressTrackingCard({
    Key? key,
    required this.courses,
    required this.onViewDetails,
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
                  iconName: 'trending_up',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Progress Tracking',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: onViewDetails,
                  child: Text('Details'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            courses.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courses.length > 4 ? 4 : courses.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 1.5.h),
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return _buildCourseProgress(course);
                    },
                  ),
            if (courses.isNotEmpty) ...[
              SizedBox(height: 2.h),
              _buildOverallProgress(),
            ],
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
            iconName: 'school_outlined',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No courses enrolled',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Enroll in courses to track your progress',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildCourseProgress(Map<String, dynamic> course) {
    final completionPercentage = course['completionPercentage'] as double;
    final completedExams = course['completedExams'] as int;
    final totalExams = course['totalExams'] as int;
    final averageScore = course['averageScore'] as double?;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['courseName'] as String,
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      course['courseCode'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildCompletionBadge(completionPercentage),
            ],
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: 'assignment_turned_in',
                  label: 'Completed',
                  value: '$completedExams/$totalExams',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
              SizedBox(width: 3.w),
              if (averageScore != null)
                Expanded(
                  child: _buildStatItem(
                    icon: 'grade',
                    label: 'Avg Score',
                    value: '${averageScore.toStringAsFixed(1)}%',
                    color: _getScoreColor(averageScore),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.5.h),
          _buildProgressBar(
            label: 'Course Progress',
            percentage: completionPercentage,
            color: _getProgressColor(completionPercentage),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionBadge(double percentage) {
    final isComplete = percentage >= 100;
    final color = isComplete
        ? AppTheme.lightTheme.colorScheme.tertiary
        : AppTheme.lightTheme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isComplete)
            CustomIconWidget(
              iconName: 'check_circle',
              color: color,
              size: 16,
            )
          else
            CustomIconWidget(
              iconName: 'schedule',
              color: color,
              size: 16,
            ),
          SizedBox(width: 1.w),
          Text(
            isComplete ? 'Complete' : '${percentage.toStringAsFixed(0)}%',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 20,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required double percentage,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium,
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Container(
          width: double.infinity,
          height: 0.8.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverallProgress() {
    final totalCourses = courses.length;
    final completedCourses = courses
        .where((course) => (course['completionPercentage'] as double) >= 100)
        .length;
    final overallProgress =
        totalCourses > 0 ? (completedCourses / totalCourses * 100) : 0.0;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'emoji_events',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Overall Academic Progress',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Expanded(
                child: _buildOverallStat(
                  label: 'Courses Completed',
                  value: '$completedCourses/$totalCourses',
                  icon: 'school',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildOverallStat(
                  label: 'Overall Progress',
                  value: '${overallProgress.toStringAsFixed(0)}%',
                  icon: 'trending_up',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverallStat({
    required String label,
    required String value,
    required String icon,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 90) return AppTheme.lightTheme.colorScheme.tertiary;
    if (percentage >= 70) return AppTheme.lightTheme.colorScheme.primary;
    if (percentage >= 50) return AppTheme.warningLight;
    return AppTheme.lightTheme.colorScheme.error;
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return AppTheme.lightTheme.colorScheme.tertiary;
    if (score >= 80) return AppTheme.lightTheme.colorScheme.primary;
    if (score >= 70) return AppTheme.warningLight;
    return AppTheme.lightTheme.colorScheme.error;
  }
}
