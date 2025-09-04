import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'your_batch.dart'; // Import your_batch.dart at the top
import 'timetable.dart';
import 'attendance.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color primaryColor = Color(0xFF645BD6); // Purple tone
  final Color cardColor = Colors.white;
  final Color backgroundColor = Color(0xFFF5F6FA);

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
                          'Hello , Harshil',
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tue, Aug 26  •  11:38 AM',
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
                        Icon(Icons.person_outline, color: primaryColor),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 14),

                // Batch Card
                customCard(
                  icon: Icons.groups,
                  title: 'Your Batch :',
                  subtitle: '12 EM Science',
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

                // Study Materials
                studyMaterialsCard(primaryColor),
                SizedBox(height: 14),

                // Faculty Card
                facultyCard(primaryColor),
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
              Icon(Icons.person_pin_circle_rounded,
                  size: 32, color: primaryColor),
              SizedBox(width: 20),
              Column(
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

  Widget facultyCard(Color primaryColor) {
    final List<Map<String, String>> faculty = [
      {'name': 'Mr. Rohit Patel', 'subject': 'Physics'},
      {'name': 'Mr. Nil Patel', 'subject': 'Maths'},
      {'name': 'Mr. Vishal Jani', 'subject': 'Chemistry'},
    ];
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
              child:
                  Icon(Icons.arrow_forward_ios, color: primaryColor, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget quickLinksCard(Color primaryColor) {
    final List<List<String>> links = [
      ['Fees', 'Your Score'],
      ['Holidays', 'Gallery'],
    ];
    return Column(
      children: links
          .map((row) => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: row
                    .map((title) => Padding(
                          padding: EdgeInsets.only(right: 20, bottom: 12),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFF5F6FA), // light gray
                              foregroundColor: primaryColor,
                              elevation: 3,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 14),
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
              ))
          .toList(),
    );
  }
}
