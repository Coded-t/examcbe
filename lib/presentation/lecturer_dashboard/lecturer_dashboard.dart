import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/active_exams_section.dart';
import './widgets/course_card_widget.dart';
import './widgets/quick_stats_card.dart';
import './widgets/recent_activity_feed.dart';

class LecturerDashboard extends StatefulWidget {
  const LecturerDashboard({Key? key}) : super(key: key);

  @override
  State<LecturerDashboard> createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  // Mock data
  final String lecturerName = "Dr. Sarah Johnson";
  final int totalCourses = 8;
  final int activeExams = 3;
  final int studentCount = 245;

  final List<Map<String, dynamic>> recentActivities = [
    {
      "type": "submission",
      "studentName": "Michael Chen",
      "examName": "Data Structures Midterm",
      "courseName": "CS 201",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
    },
    {
      "type": "completion",
      "studentName": "Emma Rodriguez",
      "examName": "Algorithm Analysis Quiz",
      "courseName": "CS 301",
      "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      "type": "enrollment",
      "studentName": "James Wilson",
      "courseName": "Database Systems",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "type": "submission",
      "studentName": "Lisa Thompson",
      "examName": "Software Engineering Final",
      "courseName": "CS 401",
      "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
    },
    {
      "type": "completion",
      "studentName": "David Park",
      "examName": "Web Development Project",
      "courseName": "CS 350",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  final List<Map<String, dynamic>> activeExamsList = [
    {
      "id": 1,
      "name": "Data Structures Midterm",
      "courseName": "CS 201 - Data Structures",
      "participantCount": 45,
      "endTime": DateTime.now().add(const Duration(hours: 2, minutes: 30)),
      "status": "active",
    },
    {
      "id": 2,
      "name": "Algorithm Analysis Quiz",
      "courseName": "CS 301 - Advanced Algorithms",
      "participantCount": 32,
      "endTime": DateTime.now().add(const Duration(minutes: 45)),
      "status": "active",
    },
    {
      "id": 3,
      "name": "Database Design Final",
      "courseName": "CS 402 - Database Systems",
      "participantCount": 28,
      "endTime": DateTime.now().subtract(const Duration(minutes: 15)),
      "status": "expired",
    },
  ];

  final List<Map<String, dynamic>> coursesList = [
    {
      "id": 1,
      "name": "Data Structures and Algorithms",
      "code": "CS 201",
      "studentCount": 45,
      "examCount": 5,
      "status": "active",
      "lastActivity": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "name": "Advanced Algorithms",
      "code": "CS 301",
      "studentCount": 32,
      "examCount": 3,
      "status": "active",
      "lastActivity": DateTime.now().subtract(const Duration(hours: 6)),
    },
    {
      "id": 3,
      "name": "Database Systems",
      "code": "CS 402",
      "studentCount": 28,
      "examCount": 4,
      "status": "active",
      "lastActivity": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "id": 4,
      "name": "Software Engineering",
      "code": "CS 401",
      "studentCount": 38,
      "examCount": 6,
      "status": "active",
      "lastActivity": DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
  }

  void _showExamContextMenu(BuildContext context, Map<String, dynamic> exam) {
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
              exam['name'] as String? ?? '',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            _buildBottomSheetOption(
              'View Results',
              'assessment',
              () {
                Navigator.pop(context);
                // Navigate to results
              },
            ),
            _buildBottomSheetOption(
              'Edit Questions',
              'edit',
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/question-bank-screen');
              },
            ),
            _buildBottomSheetOption(
              'Duplicate Exam',
              'content_copy',
              () {
                Navigator.pop(context);
                // Handle duplicate
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption(
      String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _showQuickActionsBottomSheet() {
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
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildBottomSheetOption(
              'Bulk Import Questions',
              'upload_file',
              () {
                Navigator.pop(context);
                // Handle bulk import
              },
            ),
            _buildBottomSheetOption(
              'Export Results',
              'download',
              () {
                Navigator.pop(context);
                // Handle export
              },
            ),
            _buildBottomSheetOption(
              'Create Course',
              'add_circle',
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/course-management-screen');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
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
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning,',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              lecturerName,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Handle notifications
            },
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Courses'),
            Tab(text: 'Exams'),
            Tab(text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildCoursesTab(),
          _buildExamsTab(),
          _buildProfileTab(),
        ],
      ),
      floatingActionButton:
          _tabController.index == 0 || _tabController.index == 2
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.pushNamed(context, '/exam-creation-screen');
                  },
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme
                        .lightTheme.floatingActionButtonTheme.foregroundColor!,
                    size: 24,
                  ),
                  label: Text(
                    'Create Exam',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme
                          .lightTheme.floatingActionButtonTheme.foregroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            QuickStatsCard(
              totalCourses: totalCourses,
              activeExams: activeExams,
              studentCount: studentCount,
              onTap: () {
                // Handle stats drill-down
              },
            ),
            RecentActivityFeed(activities: recentActivities),
            ActiveExamsSection(
              activeExams: activeExamsList,
              onExamTap: (exam) {
                // Handle exam tap
              },
              onExamLongPress: (exam) {
                _showExamContextMenu(context, exam);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            ...coursesList.map((course) => CourseCardWidget(
                  course: course,
                  onTap: () {
                    Navigator.pushNamed(context, '/course-management-screen');
                  },
                  onEdit: () {
                    // Handle edit course
                  },
                  onArchive: () {
                    // Handle archive course
                  },
                )),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildExamsTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            ActiveExamsSection(
              activeExams: activeExamsList,
              onExamTap: (exam) {
                // Handle exam tap
              },
              onExamLongPress: (exam) {
                _showExamContextMenu(context, exam);
              },
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: ElevatedButton.icon(
                onPressed: _showQuickActionsBottomSheet,
                icon: CustomIconWidget(
                  iconName: 'more_horiz',
                  color: AppTheme
                      .lightTheme.elevatedButtonTheme.style?.foregroundColor
                      ?.resolve({}),
                  size: 20,
                ),
                label: Text('Quick Actions'),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            SizedBox(height: 4.h),
            CircleAvatar(
              radius: 15.w,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 15.w,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              lecturerName,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Computer Science Department',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),
            _buildProfileOption('Account Settings', 'settings', () {}),
            _buildProfileOption(
                'Notification Preferences', 'notifications', () {}),
            _buildProfileOption('Help & Support', 'help', () {}),
            _buildProfileOption('About', 'info', () {}),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/registration-screen',
                    (route) => false,
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'logout',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 20,
                ),
                label: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_right',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
