import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuestionCardWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;

  const QuestionCardWidget({
    super.key,
    required this.question,
    required this.index,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    required this.isExpanded,
    required this.onToggleExpansion,
  });

  @override
  Widget build(BuildContext context) {
    final String questionText = question['questionText'] as String? ?? '';
    final List<dynamic> options = question['options'] as List<dynamic>? ?? [];
    final int correctAnswer = question['correctAnswer'] as int? ?? 0;
    final String difficulty = question['difficulty'] as String? ?? 'Medium';

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Question Header
          InkWell(
            onTap: onToggleExpansion,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Drag Handle
                  Container(
                    padding: EdgeInsets.all(1.w),
                    child: CustomIconWidget(
                      iconName: 'drag_indicator',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 2.w),

                  // Question Number and Preview
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Q${index + 1}',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(difficulty)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                difficulty,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: _getDifficultyColor(difficulty),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          questionText.length > 80
                              ? '${questionText.substring(0, 80)}...'
                              : questionText,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Expand/Collapse Icon
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content
          if (isExpanded) ...[
            Divider(
              height: 1,
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Question Text
                  Text(
                    'Question:',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    questionText,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 2.h),

                  // Options
                  Text(
                    'Options:',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...options.asMap().entries.map((entry) {
                    final int optionIndex = entry.key;
                    final String optionText = entry.value as String? ?? '';
                    final bool isCorrect = optionIndex == correctAnswer;

                    return Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? AppTheme.lightTheme.colorScheme.tertiary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.surface,
                        border: Border.all(
                          color: isCorrect
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : AppTheme.lightTheme.colorScheme.outline,
                          width: isCorrect ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: isCorrect
                                  ? AppTheme.lightTheme.colorScheme.tertiary
                                  : Colors.transparent,
                              border: Border.all(
                                color: isCorrect
                                    ? AppTheme.lightTheme.colorScheme.tertiary
                                    : AppTheme.lightTheme.colorScheme.outline,
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: isCorrect
                                ? CustomIconWidget(
                                    iconName: 'check',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onTertiary,
                                    size: 16,
                                  )
                                : null,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              '${String.fromCharCode(65 + optionIndex)}. $optionText',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: isCorrect
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 2.h),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: 'edit',
                        label: 'Edit',
                        onTap: onEdit,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                      _buildActionButton(
                        icon: 'content_copy',
                        label: 'Duplicate',
                        onTap: onDuplicate,
                        color: AppTheme.lightTheme.colorScheme.secondary,
                      ),
                      _buildActionButton(
                        icon: 'delete',
                        label: 'Delete',
                        onTap: onDelete,
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
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
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'hard':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
