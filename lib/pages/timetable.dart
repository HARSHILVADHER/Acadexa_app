import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TimetablePage extends StatelessWidget {
  final Color primaryColor = Color(0xFF645BD6);
  final Color cardColor = Colors.white;
  final Color backgroundColor = Color(0xFFF5F6FA);

  // Example timetable data
  final List<Map<String, String>> timetable = [
    {
      'date': '2025-09-04',
      'subject': 'Physics',
      'time': '09:00 - 10:00 AM',
      'teacher': 'Rohit Patel',
    },
    {
      'date': '2025-09-04',
      'subject': 'Chemistry',
      'time': '10:15 - 11:15 AM',
      'teacher': 'Nil Patel',
    },
    {
      'date': '2025-09-05',
      'subject': 'Mathematics',
      'time': '09:00 - 10:00 AM',
      'teacher': 'Amit Shah',
    },
    {
      'date': '2025-09-05',
      'subject': 'Biology',
      'time': '10:15 - 11:15 AM',
      'teacher': 'Sneha Joshi',
    },
    // Add more entries as needed
  ];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = List.generate(7, (i) => today.add(Duration(days: i)));

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Timetable',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(color: primaryColor),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Row
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final date = days[index];
                  final isToday = DateUtils.isSameDay(date, today);
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isToday ? primaryColor : cardColor,
                        foregroundColor: isToday ? cardColor : Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            DateFormat('d MMM').format(date),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 18),
            Text(
              'Upcoming Classes',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: timetable.length,
                itemBuilder: (context, index) {
                  final entry = timetable[index];
                  final date = DateTime.parse(entry['date']!);
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
                          Icon(Icons.menu_book_rounded,
                              size: 32, color: primaryColor),
                          SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEE, d MMM yyyy').format(date),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  entry['subject']!,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  entry['teacher']!,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  entry['time']!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              color: primaryColor, size: 18),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
