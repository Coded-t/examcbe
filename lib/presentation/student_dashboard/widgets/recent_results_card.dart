import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentResultsCard extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final VoidCallback onViewAll;

  const RecentResultsCard({
    Key? key,
    required this.results,
    required this.onViewAll,
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
                  iconName: 'assessment',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Recent Results',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: Text('View All'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            results.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: results.length > 3 ? 3 : results.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return _buildResultItem(result);
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
            iconName: 'assessment_outlined',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No results yet',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Complete an exam to see your results',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(Map<String, dynamic> result) {
    final score = result['score'] as double;
    final maxScore = result['maxScore'] as double;
    final percentage = (score / maxScore * 100).round();
    final grade = _getGrade(percentage);
    final improvement = result['improvement'] as double?;

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
                      result['examTitle'] as String,
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      result['courseName'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildGradeBadge(grade, percentage),
            ],
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Score: ${score.toStringAsFixed(1)}/${maxScore.toStringAsFixed(1)}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Completed: ${_formatDate(result['completedAt'] as DateTime)}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (improvement != null) _buildImprovementIndicator(improvement),
            ],
          ),
          SizedBox(height: 1.h),
          _buildScoreProgressBar(percentage),
        ],
      ),
    );
  }

  Widget _buildGradeBadge(String grade, int percentage) {
    Color color;
    switch (grade) {
      case 'A':
        color = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case 'B':
        color = AppTheme.lightTheme.colorScheme.primary;
        break;
      case 'C':
        color = AppTheme.warningLight;
        break;
      case 'D':
        color = AppTheme.lightTheme.colorScheme.error;
        break;
      default:
        color = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            grade,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$percentage%',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementIndicator(double improvement) {
    final isPositive = improvement > 0;
    final color = isPositive
        ? AppTheme.lightTheme.colorScheme.tertiary
        : AppTheme.lightTheme.colorScheme.error;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: isPositive ? 'trending_up' : 'trending_down',
            color: color,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            '${isPositive ? '+' : ''}${improvement.toStringAsFixed(1)}%',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreProgressBar(int percentage) {
    Color color;
    if (percentage >= 90) {
      color = AppTheme.lightTheme.colorScheme.tertiary;
    } else if (percentage >= 80) {
      color = AppTheme.lightTheme.colorScheme.primary;
    } else if (percentage >= 70) {
      color = AppTheme.warningLight;
    } else {
      color = AppTheme.lightTheme.colorScheme.error;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Performance',
              style: AppTheme.lightTheme.textTheme.labelMedium,
            ),
            Text(
              '$percentage%',
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

  String _getGrade(int percentage) {
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'F';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
