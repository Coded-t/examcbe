import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool hasSearchQuery;
  final VoidCallback? onCreateCourse;

  const EmptyStateWidget({
    Key? key,
    this.hasSearchQuery = false,
    this.onCreateCourse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomIconWidget(
                    iconName: hasSearchQuery ? 'search_off' : 'school',
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.6),
                    size: 15.w,
                  ),
                  if (!hasSearchQuery)
                    Positioned(
                      bottom: 8.w,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.all(1.5.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.shadow
                                  .withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CustomIconWidget(
                          iconName: 'add',
                          color: AppTheme.lightTheme.colorScheme.onSecondary,
                          size: 4.w,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 4.h),

            // Title
            Text(
              hasSearchQuery ? 'No Courses Found' : 'Create Your First Course',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

            // Description
            Text(
              hasSearchQuery
                  ? 'Try adjusting your search terms or filters to find the courses you\'re looking for.'
                  : 'Start building your course catalog by creating your first course. You can add content, students, and exams later.',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),

            // Action button
            if (!hasSearchQuery) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onCreateCourse,
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme
                        .lightTheme.elevatedButtonTheme.style?.foregroundColor
                        ?.resolve({}),
                    size: 20,
                  ),
                  label: Text('Create Course'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              OutlinedButton.icon(
                onPressed: () {
                  // Handle browse templates or import
                },
                icon: CustomIconWidget(
                  iconName: 'explore',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: Text('Browse Templates'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),
            ] else ...[
              // Search suggestions for empty results
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                alignment: WrapAlignment.center,
                children: [
                  'Clear Search',
                  'View All Courses',
                  'Create New Course',
                ]
                    .map((action) => ActionChip(
                          label: Text(
                            action,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            switch (action) {
                              case 'Clear Search':
                                // Clear search - handled by parent
                                break;
                              case 'View All Courses':
                                // Reset filters - handled by parent
                                break;
                              case 'Create New Course':
                                onCreateCourse?.call();
                                break;
                            }
                          },
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ))
                    .toList(),
              ),
            ],

            SizedBox(height: 4.h),

            // Help text
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb_outline',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      hasSearchQuery
                          ? 'Tip: Use course codes or keywords to find specific courses quickly.'
                          : 'Tip: You can import existing courses or start from templates to save time.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
