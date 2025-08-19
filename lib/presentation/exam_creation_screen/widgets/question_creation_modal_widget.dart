import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuestionCreationModalWidget extends StatefulWidget {
  final Map<String, dynamic>? existingQuestion;
  final Function(Map<String, dynamic>) onSave;

  const QuestionCreationModalWidget({
    super.key,
    this.existingQuestion,
    required this.onSave,
  });

  @override
  State<QuestionCreationModalWidget> createState() =>
      _QuestionCreationModalWidgetState();
}

class _QuestionCreationModalWidgetState
    extends State<QuestionCreationModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _explanationController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(4, (index) => TextEditingController());

  int _correctAnswer = 0;
  String _selectedDifficulty = 'Medium';
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();
    if (widget.existingQuestion != null) {
      _loadExistingQuestion();
    }
  }

  void _loadExistingQuestion() {
    final question = widget.existingQuestion!;
    _questionController.text = question['questionText'] as String? ?? '';
    _explanationController.text = question['explanation'] as String? ?? '';
    _correctAnswer = question['correctAnswer'] as int? ?? 0;
    _selectedDifficulty = question['difficulty'] as String? ?? 'Medium';

    final List<dynamic> options = question['options'] as List<dynamic>? ?? [];
    for (int i = 0; i < _optionControllers.length && i < options.length; i++) {
      _optionControllers[i].text = options[i] as String? ?? '';
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _explanationController.dispose();
    for (final controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveQuestion() {
    if (_formKey.currentState?.validate() ?? false) {
      final questionData = {
        'questionText': _questionController.text.trim(),
        'options': _optionControllers
            .map((controller) => controller.text.trim())
            .toList(),
        'correctAnswer': _correctAnswer,
        'difficulty': _selectedDifficulty,
        'explanation': _explanationController.text.trim(),
        'id': widget.existingQuestion?['id'] ??
            DateTime.now().millisecondsSinceEpoch.toString(),
      };

      widget.onSave(questionData);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  widget.existingQuestion != null
                      ? 'Edit Question'
                      : 'Add Question',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _saveQuestion,
                  child: Text(
                    'Save',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Text
                    Text(
                      'Question',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _questionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Enter your question here...',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a question';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Options
                    Text(
                      'Answer Options',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),

                    ...List.generate(4, (index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 2.h),
                        child: Row(
                          children: [
                            // Radio Button
                            Radio<int>(
                              value: index,
                              groupValue: _correctAnswer,
                              onChanged: (value) {
                                setState(() {
                                  _correctAnswer = value ?? 0;
                                });
                              },
                            ),

                            // Option Input
                            Expanded(
                              child: TextFormField(
                                controller: _optionControllers[index],
                                decoration: InputDecoration(
                                  labelText:
                                      'Option ${String.fromCharCode(65 + index)}',
                                  hintText:
                                      'Enter option ${String.fromCharCode(65 + index)}',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter option ${String.fromCharCode(65 + index)}';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    SizedBox(height: 2.h),

                    // Difficulty Selection
                    Text(
                      'Difficulty Level',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDifficulty,
                          isExpanded: true,
                          items: _difficulties.map((difficulty) {
                            return DropdownMenuItem<String>(
                              value: difficulty,
                              child: Text(difficulty),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDifficulty = value ?? 'Medium';
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Explanation (Optional)
                    Text(
                      'Explanation (Optional)',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _explanationController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText:
                            'Provide explanation for the correct answer...',
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Correct Answer Indicator
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Correct Answer: Option ${String.fromCharCode(65 + _correctAnswer)}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
