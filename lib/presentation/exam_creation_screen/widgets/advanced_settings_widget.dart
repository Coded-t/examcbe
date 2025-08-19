import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AdvancedSettingsWidget extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final bool randomizeQuestions;
  final bool randomizeOptions;
  final int attemptLimit;
  final double passingScore;
  final Function(bool) onRandomizeQuestionsChanged;
  final Function(bool) onRandomizeOptionsChanged;
  final Function(int) onAttemptLimitChanged;
  final Function(double) onPassingScoreChanged;

  const AdvancedSettingsWidget({
    super.key,
    required this.isExpanded,
    required this.onToggleExpansion,
    required this.randomizeQuestions,
    required this.randomizeOptions,
    required this.attemptLimit,
    required this.passingScore,
    required this.onRandomizeQuestionsChanged,
    required this.onRandomizeOptionsChanged,
    required this.onAttemptLimitChanged,
    required this.onPassingScoreChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onToggleExpansion,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'settings',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Advanced Settings',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
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
                  // Randomization Options
                  Text(
                    'Randomization',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Randomize Questions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Randomize Questions',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Questions will appear in random order',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: randomizeQuestions,
                        onChanged: onRandomizeQuestionsChanged,
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Randomize Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Randomize Options',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'Answer options will appear in random order',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: randomizeOptions,
                        onChanged: onRandomizeOptionsChanged,
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Attempt Limit
                  Text(
                    'Attempt Limit',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Maximum attempts allowed',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: attemptLimit > 1
                                  ? () =>
                                      onAttemptLimitChanged(attemptLimit - 1)
                                  : null,
                              icon: CustomIconWidget(
                                iconName: 'remove',
                                color: attemptLimit > 1
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                attemptLimit.toString(),
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: attemptLimit < 10
                                  ? () =>
                                      onAttemptLimitChanged(attemptLimit + 1)
                                  : null,
                              icon: CustomIconWidget(
                                iconName: 'add',
                                color: attemptLimit < 10
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Passing Score
                  Text(
                    'Passing Score',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Minimum score to pass',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.tertiary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${passingScore.toInt()}%',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 8),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 16),
                          ),
                          child: Slider(
                            value: passingScore,
                            min: 0,
                            max: 100,
                            divisions: 20,
                            onChanged: onPassingScoreChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
