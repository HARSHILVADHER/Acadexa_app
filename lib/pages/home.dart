import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/user_service.dart';
import '../services/attendance_service.dart';
import '../services/exam_service.dart';
import 'your_batch.dart';
import 'timetable.dart';
import 'attendance.dart';
import 'faculty.dart';
import 'profile.dart';
import 'exam.dart';
import 'studymaterial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Color primaryColor = Color(0xFF2563EB);
  final Color secondaryColor = Color(0xFF1E40AF);
  final Color accentColor = Color(0xFF3B82F6);
  final Color cardColor = Colors.white;
  final Color backgroundColor = Color(0xFFF8FAFC);
  
  String userName = 'User';
  String greeting = 'Hello';
  String batchName = '';
  int attendancePercentage = 0;
  List<Map<String, dynamic>> todayExams = [];
  List<Map<String, dynamic>> upcomingExams = [];
  bool examLoading = true;
  PageController _examPageController = PageController();
  int _currentExamIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _examPageController.dispose();
    super.dispose();
  }

  _loadUserData() async {
    final name = await UserService.getUserName();
    final greet = UserService.getGreeting();
    final batch = await UserService.getBatchName();

    try {
      final attendanceData = await AttendanceService.getOverallAttendance();
      final percentage = attendanceData['overall_percentage'] ?? 0;
      setState(() {
        userName = name;
        greeting = greet;
        batchName = batch;
        attendancePercentage = percentage;
      });
    } catch (e) {
      setState(() {
        userName = name;
        greeting = greet;
        batchName = batch;
        attendancePercentage = 0;
      });
    }

    _loadExamData();
  }

  _loadExamData() async {
    try {
      final data = await ExamService.getExams();
      if (data['success'] == true) {
        setState(() {
          todayExams = List<Map<String, dynamic>>.from(data['today_exams'] ?? []);
          upcomingExams = List<Map<String, dynamic>>.from(data['upcoming_exams'] ?? []);
          examLoading = false;
        });
      } else {
        setState(() {
          examLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        examLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Modern Header with gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, secondaryColor],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  children: [
                    // Top row with greeting and icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$greeting!',
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                userName,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.notifications_none, 
                                color: Colors.white, size: 20),
                            ),
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    transitionDuration: Duration(milliseconds: 500),
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType: SharedAxisTransitionType.horizontal,
                                      child: ProfilePage(toggleTheme: () {}),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.person_outline, 
                                  color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Date and time
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        DateFormat('EEEE, MMMM d • h:mm a').format(DateTime.now()),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick stats row
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Attendance',
                              '${attendancePercentage}%',
                              Icons.check_circle_outline,
                              attendancePercentage >= 75 ? Colors.green : Colors.orange,
                              () => Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: Duration(milliseconds: 500),
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      SharedAxisTransition(
                                    animation: animation,
                                    secondaryAnimation: secondaryAnimation,
                                    transitionType: SharedAxisTransitionType.horizontal,
                                    child: AttendancePage(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Batch',
                              batchName.isNotEmpty ? batchName : 'Loading...',
                              Icons.groups_outlined,
                              accentColor,
                              () => Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: Duration(milliseconds: 500),
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      SharedAxisTransition(
                                    animation: animation,
                                    secondaryAnimation: secondaryAnimation,
                                    transitionType: SharedAxisTransitionType.horizontal,
                                    child: YourBatchPage(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      
                      // Main features grid
                      Text(
                        'Today\'s Overview',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Schedule and Exam cards
                      _buildModernCard(
                        icon: Icons.schedule,
                        title: 'Today\'s Schedule',
                        subtitle: 'Next: Physics, 4:00 to 5:00 PM',
                        color: primaryColor,
                        onTap: () => Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                SharedAxisTransition(
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType: SharedAxisTransitionType.horizontal,
                              child: TimetablePage(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      examCard(primaryColor, context),
                      SizedBox(height: 24),
                      
                      // Services section
                      Text(
                        'Academic Services',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Services grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                        children: [
                          _buildServiceCard(
                            icon: Icons.menu_book,
                            title: 'Study Materials',
                            subtitle: 'Notes & Resources',
                            color: Colors.purple,
                            onTap: () => Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    SharedAxisTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType: SharedAxisTransitionType.horizontal,
                                  child: StudyMaterialPage(),
                                ),
                              ),
                            ),
                          ),
                          _buildServiceCard(
                            icon: Icons.people,
                            title: 'Faculty',
                            subtitle: 'Meet Your Teachers',
                            color: Colors.teal,
                            onTap: () => Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    SharedAxisTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType: SharedAxisTransitionType.horizontal,
                                  child: FacultyPage(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      
                      // Quick actions
                      Text(
                        'Quick Actions',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildQuickActionsRow(),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsRow() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickAction(Icons.assignment, 'Assignments', Colors.orange),
          _buildQuickAction(Icons.bookmark_border, 'Bookmarks', Colors.blue),
          _buildQuickAction(Icons.chat_bubble_outline, 'Chat', Colors.green),
          _buildQuickAction(Icons.settings_outlined, 'Settings', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget examCard(Color primaryColor, BuildContext context) {
    if (examLoading) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.assignment_turned_in, color: primaryColor, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loading Exams...',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 2,
                    child: LinearProgressIndicator(
                      color: primaryColor,
                      backgroundColor: primaryColor.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final examsToShow = todayExams.isNotEmpty ? todayExams : upcomingExams;
    final isToday = todayExams.isNotEmpty;
    final title = isToday ? "Today's Exams" : "Upcoming Exams";

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: ExamPage(),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: examsToShow.isEmpty ? Colors.grey.withOpacity(0.1) : primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.assignment_turned_in, 
                color: examsToShow.isEmpty ? Colors.grey : primaryColor, 
                size: 24
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    examsToShow.isEmpty ? 'No Exams' : title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  if (examsToShow.isEmpty)
                    Text(
                      'No exams scheduled',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    )
                  else if (examsToShow.length == 1)
                    _buildSingleExamInfo(examsToShow[0], primaryColor)
                  else
                    _buildScrollableExamInfo(examsToShow, primaryColor),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleExamInfo(Map<String, dynamic> exam, Color primaryColor) {
    final examDate = DateTime.parse(exam['exam_date']);
    final dayName = DateFormat('EEEE').format(examDate);
    final formattedDate = DateFormat('MMM dd').format(examDate);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exam['exam_name'] ?? '',
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '$dayName, $formattedDate',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${exam['start_time']} - ${exam['end_time']}',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableExamInfo(List<Map<String, dynamic>> exams, Color primaryColor) {
    return Column(
      children: [
        Container(
          height: 70,
          child: PageView.builder(
            controller: _examPageController,
            onPageChanged: (index) {
              setState(() {
                _currentExamIndex = index;
              });
            },
            itemCount: exams.length,
            itemBuilder: (context, index) {
              final exam = exams[index];
              final examDate = DateTime.parse(exam['exam_date']);
              final dayName = DateFormat('EEEE').format(examDate);
              final formattedDate = DateFormat('MMM dd').format(examDate);

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam['exam_name'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '$dayName, $formattedDate',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${exam['start_time']} - ${exam['end_time']}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            exams.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentExamIndex == index
                    ? primaryColor
                    : primaryColor.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}