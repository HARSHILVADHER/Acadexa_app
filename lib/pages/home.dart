import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/user_service.dart';
import '../services/attendance_service.dart';
import '../services/exam_service.dart';
import 'your_batch.dart'; // Import your_batch.dart at the top
import 'timetable.dart';
import 'attendance.dart';
import 'faculty.dart'; // Import faculty.dart for FacultyPage
import 'profile.dart'; // Import profile.dart for ProfilePage
import 'exam.dart'; // Import exam.dart for ExamPage
import 'studymaterial.dart'; // Import studymaterial.dart for StudyMaterialPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Color primaryColor = Color(0xFF645BD6); // Purple tone
  final Color cardColor = Colors.white;
  final Color backgroundColor = Color(0xFFF5F6FA);
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
          todayExams =
              List<Map<String, dynamic>>.from(data['today_exams'] ?? []);
          upcomingExams =
              List<Map<String, dynamic>>.from(data['upcoming_exams'] ?? []);
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top greeting and icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting, $userName',
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          DateFormat('EEE, MMM d  •  h:mm a')
                              .format(DateTime.now()),
                          style: GoogleFonts.poppins(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.notifications_none, color: primaryColor),
                        SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    SharedAxisTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType:
                                      SharedAxisTransitionType.horizontal,
                                  child: ProfilePage(
                                    toggleTheme: () {},
                                  ),
                                ),
                              ),
                            );
                          },
                          child:
                              Icon(Icons.person_outline, color: primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 14),

                // Batch Card
                customCard(
                  icon: Icons.groups,
                  title: 'Your Batch :',
                  subtitle: batchName,
                  iconColor: primaryColor,
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.horizontal,
                          child: YourBatchPage(),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 14),

                // Schedule Card
                scheduleCard(primaryColor, context),
                SizedBox(height: 14),

                // Attendance Card
                attendanceCard(primaryColor, context),
                SizedBox(height: 14),

                // Exam Card
                examCard(primaryColor, context),
                SizedBox(height: 14),

                // Study Materials
                studyMaterialsCard(primaryColor),
                SizedBox(height: 14),

                // Faculty Card
                facultyCard(primaryColor, context),
                SizedBox(height: 24),

                // Quick Links
                Text(
                  'Quick Links',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 14),
                quickLinksCard(primaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, size: 32, color: iconColor),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget scheduleCard(Color primaryColor, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
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
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 32, color: primaryColor),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Schedule',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Next: Physics, 4:00 to 5:00 PM',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget attendanceCard(Color primaryColor, BuildContext context) {
    double attendancePercent = attendancePercentage / 100.0;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
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
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(4),
                child: Image.asset(
                  'assets/icons/user-check.png',
                  width: 44,
                  height: 44,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Attendance',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'till yesterday',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: attendancePercent),
                duration: Duration(seconds: 1),
                builder: (context, value, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: CircularProgressIndicator(
                          value: value,
                          strokeWidth: 5,
                          backgroundColor: primaryColor.withOpacity(0.15),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      ),
                      Text(
                        '${(value * 100).toInt()}%',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Icon(Icons.arrow_forward_ios, color: primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget examCard(Color primaryColor, BuildContext context) {
    if (examLoading) {
      return Card(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(Icons.assignment_turned_in, color: primaryColor, size: 32),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loading Exams...',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    CircularProgressIndicator(
                      color: primaryColor,
                      strokeWidth: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final examsToShow = todayExams.isNotEmpty ? todayExams : upcomingExams;
    final isToday = todayExams.isNotEmpty;
    final title = isToday ? "Your Today's Exam" : "Upcoming Exam";

    if (examsToShow.isEmpty) {
      return InkWell(
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
        borderRadius: BorderRadius.circular(16),
        child: Card(
          color: Colors.white,
          elevation: 5,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(Icons.assignment_turned_in,
                    color: primaryColor, size: 32),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Exams',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'No exams scheduled',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: primaryColor, size: 18),
              ],
            ),
          ),
        ),
      );
    }

    return InkWell(
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
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(Icons.assignment_turned_in, color: primaryColor, size: 32),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // ✅ Prevent overflow
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    if (examsToShow.length == 1)
                      _buildSingleExamInfo(examsToShow[0], primaryColor)
                    else
                      _buildScrollableExamInfo(examsToShow, primaryColor),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: primaryColor, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleExamInfo(
      Map<String, dynamic> exam, Color primaryColor) {
    final examDate = DateTime.parse(exam['exam_date']);
    final dayName = DateFormat('EEEE').format(examDate);
    final formattedDate = DateFormat('MMM dd').format(examDate);

    return Column(
      mainAxisSize: MainAxisSize.min, // ✅ Prevent overflow
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

  Widget _buildScrollableExamInfo(
      List<Map<String, dynamic>> exams, Color primaryColor) {
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

  Widget studyMaterialsCard(Color primaryColor) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
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
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(Icons.menu_book, color: primaryColor, size: 32),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Study Materials',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Access study notes & PDFs',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget facultyCard(Color primaryColor, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
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
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(Icons.person_outline, color: primaryColor, size: 32),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Faculty',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Meet your faculty team',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quickLinksCard(Color primaryColor) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            quickLinkIcon(Icons.assignment, 'Assignments', primaryColor),
            quickLinkIcon(Icons.bookmark_border, 'Bookmarks', primaryColor),
            quickLinkIcon(Icons.chat_bubble_outline, 'Chat', primaryColor),
            quickLinkIcon(Icons.settings_outlined, 'Settings', primaryColor),
          ],
        ),
      ),
    );
  }

  Widget quickLinkIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
