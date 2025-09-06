import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key, required Null Function() toggleTheme}) : super(key: key);

  final Map<String, String> user = {
    'name': 'Harshil Vadher',
    'rollNo': '2025001',
    'email': 'harshilvadher@gmail.com',
    'phone': '+91 98765 43210',
    'address': '123, Main Street, Rajkot, Gujarat',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color primaryColor = theme.primaryColor;
    final Color cardColor = theme.cardColor;
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final secondaryTextColor =
        theme.textTheme.bodyMedium?.color ?? Colors.white70;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: theme.iconTheme,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Card(
              color: cardColor,
              elevation: 5,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: EdgeInsets.all(22),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: primaryColor.withOpacity(0.1),
                      child: Icon(Icons.person, size: 48, color: primaryColor),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'] ?? '',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Roll No: ${user['rollNo'] ?? ''}',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            user['email'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: secondaryTextColor,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            user['phone'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: secondaryTextColor,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            user['address'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 28),

            // Generate Report Section
            Text(
              'Generate Report',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: textColor,
              ),
            ),
            SizedBox(height: 12),
            Card(
              color: cardColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Attendance report generated!')),
                        );
                      },
                      icon: Icon(Icons.bar_chart, color: primaryColor),
                      label: Text(
                        'Attendance',
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Fees receipt generated!')),
                        );
                      },
                      icon: Icon(Icons.receipt_long, color: primaryColor),
                      label: Text(
                        'Fees Receipt',
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 28),

            // Settings Section
            Text(
              'Settings',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: textColor,
              ),
            ),
            SizedBox(height: 12),
            Card(
              color: cardColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.redAccent),
                    title: Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                    onTap: () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Logout'),
                          content: Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: Text('Logout'),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        ),
                      );
                      if (shouldLogout == true) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      }
                    },
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.brightness_6, color: primaryColor),
                    title: Text(
                      'Change Theme',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                    onTap: () {
                      AcadexaApp.of(context)?.toggleTheme();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
