import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CourseCreationModalWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Function(Map<String, dynamic>) onCourseCreated;

  const CourseCreationModalWidget({
    Key? key,
    required this.scrollController,
    required this.onCourseCreated,
  }) : super(key: key);

  @override
  State<CourseCreationModalWidget> createState() =>
      _CourseCreationModalWidgetState();
}

class _CourseCreationModalWidgetState extends State<CourseCreationModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedEnrollment = 'open';
  bool _isCreating = false;

  final Map<String, String> _enrollmentOptions = {
    'open': 'Open Enrollment',
    'restricted': 'Restricted Access',
    'closed': 'Closed Enrollment',
  };

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_generateCourseCode);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _generateCourseCode() {
    if (_titleController.text.isNotEmpty && _codeController.text.isEmpty) {
      final words = _titleController.text
          .trim()
          .split(' ')
          .where((word) => word.isNotEmpty)
          .take(3);

      String code = '';
      for (final word in words) {
        if (word.length >= 2) {
          code += word.substring(0, 2).toUpperCase();
        } else {
          code += word.toUpperCase();
        }
      }

      // Add random numbers if code is too short
      if (code.length < 3) {
        code += Random().nextInt(999).toString().padLeft(3, '0');
      } else {
        code += Random().nextInt(99).toString().padLeft(2, '0');
      }

      _codeController.text = code;
    }
  }

  Future<void> _createCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCreating = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final courseData = {
      'title': _titleController.text.trim(),
      'code': _codeController.text.trim(),
      'description': _descriptionController.text.trim(),
      'enrollmentSettings': _selectedEnrollment,
    };

    widget.onCourseCreated(courseData);
    Navigator.pop(context);

    setState(() {
      _isCreating = false;
    });

    HapticFeedback.mediumImpact();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Course title is required';
    }
    if (value.trim().length < 3) {
      return 'Title must be at least 3 characters';
    }
    return null;
  }

  String? _validateCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Course code is required';
    }
    if (value.trim().length < 3) {
      return 'Code must be at least 3 characters';
    }
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value.trim())) {
      return 'Code can only contain uppercase letters and numbers';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),

            // Title
            Text(
              'Create New Course',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Fill in the details below to create a new course',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),

            // Form fields
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Title
                    Text(
                      'Course Title *',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _titleController,
                      validator: _validateTitle,
                      decoration: InputDecoration(
                        hintText: 'Enter course title',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'book',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    SizedBox(height: 3.h),

                    // Course Code
                    Text(
                      'Course Code *',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _codeController,
                            validator: _validateCode,
                            decoration: InputDecoration(
                              hintText: 'Auto-generated',
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(3.w),
                                child: CustomIconWidget(
                                  iconName: 'tag',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              ),
                            ),
                            textCapitalization: TextCapitalization.characters,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[A-Z0-9]')),
                            ],
                          ),
                        ),
                        SizedBox(width: 3.w),
                        IconButton(
                          onPressed: _generateCourseCode,
                          icon: CustomIconWidget(
                            iconName: 'refresh',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          tooltip: 'Generate new code',
                          style: IconButton.styleFrom(
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),

                    // Description
                    Text(
                      'Description',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Enter course description (optional)',
                        alignLabelWithHint: true,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    SizedBox(height: 3.h),

                    // Enrollment Settings
                    Text(
                      'Enrollment Settings',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: _enrollmentOptions.entries.map((entry) {
                          final isSelected = _selectedEnrollment == entry.key;
                          return Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1)
                                  : Colors.transparent,
                              borderRadius: entry.key ==
                                      _enrollmentOptions.keys.first
                                  ? const BorderRadius.vertical(
                                      top: Radius.circular(12))
                                  : entry.key == _enrollmentOptions.keys.last
                                      ? const BorderRadius.vertical(
                                          bottom: Radius.circular(12))
                                      : BorderRadius.zero,
                            ),
                            child: RadioListTile<String>(
                              value: entry.key,
                              groupValue: _selectedEnrollment,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedEnrollment = value;
                                  });
                                }
                              },
                              title: Text(
                                entry.value,
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : null,
                                ),
                              ),
                              subtitle: Text(
                                _getEnrollmentDescription(entry.key),
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                          .withValues(alpha: 0.8)
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                ),
                              ),
                              activeColor:
                                  AppTheme.lightTheme.colorScheme.primary,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _isCreating ? null : () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isCreating ? null : _createCourse,
                    child: _isCreating
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text('Creating...'),
                            ],
                          )
                        : Text('Create Course'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String _getEnrollmentDescription(String key) {
    switch (key) {
      case 'open':
        return 'Students can self-enroll without approval';
      case 'restricted':
        return 'Students need approval to enroll';
      case 'closed':
        return 'Only manually added students can access';
      default:
        return '';
    }
  }
}
