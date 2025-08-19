import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/course_card_widget.dart';
import './widgets/course_creation_modal_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/search_filter_widget.dart';

class CourseManagementScreen extends StatefulWidget {
  const CourseManagementScreen({Key? key}) : super(key: key);

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  bool _isRefreshing = false;
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'all';

  // Mock data for courses
  List<Map<String, dynamic>> _allCourses = [
    {
      "id": 1,
      "title": "Data Structures and Algorithms",
      "code": "CS201",
      "description":
          "Comprehensive course covering fundamental data structures and algorithms",
      "studentCount": 45,
      "createdDate": DateTime.now().subtract(const Duration(days: 30)),
      "status": "active",
      "enrollmentSettings": "open",
    },
    {
      "id": 2,
      "title": "Advanced Database Systems",
      "code": "CS402",
      "description": "Advanced concepts in database design and optimization",
      "studentCount": 32,
      "createdDate": DateTime.now().subtract(const Duration(days: 15)),
      "status": "active",
      "enrollmentSettings": "restricted",
    },
    {
      "id": 3,
      "title": "Machine Learning Fundamentals",
      "code": "CS501",
      "description":
          "Introduction to machine learning concepts and applications",
      "studentCount": 28,
      "createdDate": DateTime.now().subtract(const Duration(days: 7)),
      "status": "draft",
      "enrollmentSettings": "closed",
    },
  ];

  List<Map<String, dynamic>> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _filteredCourses = List.from(_allCourses);
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    // Show refresh feedback with haptic
    HapticFeedback.lightImpact();
  }

  void _filterCourses() {
    setState(() {
      _filteredCourses = _allCourses.where((course) {
        final matchesSearch = course['title']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            course['code']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        final matchesFilter = _selectedFilter == 'all' ||
            course['status'].toString() == _selectedFilter;

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterCourses();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _filterCourses();
  }

  void _showCourseCreationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: CourseCreationModalWidget(
            scrollController: scrollController,
            onCourseCreated: _handleCourseCreated,
          ),
        ),
      ),
    );
  }

  void _handleCourseCreated(Map<String, dynamic> courseData) {
    setState(() {
      _allCourses.insert(0, {
        "id": _allCourses.length + 1,
        "title": courseData['title'],
        "code": courseData['code'],
        "description": courseData['description'],
        "studentCount": 0,
        "createdDate": DateTime.now(),
        "status": "draft",
        "enrollmentSettings": courseData['enrollmentSettings'],
      });
    });
    _filterCourses();

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Course "${courseData['title']}" created successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
    HapticFeedback.mediumImpact();
  }

  void _showCourseActions(Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              course['title'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            _buildActionTile('Edit Course', 'edit', () {
              Navigator.pop(context);
              _editCourse(course);
            }),
            _buildActionTile('Course Settings', 'settings', () {
              Navigator.pop(context);
              _openCourseSettings(course);
            }),
            _buildActionTile('Share Course', 'share', () {
              Navigator.pop(context);
              _shareCourse(course);
            }),
            _buildActionTile('Duplicate Course', 'content_copy', () {
              Navigator.pop(context);
              _duplicateCourse(course);
            }),
            _buildActionTile('Export Student List', 'download', () {
              Navigator.pop(context);
              _exportStudentList(course);
            }),
            _buildActionTile('View Analytics', 'analytics', () {
              Navigator.pop(context);
              _viewAnalytics(course);
            }),
            const Divider(),
            _buildActionTile(
              course['status'] == 'active' ? 'Archive Course' : 'Delete Course',
              course['status'] == 'active' ? 'archive' : 'delete',
              () {
                Navigator.pop(context);
                course['status'] == 'active'
                    ? _archiveCourse(course)
                    : _deleteCourse(course);
              },
              isDestructive: course['status'] != 'active',
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, String iconName, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDestructive ? AppTheme.lightTheme.colorScheme.error : null,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _editCourse(Map<String, dynamic> course) {
    // Implement course editing
    HapticFeedback.selectionClick();
  }

  void _openCourseSettings(Map<String, dynamic> course) {
    // Implement course settings
    HapticFeedback.selectionClick();
  }

  void _shareCourse(Map<String, dynamic> course) {
    // Implement course sharing
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Course "${course['title']}" shared'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _duplicateCourse(Map<String, dynamic> course) {
    setState(() {
      _allCourses.insert(0, {
        "id": _allCourses.length + 1,
        "title": "${course['title']} (Copy)",
        "code": "${course['code']}_COPY",
        "description": course['description'],
        "studentCount": 0,
        "createdDate": DateTime.now(),
        "status": "draft",
        "enrollmentSettings": course['enrollmentSettings'],
      });
    });
    _filterCourses();
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Course duplicated successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportStudentList(Map<String, dynamic> course) {
    // Implement student list export
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Student list exported for "${course['title']}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewAnalytics(Map<String, dynamic> course) {
    // Implement analytics view
    HapticFeedback.selectionClick();
  }

  void _archiveCourse(Map<String, dynamic> course) {
    setState(() {
      course['status'] = 'archived';
    });
    _filterCourses();
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Course "${course['title']}" archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              course['status'] = 'active';
            });
            _filterCourses();
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteCourse(Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Course'),
        content: Text(
            'Are you sure you want to delete "${course['title']}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allCourses.removeWhere((c) => c['id'] == course['id']);
              });
              _filterCourses();
              Navigator.pop(context);
              HapticFeedback.mediumImpact();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Course deleted'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Course Management',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showCourseCreationModal,
            icon: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SearchFilterWidget(
              onSearchChanged: _onSearchChanged,
              onFilterChanged: _onFilterChanged,
              selectedFilter: _selectedFilter,
            ),
            Expanded(
              child: _filteredCourses.isEmpty
                  ? EmptyStateWidget(
                      hasSearchQuery: _searchQuery.isNotEmpty,
                      onCreateCourse: _showCourseCreationModal,
                    )
                  : RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          left: 4.w,
                          right: 4.w,
                          top: 1.h,
                          bottom: 10.h,
                        ),
                        itemCount: _filteredCourses.length,
                        itemBuilder: (context, index) {
                          final course = _filteredCourses[index];
                          return CourseCardWidget(
                            course: course,
                            onTap: () {
                              // Navigate to course details
                              HapticFeedback.selectionClick();
                            },
                            onLongPress: () {
                              HapticFeedback.mediumImpact();
                              _showCourseActions(course);
                            },
                            onEdit: () => _editCourse(course),
                            onSettings: () => _openCourseSettings(course),
                            onShare: () => _shareCourse(course),
                            onArchive: () => _archiveCourse(course),
                            onDelete: () => _deleteCourse(course),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomSheet: QuickActionsWidget(
        onBulkImport: () {
          // Implement bulk import
          HapticFeedback.selectionClick();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bulk import courses'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onGenerateEnrollmentCodes: () {
          // Implement enrollment codes generation
          HapticFeedback.selectionClick();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Enrollment codes generated'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCourseCreationModal,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor!,
          size: 24,
        ),
        label: Text(
          'Create Course',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color:
                AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
