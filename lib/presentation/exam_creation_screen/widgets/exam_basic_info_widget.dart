import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExamBasicInfoWidget extends StatelessWidget {
  final TextEditingController titleController;
  final String? selectedCourse;
  final int selectedDuration;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final VoidCallback onCourseSelect;
  final VoidCallback onDurationSelect;
  final VoidCallback onDateSelect;
  final VoidCallback onTimeSelect;

  const ExamBasicInfoWidget({
    super.key,
    required this.titleController,
    this.selectedCourse,
    required this.selectedDuration,
    this.selectedDate,
    this.selectedTime,
    required this.onCourseSelect,
    required this.onDurationSelect,
    required this.onDateSelect,
    required this.onTimeSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exam Details',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),

          // Exam Title
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Exam Title',
              hintText: 'Enter exam title',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter exam title';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),

          // Course Selection
          InkWell(
            onTap: onCourseSelect,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Course',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        selectedCourse ?? 'Select Course',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: selectedCourse != null
                              ? AppTheme.lightTheme.colorScheme.onSurface
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  CustomIconWidget(
                    iconName: 'keyboard_arrow_down',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Duration and Date/Time Row
          Row(
            children: [
              // Duration
              Expanded(
                child: InkWell(
                  onTap: onDurationSelect,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Duration',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${selectedDuration} min',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),

              // Date
              Expanded(
                child: InkWell(
                  onTap: onDateSelect,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          selectedDate != null
                              ? '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}'
                              : 'Select Date',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: selectedDate != null
                                ? AppTheme.lightTheme.colorScheme.onSurface
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Time Selection
          InkWell(
            onTap: onTimeSelect,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Time',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        selectedTime != null
                            ? selectedTime!.format(context)
                            : 'Select Time',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: selectedTime != null
                              ? AppTheme.lightTheme.colorScheme.onSurface
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  CustomIconWidget(
                    iconName: 'access_time',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
