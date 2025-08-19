import 'package:flutter/material.dart';
import '../presentation/exam_creation_screen/exam_creation_screen.dart';
import '../presentation/lecturer_dashboard/lecturer_dashboard.dart';
import '../presentation/student_dashboard/student_dashboard.dart';
import '../presentation/question_bank_screen/question_bank_screen.dart';
import '../presentation/course_management_screen/course_management_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String examCreation = '/exam-creation-screen';
  static const String lecturerDashboard = '/lecturer-dashboard';
  static const String studentDashboard = '/student-dashboard';
  static const String questionBank = '/question-bank-screen';
  static const String courseManagement = '/course-management-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const ExamCreationScreen(),
    examCreation: (context) => const ExamCreationScreen(),
    lecturerDashboard: (context) => const LecturerDashboard(),
    studentDashboard: (context) => const StudentDashboard(),
    questionBank: (context) => const QuestionBankScreen(),
    courseManagement: (context) => const CourseManagementScreen(),
    // TODO: Add your other routes here
  };
}
