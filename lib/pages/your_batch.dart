import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YourBatchPage extends StatelessWidget {
  final Color primaryColor = Color(0xFF645BD6); // Purple tone
  final Color cardColor = Colors.white;
  final Color backgroundColor = Color(0xFFF5F6FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Your Batch',
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
            Card(
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
                    Icon(Icons.groups, size: 32, color: primaryColor),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Batch Name',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '12 EM Science',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Batch Mentor: Mr. Rohit Patel',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Total Students: 42',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Session: 2025-2026',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Batch Schedule',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 14),
            Card(
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
                    Icon(Icons.calendar_month, size: 32, color: primaryColor),
                    SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next Class',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: '28 Aug 2025\n',
                                  style: TextStyle(fontSize: 14),
                                ),
                                TextSpan(
                                  text: 'CHEMISTRY\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text: '3:00 to 4:00 PM',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Nil Patel',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 22),
                        Icon(Icons.arrow_forward_ios,
                            color: primaryColor, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Batch Students',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 14),
            Expanded(
              child: Card(
                color: cardColor,
                elevation: 5,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: ListView.separated(
                    itemCount: 5,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, index) {
                      final students = [
                        'Harshil Vadher',
                        'Amit Patel',
                        'Priya Shah',
                        'Rahul Mehta',
                        'Sneha Joshi'
                      ];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            students[index],
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          Icon(Icons.person_outline, color: primaryColor),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
