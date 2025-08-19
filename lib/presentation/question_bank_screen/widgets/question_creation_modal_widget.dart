import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuestionCreationModalWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onQuestionCreated;
  final Map<String, dynamic>? existingQuestion;

  const QuestionCreationModalWidget({
    Key? key,
    required this.onQuestionCreated,
    this.existingQuestion,
  }) : super(key: key);

  @override
  State<QuestionCreationModalWidget> createState() =>
      _QuestionCreationModalWidgetState();
}

class _QuestionCreationModalWidgetState
    extends State<QuestionCreationModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _explanationController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];

  String _selectedDifficulty = 'Medium';
  String _selectedType = 'Multiple Choice';
  int _correctAnswerIndex = 0;

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];
  final List<String> _questionTypes = [
    'Multiple Choice',
    'True/False',
    'Fill in the Blank'
  ];

  @override
  void initState() {
    super.initState();
    _initializeOptions();
    _loadExistingQuestion();
  }

  void _initializeOptions() {
    // Initialize with 4 options for multiple choice
    for (int i = 0; i < 4; i++) {
      _optionControllers.add(TextEditingController());
    }
  }

  void _loadExistingQuestion() {
    if (widget.existingQuestion != null) {
      final question = widget.existingQuestion!;
      _questionController.text = question['questionText'] ?? '';
      _explanationController.text = question['explanation'] ?? '';
      _selectedDifficulty = question['difficulty'] ?? 'Medium';
      _selectedType = question['type'] ?? 'Multiple Choice';
      _correctAnswerIndex = question['correctAnswerIndex'] ?? 0;

      final options = (question['options'] as List<dynamic>?) ?? [];
      for (int i = 0;
          i < options.length && i < _optionControllers.length;
          i++) {
        _optionControllers[i].text = options[i].toString();
      }
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  widget.existingQuestion != null
                      ? 'Edit Question'
                      : 'Create Question',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Form content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question text field
                    _buildSectionTitle('Question Text'),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _questionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Enter your question here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a question';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Question type and difficulty row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Question Type'),
                              SizedBox(height: 1.h),
                              DropdownButtonFormField<String>(
                                value: _selectedType,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                items: _questionTypes.map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedType = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Difficulty'),
                              SizedBox(height: 1.h),
                              DropdownButtonFormField<String>(
                                value: _selectedDifficulty,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                                items: _difficulties.map((difficulty) {
                                  return DropdownMenuItem(
                                    value: difficulty,
                                    child: Row(
                                      children: [
                                        CustomIconWidget(
                                          iconName:
                                              _getDifficultyIcon(difficulty),
                                          size: 16,
                                          color:
                                              _getDifficultyColor(difficulty),
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(difficulty),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDifficulty = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Options section (for multiple choice)
                    if (_selectedType == 'Multiple Choice') ...[
                      Row(
                        children: [
                          _buildSectionTitle('Answer Options'),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _addOption,
                            icon: CustomIconWidget(
                              iconName: 'add',
                              size: 16,
                              color: AppTheme.lightTheme.primaryColor,
                            ),
                            label: Text('Add Option'),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      ..._buildOptionFields(),
                      SizedBox(height: 2.h),
                    ],

                    // Explanation field
                    _buildSectionTitle('Explanation (Optional)'),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _explanationController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText:
                            'Provide an explanation for the correct answer...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveQuestion,
                    child: Text(
                        widget.existingQuestion != null ? 'Update' : 'Create'),
                  ),
                ),
              ],
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }

  List<Widget> _buildOptionFields() {
    return List.generate(_optionControllers.length, (index) {
      return Container(
        margin: EdgeInsets.only(bottom: 2.h),
        child: Row(
          children: [
            // Correct answer radio button
            Radio<int>(
              value: index,
              groupValue: _correctAnswerIndex,
              onChanged: (value) {
                setState(() {
                  _correctAnswerIndex = value!;
                });
              },
              activeColor: AppTheme.lightTheme.primaryColor,
            ),

            // Option text field
            Expanded(
              child: TextFormField(
                controller: _optionControllers[index],
                decoration: InputDecoration(
                  hintText: 'Option ${String.fromCharCode(65 + index)}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixText: '${String.fromCharCode(65 + index)}. ',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter option ${String.fromCharCode(65 + index)}';
                  }
                  return null;
                },
              ),
            ),

            // Remove option button (if more than 2 options)
            if (_optionControllers.length > 2)
              IconButton(
                onPressed: () => _removeOption(index),
                icon: CustomIconWidget(
                  iconName: 'remove_circle',
                  size: 24,
                  color: AppTheme.errorLight,
                ),
              ),
          ],
        ),
      );
    });
  }

  void _addOption() {
    if (_optionControllers.length < 6) {
      setState(() {
        _optionControllers.add(TextEditingController());
      });
    }
  }

  void _removeOption(int index) {
    if (_optionControllers.length > 2) {
      setState(() {
        _optionControllers[index].dispose();
        _optionControllers.removeAt(index);

        // Adjust correct answer index if necessary
        if (_correctAnswerIndex >= index && _correctAnswerIndex > 0) {
          _correctAnswerIndex--;
        }
      });
    }
  }

  void _saveQuestion() {
    if (_formKey.currentState!.validate()) {
      final options = _optionControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final questionData = {
        'id': widget.existingQuestion?['id'] ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        'questionText': _questionController.text.trim(),
        'type': _selectedType,
        'difficulty': _selectedDifficulty,
        'options': options,
        'correctAnswerIndex': _correctAnswerIndex,
        'explanation': _explanationController.text.trim(),
        'createdAt': widget.existingQuestion?['createdAt'] ??
            DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'usageCount': widget.existingQuestion?['usageCount'] ?? 0,
        'isUsedInActiveExam':
            widget.existingQuestion?['isUsedInActiveExam'] ?? false,
      };

      widget.onQuestionCreated(questionData);
      Navigator.pop(context);
    }
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
