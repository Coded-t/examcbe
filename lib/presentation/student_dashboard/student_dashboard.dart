import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/available_exams_card.dart';
import './widgets/notification_banner.dart';
import './widgets/progress_tracking_card.dart';
import './widgets/recent_results_card.dart';
import './widgets/upcoming_deadlines_card.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  Map<String, dynamic>? _currentNotification;
  int _notificationBadgeCount = 3;

  // Mock data for available exams
  final List<Map<String, dynamic>> _availableExams = [
    {
      "id": 1,
      "title": "Data Structures and Algorithms Final Exam",
      "courseName": "CS 301 - Data Structures",
      "courseCode": "CS301",
      "duration": 120,
      "questionCount": 50,
      "difficulty": "Hard",
      "deadline": DateTime.now().add(const Duration(days: 2, hours: 14)),
      "attemptStatus": "Not Started",
      "practiceMode": true,
      "estimatedTime": "2 hours",
    },
    {
      "id": 2,
      "title": "Database Management Systems Midterm",
      "courseName": "CS 401 - Database Systems",
      "courseCode": "CS401",
      "duration": 90,
      "questionCount": 35,
      "difficulty": "Medium",
      "deadline": DateTime.now().add(const Duration(hours: 6)),
      "attemptStatus": "Not Started",
      "practiceMode": false,
      "estimatedTime": "1.5 hours",
    },
    {
      "id": 3,
      "title": "Software Engineering Quiz",
      "courseName": "CS 350 - Software Engineering",
      "courseCode": "CS350",
      "duration": 45,
      "questionCount": 20,
      "difficulty": "Easy",
      "deadline": DateTime.now().add(const Duration(days: 5)),
      "attemptStatus": "In Progress",
      "practiceMode": true,
      "estimatedTime": "45 minutes",
    },
    {
      "id": 4,
      "title": "Computer Networks Assignment",
      "courseName": "CS 421 - Computer Networks",
      "courseCode": "CS421",
      "duration": 60,
      "questionCount": 25,
      "difficulty": "Medium",
      "deadline": DateTime.now().subtract(const Duration(hours: 2)),
      "attemptStatus": "Not Started",
      "practiceMode": false,
      "estimatedTime": "1 hour",
    },
  ];

  // Mock data for recent results
  final List<Map<String, dynamic>> _recentResults = [
    {
      "id": 1,
      "examTitle": "Object-Oriented Programming Final",
      "courseName": "CS 201 - OOP",
      "score": 87.5,
      "maxScore": 100.0,
      "completedAt": DateTime.now().subtract(const Duration(days: 1)),
      "improvement": 5.2,
    },
    {
      "id": 2,
      "examTitle": "Web Development Midterm",
      "courseName": "CS 315 - Web Dev",
      "score": 92.0,
      "maxScore": 100.0,
      "completedAt": DateTime.now().subtract(const Duration(days: 3)),
      "improvement": -2.1,
    },
    {
      "id": 3,
      "examTitle": "Machine Learning Quiz",
      "courseName": "CS 450 - ML",
      "score": 78.5,
      "maxScore": 100.0,
      "completedAt": DateTime.now().subtract(const Duration(days: 5)),
      "improvement": 8.7,
    },
  ];

  // Mock data for course progress
  final List<Map<String, dynamic>> _courseProgress = [
    {
      "courseName": "Data Structures and Algorithms",
      "courseCode": "CS301",
      "completionPercentage": 75.0,
      "completedExams": 3,
      "totalExams": 4,
      "averageScore": 85.2,
    },
    {
      "courseName": "Database Management Systems",
      "courseCode": "CS401",
      "completionPercentage": 60.0,
      "completedExams": 2,
      "totalExams": 5,
      "averageScore": 88.5,
    },
    {
      "courseName": "Software Engineering",
      "courseCode": "CS350",
      "completionPercentage": 90.0,
      "completedExams": 4,
      "totalExams": 5,
      "averageScore": 91.3,
    },
    {
      "courseName": "Computer Networks",
      "courseCode": "CS421",
      "completionPercentage": 40.0,
      "completedExams": 1,
      "totalExams": 3,
      "averageScore": 82.0,
    },
  ];

  // Mock data for upcoming deadlines
  final List<Map<String, dynamic>> _upcomingDeadlines = [
    {
      "id": 1,
      "examTitle": "Database Management Systems Midterm",
      "courseName": "CS 401 - Database Systems",
      "dueDate": DateTime.now().add(const Duration(hours: 6)),
    },
    {
      "id": 2,
      "examTitle": "Data Structures Final Exam",
      "courseName": "CS 301 - Data Structures",
      "dueDate": DateTime.now().add(const Duration(days: 2, hours: 14)),
    },
    {
      "id": 3,
      "examTitle": "Software Engineering Quiz",
      "courseName": "CS 350 - Software Engineering",
      "dueDate": DateTime.now().add(const Duration(days: 5)),
    },
    {
      "id": 4,
      "examTitle": "Machine Learning Assignment",
      "courseName": "CS 450 - ML",
      "dueDate": DateTime.now().add(const Duration(days: 7, hours: 10)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _showWelcomeNotification();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showWelcomeNotification() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _currentNotification = {
            "type": "exam",
            "title": "New Exam Available",
            "message":
                "Database Management Systems Midterm is now available. Due in 6 hours.",
            "timestamp": DateTime.now(),
            "isUrgent": true,
          };
        });
      }
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate Firebase sync
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _currentNotification = {
          "type": "info",
          "title": "Data Synced",
          "message": "Your exam data has been updated successfully.",
          "timestamp": DateTime.now(),
          "isUrgent": false,
        };
      });

      // Auto-dismiss sync notification
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _currentNotification = null;
          });
        }
      });
    }
  }

  void _handleExamTap(Map<String, dynamic> exam) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildExamDetailsBottomSheet(exam),
    );
  }

  void _handleStartExam(Map<String, dynamic> exam) {
    // Check if exam is overdue
    final deadline = exam['deadline'] as DateTime;
    if (deadline.isBefore(DateTime.now())) {
      _showErrorNotification('This exam is overdue and cannot be started.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start Exam'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you ready to start "${exam['title']}"?'),
            SizedBox(height: 2.h),
            Text(
              'Duration: ${exam['duration']} minutes\nQuestions: ${exam['questionCount']}\nDifficulty: ${exam['difficulty']}',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.warningLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: AppTheme.warningLight,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Once started, the timer cannot be paused.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to exam screen
              _showSuccessNotification('Exam started successfully!');
            },
            child: Text('Start Exam'),
          ),
        ],
      ),
    );
  }

  void _handleDeadlineTap(Map<String, dynamic> deadline) {
    // Find the corresponding exam
    final exam = _availableExams.firstWhere(
      (e) => e['title'] == deadline['examTitle'],
      orElse: () => {},
    );

    if (exam.isNotEmpty) {
      _handleExamTap(exam);
    }
  }

  void _showSuccessNotification(String message) {
    setState(() {
      _currentNotification = {
        "type": "result",
        "title": "Success",
        "message": message,
        "timestamp": DateTime.now(),
        "isUrgent": false,
      };
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentNotification = null;
        });
      }
    });
  }

  void _showErrorNotification(String message) {
    setState(() {
      _currentNotification = {
        "type": "error",
        "title": "Error",
        "message": message,
        "timestamp": DateTime.now(),
        "isUrgent": true,
      };
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _currentNotification = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            NotificationBanner(
              notification: _currentNotification,
              onDismiss: () {
                setState(() {
                  _currentNotification = null;
                });
              },
              onTap: () {
                // Handle notification tap
              },
            ),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDashboardTab(),
                  _buildExamsTab(),
                  _buildResultsTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(6.w),
            ),
            child: Center(
              child: Text(
                'JS',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'John Smith',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  _showNotificationHistory();
                },
                icon: CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              if (_notificationBadgeCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(0.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 5.w,
                      minHeight: 5.w,
                    ),
                    child: Text(
                      _notificationBadgeCount > 9
                          ? '9+'
                          : _notificationBadgeCount.toString(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: () {
              // Navigate to settings
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Dashboard'),
          Tab(text: 'Exams'),
          Tab(text: 'Results'),
          Tab(text: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 1.h),
            AvailableExamsCard(
              exams: _availableExams,
              onExamTap: _handleExamTap,
              onStartExam: _handleStartExam,
            ),
            RecentResultsCard(
              results: _recentResults,
              onViewAll: () {
                _tabController.animateTo(2);
              },
            ),
            ProgressTrackingCard(
              courses: _courseProgress,
              onViewDetails: () {
                // Navigate to detailed progress view
              },
            ),
            UpcomingDeadlinesCard(
              deadlines: _upcomingDeadlines,
              onDeadlineTap: _handleDeadlineTap,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildExamsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 1.h),
          AvailableExamsCard(
            exams: _availableExams,
            onExamTap: _handleExamTap,
            onStartExam: _handleStartExam,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildResultsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 1.h),
          RecentResultsCard(
            results: _recentResults,
            onViewAll: () {
              // Show all results
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.secondary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    child: Center(
                      child: Text(
                        'JS',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'John Smith',
                    style: AppTheme.lightTheme.textTheme.headlineSmall,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Student ID: 2021CS001',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'john.smith@university.edu',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  _buildProfileOption(
                    icon: 'person',
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: 'security',
                    title: 'Change Password',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: 'notifications',
                    title: 'Notification Settings',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: 'help',
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: 'logout',
                    title: 'Logout',
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/registration-screen',
                        (route) => false,
                      );
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_right',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildExamDetailsBottomSheet(Map<String, dynamic> exam) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            exam['title'] as String,
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            exam['courseName'] as String,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: 'schedule',
                  label: 'Duration',
                  value: '${exam['duration']} min',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  icon: 'quiz',
                  label: 'Questions',
                  value: '${exam['questionCount']}',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: 'trending_up',
                  label: 'Difficulty',
                  value: exam['difficulty'] as String,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  icon: 'event',
                  label: 'Status',
                  value: exam['attemptStatus'] as String,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleStartExam(exam);
                  },
                  child: Text('Start Exam'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  void _showNotificationHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 70.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Row(
              children: [
                Text(
                  'Notifications',
                  style: AppTheme.lightTheme.textTheme.headlineSmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _notificationBadgeCount = 0;
                    });
                  },
                  child: Text('Mark All Read'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView(
                children: [
                  _buildNotificationItem(
                    type: 'exam',
                    title: 'New Exam Available',
                    message:
                        'Database Management Systems Midterm is now available.',
                    timestamp:
                        DateTime.now().subtract(const Duration(minutes: 30)),
                    isRead: false,
                  ),
                  _buildNotificationItem(
                    type: 'result',
                    title: 'Exam Result Published',
                    message:
                        'Your Object-Oriented Programming Final result is now available.',
                    timestamp:
                        DateTime.now().subtract(const Duration(hours: 2)),
                    isRead: false,
                  ),
                  _buildNotificationItem(
                    type: 'deadline',
                    title: 'Exam Deadline Reminder',
                    message: 'Software Engineering Quiz is due in 2 days.',
                    timestamp:
                        DateTime.now().subtract(const Duration(hours: 6)),
                    isRead: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String type,
    required String title,
    required String message,
    required DateTime timestamp,
    required bool isRead,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isRead
            ? AppTheme.lightTheme.colorScheme.surface
            : AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getNotificationTypeColor(type).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getNotificationTypeIcon(type),
              color: _getNotificationTypeColor(type),
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  message,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatNotificationTime(timestamp),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!isRead)
            Container(
              width: 2.w,
              height: 2.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
        ],
      ),
    );
  }

  Color _getNotificationTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'exam':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'result':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'deadline':
        return AppTheme.warningLight;
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  String _getNotificationTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'exam':
        return 'assignment';
      case 'result':
        return 'grade';
      case 'deadline':
        return 'schedule';
      default:
        return 'info';
    }
  }

  String _formatNotificationTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
