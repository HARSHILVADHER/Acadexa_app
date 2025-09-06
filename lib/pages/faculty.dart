import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FacultyPage extends StatelessWidget {
  final Color primaryColor = Color(0xFF645BD6); // Purple tone
  final Color cardColor = Colors.white;
  final Color backgroundColor = Color(0xFFF5F6FA);

  final List<Map<String, String>> facultyList = [
    {
      'name': 'Rohit Patel',
      'subject': 'Physics',
      'contact': '+91 98765 43210',
      'availability': 'Mon-Fri, 9:00 AM - 12:00 PM',
    },
    {
      'name': 'Nil Patel',
      'subject': 'Maths',
      'contact': '+91 91234 56789',
      'availability': 'Mon-Fri, 1:00 PM - 4:00 PM',
    },
    {
      'name': 'Vishal Jani',
      'subject': 'Chemistry',
      'contact': '+91 99887 77665',
      'availability': 'Tue-Sat, 10:00 AM - 1:00 PM',
    },
    {
      'name': 'Sneha Joshi',
      'subject': 'Biology',
      'contact': '+91 90909 80808',
      'availability': 'Mon, Wed, Fri, 2:00 PM - 5:00 PM',
    },
    // Add more faculty as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Faculty Details',
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
        child: ListView.separated(
          itemCount: facultyList.length,
          separatorBuilder: (_, __) => SizedBox(height: 18),
          itemBuilder: (context, index) {
            final faculty = facultyList[index];
            return Card(
              color: cardColor,
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
                    Text(
                      faculty['name'] ?? '',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Subject: ${faculty['subject'] ?? ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Contact: ${faculty['contact'] ?? ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Available: ${faculty['availability'] ?? ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
