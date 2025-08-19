import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuestionCardWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onPreview;
  final VoidCallback? onDelete;
  final bool isSelected;
  final VoidCallback? onLongPress;

  const QuestionCardWidget({
    Key? key,
    required this.question,
    this.onTap,
    this.onEdit,
    this.onDuplicate,
    this.onPreview,
    this.onDelete,
    this.isSelected = false,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String questionText = question['questionText'] ?? '';
    final String questionType = question['type'] ?? 'Multiple Choice';
    final String difficulty = question['difficulty'] ?? 'Medium';
    final int usageCount = question['usageCount'] ?? 0;
    final bool isUsedInActiveExam = question['isUsedInActiveExam'] ?? false;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: isSelected ? 4.0 : 2.0,
        color: isSelected
            ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: isSelected
              ? BorderSide(color: AppTheme.lightTheme.primaryColor, width: 2.0)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question text with truncation
                Text(
                  questionText.length > 120
                      ? '${questionText.substring(0, 120)}...'
                      : questionText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),

                // Question metadata row
                Row(
                  children: [
                    // Question type chip
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'quiz',
                            size: 16,
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            questionType,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppTheme.lightTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 2.w),

                    // Difficulty chip
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(difficulty)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: _getDifficultyIcon(difficulty),
                            size: 16,
                            color: _getDifficultyColor(difficulty),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            difficulty,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: _getDifficultyColor(difficulty),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Usage count with warning if used in active exam
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: isUsedInActiveExam
                            ? AppTheme.warningLight.withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: isUsedInActiveExam
                              ? AppTheme.warningLight
                              : AppTheme.lightTheme.colorScheme.outline,
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isUsedInActiveExam) ...[
                            CustomIconWidget(
                              iconName: 'warning',
                              size: 14,
                              color: AppTheme.warningLight,
                            ),
                            SizedBox(width: 1.w),
                          ],
                          CustomIconWidget(
                            iconName: 'visibility',
                            size: 14,
                            color: isUsedInActiveExam
                                ? AppTheme.warningLight
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            usageCount.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: isUsedInActiveExam
                                      ? AppTheme.warningLight
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Action buttons row (visible when selected)
                if (isSelected) ...[
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        context: context,
                        icon: 'edit',
                        label: 'Edit',
                        onTap: onEdit,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                      _buildActionButton(
                        context: context,
                        icon: 'content_copy',
                        label: 'Duplicate',
                        onTap: onDuplicate,
                        color: AppTheme.lightTheme.colorScheme.secondary,
                      ),
                      _buildActionButton(
                        context: context,
                        icon: 'preview',
                        label: 'Preview',
                        onTap: onPreview,
                        color: AppTheme.successLight,
                      ),
                      _buildActionButton(
                        context: context,
                        icon: 'delete',
                        label: 'Delete',
                        onTap: onDelete,
                        color: AppTheme.errorLight,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String icon,
    required String label,
    required VoidCallback? onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 20,
              color: color,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppTheme.successLight;
      case 'medium':
        return AppTheme.warningLight;
      case 'hard':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 'trending_down';
      case 'medium':
        return 'trending_flat';
      case 'hard':
        return 'trending_up';
      default:
        return 'help';
    }
  }
}
