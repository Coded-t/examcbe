import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/advanced_settings_widget.dart';
import './widgets/exam_basic_info_widget.dart';
import './widgets/question_card_widget.dart';
import './widgets/question_creation_modal_widget.dart';

class ExamCreationScreen extends StatefulWidget {
  const ExamCreationScreen({super.key});

  @override
  State<ExamCreationScreen> createState() => _ExamCreationScreenState();
}

class _ExamCreationScreenState extends State<ExamCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  // Exam basic info
  String? _selectedCourse;
  int _selectedDuration = 60;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Questions
  List<Map<String, dynamic>> _questions = [];
  final List<bool> _expandedQuestions = [];

  // Advanced settings
  bool _advancedSettingsExpanded = false;
  bool _randomizeQuestions = false;
  bool _randomizeOptions = false;
  int _attemptLimit = 3;
  double _passingScore = 60.0;

  // UI state
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;

  // Mock data for courses
  final List<Map<String, dynamic>> _availableCourses = [
    {
      "id": "CS101",
      "title": "Introduction to Computer Science",
      "code": "CS101",
      "instructor": "Dr. Sarah Johnson",
    },
    {
      "id": "MATH201",
      "title": "Calculus II",
      "code": "MATH201",
      "instructor": "Prof. Michael Chen",
    },
    {
      "id": "ENG102",
      "title": "English Composition",
      "code": "ENG102",
      "instructor": "Dr. Emily Rodriguez",
    },
    {
      "id": "PHYS301",
      "title": "Quantum Physics",
      "code": "PHYS301",
      "instructor": "Dr. James Wilson",
    },
    {
      "id": "BIO150",
      "title": "General Biology",
      "code": "BIO150",
      "instructor": "Dr. Lisa Thompson",
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
            'You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Leave',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _selectCourse() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 60.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Course',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: _availableCourses.length,
                itemBuilder: (context, index) {
                  final course = _availableCourses[index];
                  final String courseTitle = course['title'] as String? ?? '';
                  final String courseCode = course['code'] as String? ?? '';
                  final String instructor =
                      course['instructor'] as String? ?? '';

                  return ListTile(
                    title: Text(courseTitle),
                    subtitle: Text('$courseCode • $instructor'),
                    onTap: () {
                      setState(() {
                        _selectedCourse = '$courseCode - $courseTitle';
                      });
                      _markAsChanged();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDuration() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 40.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Text(
              'Select Duration',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView(
                children: [30, 45, 60, 90, 120, 180].map((duration) {
                  return ListTile(
                    title: Text('$duration minutes'),
                    trailing: _selectedDuration == duration
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedDuration = duration;
                      });
                      _markAsChanged();
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
      _markAsChanged();
    }
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
      _markAsChanged();
    }
  }

  void _addQuestion() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => QuestionCreationModalWidget(
        onSave: (questionData) {
          setState(() {
            _questions.add(questionData);
            _expandedQuestions.add(false);
          });
          _markAsChanged();
        },
      ),
    );
  }

  void _editQuestion(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => QuestionCreationModalWidget(
        existingQuestion: _questions[index],
        onSave: (questionData) {
          setState(() {
            _questions[index] = questionData;
          });
          _markAsChanged();
        },
      ),
    );
  }

  void _duplicateQuestion(int index) {
    final originalQuestion = Map<String, dynamic>.from(_questions[index]);
    originalQuestion['id'] = DateTime.now().millisecondsSinceEpoch.toString();

    setState(() {
      _questions.insert(index + 1, originalQuestion);
      _expandedQuestions.insert(index + 1, false);
    });
    _markAsChanged();
  }

  void _deleteQuestion(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: const Text('Are you sure you want to delete this question?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _questions.removeAt(index);
                _expandedQuestions.removeAt(index);
              });
              _markAsChanged();
              Navigator.of(context).pop();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleQuestionExpansion(int index) {
    setState(() {
      _expandedQuestions[index] = !_expandedQuestions[index];
    });
  }

  void _previewExam() {
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one question to preview the exam'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 80.h,
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Exam Preview',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _titleController.text.isNotEmpty
                            ? _titleController.text
                            : 'Exam Title',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Duration: $_selectedDuration minutes',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      ..._questions.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final Map<String, dynamic> question = entry.value;
                        final String questionText =
                            question['questionText'] as String? ?? '';
                        final List<dynamic> options =
                            question['options'] as List<dynamic>? ?? [];

                        return Container(
                          margin: EdgeInsets.only(bottom: 3.h),
                          padding: EdgeInsets.all(4.w),
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
                                'Question ${index + 1}',
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                questionText,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              ...options.asMap().entries.map((optionEntry) {
                                final int optionIndex = optionEntry.key;
                                final String optionText =
                                    optionEntry.value as String? ?? '';

                                return Container(
                                  margin: EdgeInsets.only(bottom: 1.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 5.w,
                                        height: 5.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppTheme
                                                .lightTheme.colorScheme.outline,
                                            width: 2,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Expanded(
                                        child: Text(
                                          '${String.fromCharCode(65 + optionIndex)}. $optionText',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveExam() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_selectedCourse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a course')),
      );
      return;
    }

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one question')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Simulate Firebase save operation
      await Future.delayed(const Duration(seconds: 2));

      final examData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text.trim(),
        'course': _selectedCourse,
        'duration': _selectedDuration,
        'scheduledDate': _selectedDate?.toIso8601String(),
        'scheduledTime': _selectedTime != null
            ? '${_selectedTime!.hour}:${_selectedTime!.minute}'
            : null,
        'questions': _questions,
        'randomizeQuestions': _randomizeQuestions,
        'randomizeOptions': _randomizeOptions,
        'attemptLimit': _attemptLimit,
        'passingScore': _passingScore,
        'createdAt': DateTime.now().toIso8601String(),
        'createdBy': 'current_lecturer_id',
        'status': 'draft',
      };

      setState(() {
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exam saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save exam: ${e.toString()}'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Exam'),
          leading: IconButton(
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          actions: [
            if (_questions.isNotEmpty)
              TextButton(
                onPressed: _previewExam,
                child: Text(
                  'Preview',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            TextButton(
              onPressed: _isSaving ? null : _saveExam,
              child: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    )
                  : Text(
                      'Save',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Exam Info
                ExamBasicInfoWidget(
                  titleController: _titleController,
                  selectedCourse: _selectedCourse,
                  selectedDuration: _selectedDuration,
                  selectedDate: _selectedDate,
                  selectedTime: _selectedTime,
                  onCourseSelect: _selectCourse,
                  onDurationSelect: _selectDuration,
                  onDateSelect: _selectDate,
                  onTimeSelect: _selectTime,
                ),
                SizedBox(height: 3.h),

                // Questions Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Questions (${_questions.length})',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _addQuestion,
                      icon: CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 20,
                      ),
                      label: const Text('Add Question'),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Questions List
                if (_questions.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: 'quiz',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No questions added yet',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Add questions to create your exam',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...List.generate(_questions.length, (index) {
                    return QuestionCardWidget(
                      question: _questions[index],
                      index: index,
                      isExpanded: _expandedQuestions[index],
                      onToggleExpansion: () => _toggleQuestionExpansion(index),
                      onEdit: () => _editQuestion(index),
                      onDuplicate: () => _duplicateQuestion(index),
                      onDelete: () => _deleteQuestion(index),
                    );
                  }),

                // Advanced Settings
                AdvancedSettingsWidget(
                  isExpanded: _advancedSettingsExpanded,
                  onToggleExpansion: () {
                    setState(() {
                      _advancedSettingsExpanded = !_advancedSettingsExpanded;
                    });
                  },
                  randomizeQuestions: _randomizeQuestions,
                  randomizeOptions: _randomizeOptions,
                  attemptLimit: _attemptLimit,
                  passingScore: _passingScore,
                  onRandomizeQuestionsChanged: (value) {
                    setState(() {
                      _randomizeQuestions = value;
                    });
                    _markAsChanged();
                  },
                  onRandomizeOptionsChanged: (value) {
                    setState(() {
                      _randomizeOptions = value;
                    });
                    _markAsChanged();
                  },
                  onAttemptLimitChanged: (value) {
                    setState(() {
                      _attemptLimit = value;
                    });
                    _markAsChanged();
                  },
                  onPassingScoreChanged: (value) {
                    setState(() {
                      _passingScore = value;
                    });
                    _markAsChanged();
                  },
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
