import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/user_service.dart';
import 'your_batch.dart'; // Import your_batch.dart at the top
import 'timetable.dart';
import 'attendance.dart';
import 'faculty.dart'; // Import faculty.dart for FacultyPage
import 'profile.dart'; // Import profile.dart for ProfilePage
import 'exam.dart'; // Import exam.dart for ExamPage

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
  String batchName = '12 EM Science';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    final name = await UserService.getUserName();
    final greet = UserService.getGreeting();
    final batch = await UserService.getBatchName();
    print('Loaded batch name: $batch'); // Debug print
    setState(() {
      userName = name;
      greeting = greet;
      batchName = batch;
    });
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
                          DateFormat('EEE, MMM d  •  h:mm a').format(DateTime.now()),
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
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
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
                        pageBuilder: (context, animation, secondaryAnimation) =>
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
      // Remove debugShowCheckedModeBanner
    );
  }

  Widget customCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap, // <-- add this
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
    double attendancePercent = 0.80; // 80% attendance

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
              // Remove background color and increase icon size
              Padding(
                padding: EdgeInsets.all(4),
                child: Image.asset(
                  'assets/icons/user-check.png',
                  width: 44, // Increased size
                  height: 44, // Increased size
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
              // Animated Circular Attendance Graph
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
    // Example upcoming exam data
    final Map<String, String> exam = {
      'subject': 'Physics',
      'examName': 'Mid Term Exam',
      'dateTime': 'Fri, Sep 12 • 10:00 AM - 12:00 PM',
    };

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
                  children: [
                    Text(
                      'Upcoming Exam',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      exam['subject'] ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      exam['examName'] ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      exam['dateTime'] ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.black54,
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

  Widget studyMaterialsCard(Color primaryColor) {
    List<String> subjects = ['Physics', 'Chemistry', 'Mathematics', 'Biology'];
    return Card(
      color: Colors.white,
      elevation: 5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book_outlined, color: primaryColor, size: 32),
                SizedBox(width: 20),
                Text(
                  'Your Study Materials',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.7,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 12,
              children: subjects
                  .map(
                    (subject) => ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFFF5F6FA), // Slight gray background
                        foregroundColor: primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        subject,
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 2),
            Align(
              alignment: Alignment.bottomRight,
              child:
                  Icon(Icons.arrow_forward_ios, color: primaryColor, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget facultyCard(Color primaryColor, BuildContext context) {
    final List<Map<String, String>> faculty = [
      {'name': 'Mr. Rohit Patel', 'subject': 'Physics'},
      {'name': 'Mr. Nil Patel', 'subject': 'Maths'},
      {'name': 'Mr. Vishal Jani', 'subject': 'Chemistry'},
    ];

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
      borderRadius: BorderRadius.circular(16), // ripple matches card
      child: Card(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: primaryColor, size: 32),
                  SizedBox(width: 20),
                  Text(
                    'Your Faculty',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              ...faculty.map((f) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          f['name']!,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F6FA),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            f['subject']!,
                            style: GoogleFonts.poppins(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.arrow_forward_ios,
                    color: primaryColor, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quickLinksCard(Color primaryColor) {
    final List<String> links = [
      'Fees',
      'Your Score',
      'Holidays',
      'Gallery',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: links
            .map((title) => Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF5F6FA), // light gray
                      foregroundColor: primaryColor,
                      elevation: 3,
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
