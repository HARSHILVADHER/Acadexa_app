import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExamPage extends StatefulWidget {
  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  int selectedSection = 0; // 0: Upcoming, 1: Your Exam, 2: Result

  final Color primaryColor = Color(0xFF645BD6);
  final Color cardColor = Colors.white;
  final Color backgroundColor = Color(0xFFF5F6FA);

  // Example data
  final List<Map<String, String>> upcomingExams = [
    {
      'subject': 'Physics',
      'examName': 'Mid Term Exam',
      'dateTime': 'Fri, Sep 12 • 10:00 AM - 12:00 PM',
    },
    {
      'subject': 'Chemistry',
      'examName': 'Unit Test',
      'dateTime': 'Mon, Sep 15 • 9:00 AM - 10:30 AM',
    },
  ];

  final List<Map<String, String>> yourExams = [
    {
      'subject': 'Maths',
      'examName': 'Final Exam',
      'dateTime': 'Wed, Sep 20 • 11:00 AM - 1:00 PM',
    },
  ];

  final List<Map<String, String>> results = [
    {
      'subject': 'Physics',
      'examName': 'Mid Term Exam',
      'score': '78/100',
      'grade': 'B+',
      'status': 'Passed',
    },
    {
      'subject': 'Chemistry',
      'examName': 'Unit Test',
      'score': '92/100',
      'grade': 'A',
      'status': 'Passed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Exams',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(color: primaryColor),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Section Tabs
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  sectionTab('Upcoming', 0),
                  sectionTab('Your Exam', 1),
                  sectionTab('Result', 2),
                ],
              ),
            ),
            SizedBox(height: 18),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (selectedSection == 0) {
                    // Upcoming Exams
                    return ListView.separated(
                      itemCount: upcomingExams.length,
                      separatorBuilder: (_, __) => SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final exam = upcomingExams[index];
                        return examCard(exam);
                      },
                    );
                  } else if (selectedSection == 1) {
                    // Your Exams
                    return ListView.separated(
                      itemCount: yourExams.length,
                      separatorBuilder: (_, __) => SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final exam = yourExams[index];
                        return examCard(exam);
                      },
                    );
                  } else {
                    // Results
                    return ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, __) => SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final result = results[index];
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: Text(
                                  '${result['subject']} - ${result['examName']}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Score: ${result['score']}',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                    Text(
                                      'Grade: ${result['grade']}',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                    Text(
                                      'Status: ${result['status']}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: result['status'] == 'Passed'
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Close'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: resultCard(result),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTab(String title, int index) {
    final bool isSelected = selectedSection == index;
    return Padding(
      padding: EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSection = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: primaryColor.withOpacity(0.15), blurRadius: 8)
                  ]
                : [],
          ),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget examCard(Map<String, String> exam) {
    return Card(
      color: cardColor,
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
    );
  }

  Widget resultCard(Map<String, String> result) {
    return Card(
      color: cardColor,
      elevation: 5,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(Icons.emoji_events, color: primaryColor, size: 32),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result['subject'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    result['examName'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Score: ${result['score'] ?? ''}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    'Grade: ${result['grade'] ?? ''}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    'Status: ${result['status'] ?? ''}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: result['status'] == 'Passed'
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: primaryColor, size: 18),
          ],
        ),
      ),
    );
  }
}
