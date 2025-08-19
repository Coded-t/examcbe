import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AvailableExamsCard extends StatelessWidget {
  final List<Map<String, dynamic>> exams;
  final Function(Map<String, dynamic>) onExamTap;
  final Function(Map<String, dynamic>) onStartExam;

  const AvailableExamsCard({
    Key? key,
    required this.exams,
    required this.onExamTap,
    required this.onStartExam,
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
                  iconName: 'assignment',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Available Exams',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            exams.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exams.length > 3 ? 3 : exams.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final exam = exams[index];
                      return _buildExamItem(context, exam);
                    },
                  ),
            if (exams.length > 3) ...[
              SizedBox(height: 1.h),
              TextButton(
                onPressed: () {
                  // Navigate to full exams list
                },
                child: Text('View All Exams (${exams.length})'),
              ),
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
            iconName: 'assignment_outlined',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No exams available',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Check back later for new assignments',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildExamItem(BuildContext context, Map<String, dynamic> exam) {
    final isOverdue = (exam['deadline'] as DateTime).isBefore(DateTime.now());
    final timeRemaining = _getTimeRemaining(exam['deadline'] as DateTime);

    return Dismissible(
      key: Key('exam_${exam['id']}'),
      direction: DismissDirection.startToEnd,
      background: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'play_arrow',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Start Exam',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        onStartExam(exam);
      },
      child: GestureDetector(
        onTap: () => onExamTap(exam),
        onLongPress: () => _showExamOptions(context, exam),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOverdue
                  ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3)
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
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
                          exam['title'] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          exam['courseName'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildDifficultyIndicator(exam['difficulty'] as String),
                ],
              ),
              SizedBox(height: 1.5.h),
              Row(
                children: [
                  _buildInfoChip(
                    icon: 'schedule',
                    label: '${exam['duration']} min',
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(width: 2.w),
                  _buildInfoChip(
                    icon: 'quiz',
                    label: '${exam['questionCount']} questions',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOverdue ? 'Overdue' : 'Due: $timeRemaining',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isOverdue
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                isOverdue ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        if (exam['attemptStatus'] != null) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            exam['attemptStatus'] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: _getAttemptStatusColor(
                                  exam['attemptStatus'] as String),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!isOverdue && exam['attemptStatus'] != 'Completed')
                    ElevatedButton(
                      onPressed: () => onStartExam(exam),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        minimumSize: Size(0, 5.h),
                      ),
                      child: Text('Start'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator(String difficulty) {
    Color color;
    IconData icon;

    switch (difficulty.toLowerCase()) {
      case 'easy':
        color = AppTheme.lightTheme.colorScheme.tertiary;
        icon = Icons.circle;
        break;
      case 'medium':
        color = AppTheme.warningLight;
        icon = Icons.circle;
        break;
      case 'hard':
        color = AppTheme.lightTheme.colorScheme.error;
        icon = Icons.circle;
        break;
      default:
        color = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        icon = Icons.circle_outlined;
    }

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
          Icon(icon, color: color, size: 12),
          SizedBox(width: 1.w),
          Text(
            difficulty,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required String icon,
    required String label,
    required Color color,
  }) {
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
            iconName: icon,
            color: color,
            size: 14,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeRemaining(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.isNegative) return 'Overdue';

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}';
    } else {
      return '${difference.inMinutes} min';
    }
  }

  Color _getAttemptStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'in progress':
        return AppTheme.warningLight;
      case 'not started':
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  void _showExamOptions(BuildContext context, Map<String, dynamic> exam) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('View Instructions'),
              onTap: () {
                Navigator.pop(context);
                // Handle view instructions
              },
            ),
            if (exam['practiceMode'] == true)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'school',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 24,
                ),
                title: Text('Practice Mode'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle practice mode
                },
              ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bookmark_border',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              title: Text('Bookmark for Later'),
              onTap: () {
                Navigator.pop(context);
                // Handle bookmark
              },
            ),
          ],
        ),
      ),
    );
  }
}
