import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bulk_actions_bar_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/question_card_widget.dart';
import './widgets/question_creation_modal_widget.dart';
import './widgets/search_filter_bar_widget.dart';

class QuestionBankScreen extends StatefulWidget {
  const QuestionBankScreen({Key? key}) : super(key: key);

  @override
  State<QuestionBankScreen> createState() => _QuestionBankScreenState();
}

class _QuestionBankScreenState extends State<QuestionBankScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _allQuestions = [];
  List<Map<String, dynamic>> _filteredQuestions = [];
  Set<String> _selectedQuestionIds = {};
  bool _isMultiSelectMode = false;
  bool _isLoading = false;

  Map<String, dynamic> _activeFilters = {
    'difficulties': <String>[],
    'questionTypes': <String>[],
    'usageStatus': 'All',
  };

  // Mock course data
  final Map<String, dynamic> _courseData = {
    'id': 'CS101',
    'title': 'Introduction to Computer Science',
    'code': 'CS101',
    'questionCount': 45,
  };

  @override
  void initState() {
    super.initState();
    _loadMockQuestions();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMockQuestions() {
    setState(() {
      _isLoading = true;
    });

    // Mock questions data
    _allQuestions = [
      {
        'id': 'q1',
        'questionText':
            'What is the primary purpose of an operating system in a computer?',
        'type': 'Multiple Choice',
        'difficulty': 'Medium',
        'options': [
          'To provide a user interface',
          'To manage hardware and software resources',
          'To run applications',
          'To store data'
        ],
        'correctAnswerIndex': 1,
        'explanation':
            'An operating system manages all hardware and software resources, providing a platform for other programs to run.',
        'usageCount': 3,
        'isUsedInActiveExam': true,
        'createdAt': '2024-08-15T10:30:00Z',
        'updatedAt': '2024-08-18T14:20:00Z',
      },
      {
        'id': 'q2',
        'questionText':
            'Which data structure follows the Last In First Out (LIFO) principle?',
        'type': 'Multiple Choice',
        'difficulty': 'Easy',
        'options': ['Queue', 'Stack', 'Array', 'Linked List'],
        'correctAnswerIndex': 1,
        'explanation':
            'A stack follows LIFO principle where the last element added is the first one to be removed.',
        'usageCount': 7,
        'isUsedInActiveExam': false,
        'createdAt': '2024-08-14T09:15:00Z',
        'updatedAt': '2024-08-17T11:45:00Z',
      },
      {
        'id': 'q3',
        'questionText':
            'In object-oriented programming, what is encapsulation?',
        'type': 'Multiple Choice',
        'difficulty': 'Hard',
        'options': [
          'The ability to create multiple instances of a class',
          'The process of hiding internal implementation details',
          'The ability to inherit properties from parent classes',
          'The process of overriding methods in derived classes'
        ],
        'correctAnswerIndex': 1,
        'explanation':
            'Encapsulation is the bundling of data and methods that operate on that data within a single unit, hiding internal implementation details.',
        'usageCount': 2,
        'isUsedInActiveExam': true,
        'createdAt': '2024-08-13T16:20:00Z',
        'updatedAt': '2024-08-19T08:30:00Z',
      },
      {
        'id': 'q4',
        'questionText':
            'What is the time complexity of binary search algorithm?',
        'type': 'Multiple Choice',
        'difficulty': 'Medium',
        'options': ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'],
        'correctAnswerIndex': 1,
        'explanation':
            'Binary search has O(log n) time complexity as it eliminates half of the search space in each iteration.',
        'usageCount': 5,
        'isUsedInActiveExam': false,
        'createdAt': '2024-08-12T13:45:00Z',
        'updatedAt': '2024-08-16T10:15:00Z',
      },
      {
        'id': 'q5',
        'questionText': 'Which of the following is NOT a programming paradigm?',
        'type': 'Multiple Choice',
        'difficulty': 'Easy',
        'options': [
          'Object-Oriented Programming',
          'Functional Programming',
          'Procedural Programming',
          'Database Programming'
        ],
        'correctAnswerIndex': 3,
        'explanation':
            'Database Programming is not a programming paradigm but rather a domain of programming that deals with database operations.',
        'usageCount': 1,
        'isUsedInActiveExam': false,
        'createdAt': '2024-08-11T12:00:00Z',
        'updatedAt': '2024-08-15T15:30:00Z',
      },
      {
        'id': 'q6',
        'questionText': 'What does SQL stand for?',
        'type': 'Multiple Choice',
        'difficulty': 'Easy',
        'options': [
          'Structured Query Language',
          'Standard Query Language',
          'Sequential Query Language',
          'System Query Language'
        ],
        'correctAnswerIndex': 0,
        'explanation':
            'SQL stands for Structured Query Language, used for managing and manipulating relational databases.',
        'usageCount': 8,
        'isUsedInActiveExam': true,
        'createdAt': '2024-08-10T14:30:00Z',
        'updatedAt': '2024-08-18T09:20:00Z',
      },
    ];

    _filteredQuestions = List.from(_allQuestions);

    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredQuestions = _allQuestions.where((question) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        final questionText = (question['questionText'] as String).toLowerCase();
        final matchesSearch =
            searchQuery.isEmpty || questionText.contains(searchQuery);

        // Difficulty filter
        final difficulties = _activeFilters['difficulties'] as List<String>;
        final matchesDifficulty = difficulties.isEmpty ||
            difficulties.contains(question['difficulty']);

        // Question type filter
        final questionTypes = _activeFilters['questionTypes'] as List<String>;
        final matchesType =
            questionTypes.isEmpty || questionTypes.contains(question['type']);

        // Usage status filter
        final usageStatus = _activeFilters['usageStatus'] as String;
        bool matchesUsage = true;
        switch (usageStatus) {
          case 'Used in Active Exams':
            matchesUsage = question['isUsedInActiveExam'] == true;
            break;
          case 'Not Used':
            matchesUsage = (question['usageCount'] as int) == 0;
            break;
          case 'Frequently Used':
            matchesUsage = (question['usageCount'] as int) >= 5;
            break;
          default:
            matchesUsage = true;
        }

        return matchesSearch &&
            matchesDifficulty &&
            matchesType &&
            matchesUsage;
      }).toList();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _activeFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _showQuestionCreationModal({Map<String, dynamic>? existingQuestion}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuestionCreationModalWidget(
        existingQuestion: existingQuestion,
        onQuestionCreated: (questionData) {
          setState(() {
            if (existingQuestion != null) {
              // Update existing question
              final index = _allQuestions
                  .indexWhere((q) => q['id'] == questionData['id']);
              if (index != -1) {
                _allQuestions[index] = questionData;
              }
            } else {
              // Add new question
              _allQuestions.insert(0, questionData);
              _courseData['questionCount'] =
                  (_courseData['questionCount'] as int) + 1;
            }
          });
          _applyFilters();
        },
      ),
    );
  }

  void _toggleQuestionSelection(String questionId) {
    setState(() {
      if (_selectedQuestionIds.contains(questionId)) {
        _selectedQuestionIds.remove(questionId);
        if (_selectedQuestionIds.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedQuestionIds.add(questionId);
        _isMultiSelectMode = true;
      }
    });
  }

  void _selectAllQuestions() {
    setState(() {
      _selectedQuestionIds =
          _filteredQuestions.map((q) => q['id'] as String).toSet();
    });
  }

  void _deselectAllQuestions() {
    setState(() {
      _selectedQuestionIds.clear();
      _isMultiSelectMode = false;
    });
  }

  void _deleteQuestion(String questionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Question'),
        content: Text(
            'Are you sure you want to delete this question? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allQuestions.removeWhere((q) => q['id'] == questionId);
                _selectedQuestionIds.remove(questionId);
                _courseData['questionCount'] =
                    (_courseData['questionCount'] as int) - 1;
              });
              _applyFilters();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _bulkDeleteQuestions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Questions'),
        content: Text(
            'Are you sure you want to delete ${_selectedQuestionIds.length} selected questions? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allQuestions
                    .removeWhere((q) => _selectedQuestionIds.contains(q['id']));
                _courseData['questionCount'] =
                    (_courseData['questionCount'] as int) -
                        _selectedQuestionIds.length;
                _selectedQuestionIds.clear();
                _isMultiSelectMode = false;
              });
              _applyFilters();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorLight,
            ),
            child: Text('Delete All'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshQuestions() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    _loadMockQuestions();
  }

  bool _hasActiveFilters() {
    final difficulties = _activeFilters['difficulties'] as List<String>;
    final questionTypes = _activeFilters['questionTypes'] as List<String>;
    final usageStatus = _activeFilters['usageStatus'] as String;

    return difficulties.isNotEmpty ||
        questionTypes.isNotEmpty ||
        usageStatus != 'All';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Question Bank'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            size: 24,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement bulk import functionality
            },
            icon: CustomIconWidget(
              iconName: 'upload_file',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'import':
                  // TODO: Implement import functionality
                  break;
                case 'export':
                  // TODO: Implement export functionality
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'file_upload',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    SizedBox(width: 2.w),
                    Text('Import Questions'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'file_download',
                      size: 20,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    SizedBox(width: 2.w),
                    Text('Export Questions'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Course context header
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: CustomIconWidget(
                      iconName: 'school',
                      size: 24,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _courseData['title'] as String,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            Text(
                              _courseData['code'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              width: 1.w,
                              height: 1.w,
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '${_courseData['questionCount']} questions',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search and filter bar
            SearchFilterBarWidget(
              searchController: _searchController,
              onFilterTap: _showFilterBottomSheet,
              hasActiveFilters: _hasActiveFilters(),
              onSearchChanged: (value) => _onSearchChanged(),
            ),

            // Bulk actions bar (visible when in multi-select mode)
            if (_isMultiSelectMode)
              BulkActionsBarWidget(
                selectedCount: _selectedQuestionIds.length,
                onSelectAll: _selectAllQuestions,
                onDeselectAll: _deselectAllQuestions,
                onBulkDelete: _bulkDeleteQuestions,
                onBulkMove: () {
                  // TODO: Implement bulk move functionality
                },
                onBulkChangeDifficulty: () {
                  // TODO: Implement bulk difficulty change
                },
                onCancel: () {
                  setState(() {
                    _selectedQuestionIds.clear();
                    _isMultiSelectMode = false;
                  });
                },
              ),

            // Questions list
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    )
                  : _filteredQuestions.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _refreshQuestions,
                          color: AppTheme.lightTheme.primaryColor,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _filteredQuestions.length,
                            itemBuilder: (context, index) {
                              final question = _filteredQuestions[index];
                              final questionId = question['id'] as String;
                              final isSelected =
                                  _selectedQuestionIds.contains(questionId);

                              return QuestionCardWidget(
                                question: question,
                                isSelected: isSelected,
                                onTap: () {
                                  if (_isMultiSelectMode) {
                                    _toggleQuestionSelection(questionId);
                                  } else {
                                    // Show question preview
                                    _showQuestionPreview(question);
                                  }
                                },
                                onLongPress: () {
                                  _toggleQuestionSelection(questionId);
                                },
                                onEdit: () {
                                  _showQuestionCreationModal(
                                      existingQuestion: question);
                                },
                                onDuplicate: () {
                                  final duplicatedQuestion =
                                      Map<String, dynamic>.from(question);
                                  duplicatedQuestion['id'] = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  duplicatedQuestion['questionText'] =
                                      '${duplicatedQuestion['questionText']} (Copy)';
                                  duplicatedQuestion['createdAt'] =
                                      DateTime.now().toIso8601String();
                                  duplicatedQuestion['updatedAt'] =
                                      DateTime.now().toIso8601String();
                                  duplicatedQuestion['usageCount'] = 0;
                                  duplicatedQuestion['isUsedInActiveExam'] =
                                      false;

                                  setState(() {
                                    _allQuestions.insert(0, duplicatedQuestion);
                                    _courseData['questionCount'] =
                                        (_courseData['questionCount'] as int) +
                                            1;
                                  });
                                  _applyFilters();
                                },
                                onPreview: () {
                                  _showQuestionPreview(question);
                                },
                                onDelete: () {
                                  _deleteQuestion(questionId);
                                },
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuestionCreationModal(),
        icon: CustomIconWidget(
          iconName: 'add',
          size: 24,
          color: AppTheme.lightTheme.colorScheme.onPrimary,
        ),
        label: Text('Add Question'),
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasSearchQuery = _searchController.text.isNotEmpty;
    final hasFilters = _hasActiveFilters();

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: hasSearchQuery || hasFilters ? 'search_off' : 'quiz',
                size: 48,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              hasSearchQuery || hasFilters
                  ? 'No questions found'
                  : 'No questions yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              hasSearchQuery || hasFilters
                  ? 'Try adjusting your search or filters'
                  : 'Create your first question to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            if (!hasSearchQuery && !hasFilters) ...[
              SizedBox(height: 4.h),
              ElevatedButton.icon(
                onPressed: () => _showQuestionCreationModal(),
                icon: CustomIconWidget(
                  iconName: 'add',
                  size: 20,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
                label: Text('Create Question'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showQuestionPreview(Map<String, dynamic> question) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Question Preview'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Question text
              Text(
                question['questionText'] as String,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 2.h),

              // Options
              if (question['type'] == 'Multiple Choice') ...[
                Text(
                  'Options:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 1.h),
                ...(question['options'] as List<dynamic>)
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final option = entry.value as String;
                  final isCorrect =
                      index == (question['correctAnswerIndex'] as int);

                  return Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? AppTheme.successLight.withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: isCorrect
                            ? AppTheme.successLight
                            : AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${String.fromCharCode(65 + index)}. ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isCorrect ? AppTheme.successLight : null,
                              ),
                        ),
                        Expanded(
                          child: Text(
                            option,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      isCorrect ? AppTheme.successLight : null,
                                ),
                          ),
                        ),
                        if (isCorrect)
                          CustomIconWidget(
                            iconName: 'check_circle',
                            size: 20,
                            color: AppTheme.successLight,
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],

              // Explanation
              if (question['explanation'] != null &&
                  (question['explanation'] as String).isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  'Explanation:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    question['explanation'] as String,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showQuestionCreationModal(existingQuestion: question);
            },
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }
}