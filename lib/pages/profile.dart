import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../services/user_service.dart';
import '../services/temp_storage.dart';
import 'email.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required Null Function() toggleTheme}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? studentData;
  bool isLoading = true;
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudentProfile();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadStudentProfile() async {
    final profile = await UserService.getStudentProfile();
    setState(() {
      studentData = profile;
      isLoading = false;
      if (profile != null && profile['address'] != null) {
        _addressController.text = profile['address'];
      }
    });
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF645BD6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Color(0xFF645BD6), size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Color(0xFF2D3748),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF645BD6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.location_on_outlined, color: Color(0xFF645BD6), size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  studentData?['address'] ?? 'No address added',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Color(0xFF2D3748),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _showEditAddressDialog,
            icon: Icon(Icons.edit_outlined, color: Color(0xFF645BD6), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, String subtitle, VoidCallback onTap, {bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive 
                    ? Colors.red.withOpacity(0.1) 
                    : Color(0xFF645BD6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon, 
                color: isDestructive ? Colors.red : Color(0xFF645BD6), 
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Color(0xFF2D3748),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF718096),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF645BD6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: Color(0xFF718096)),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text(
              'Logout',
              style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (shouldLogout == true) {
      await _clearUserData();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => EmailLoginPage()),
        (route) => false,
      );
    }
  }

  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_email');
    } catch (e) {
      print('Error clearing SharedPreferences: $e');
    }
    TempStorage.clearAll();
  }

  Future<void> _showEditAddressDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Edit Address',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          content: TextField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: 'Enter your address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF645BD6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF645BD6), width: 2),
              ),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(color: Color(0xFF718096)),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF645BD6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Save',
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                final success = await UserService.updateAddress(_addressController.text);
                Navigator.of(context).pop();
                if (success) {
                  setState(() {
                    if (studentData != null) {
                      studentData!['address'] = _addressController.text;
                    }
                  });
                  _showSnackBar('Address updated successfully!');
                } else {
                  _showSnackBar('Failed to update address');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF645BD6);
    const Color backgroundColor = Color(0xFFF8F9FA);
    const Color cardColor = Colors.white;
    const Color textColor = Color(0xFF2D3748);
    const Color secondaryTextColor = Color(0xFF718096);

    if (isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Profile',
            style: GoogleFonts.inter(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: textColor),
        ),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Profile Header Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      studentData?['name'] ?? 'User',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Roll No: ${studentData?['roll_no']?.toString() ?? 'N/A'}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Personal Information
            _buildInfoSection(
              'Personal Information',
              [
                _buildInfoTile(Icons.email_outlined, 'Email', studentData?['email'] ?? 'N/A'),
                _buildInfoTile(Icons.phone_outlined, 'Contact', studentData?['contact'] ?? 'N/A'),
                _buildInfoTile(Icons.class_outlined, 'Class Code', studentData?['class_code'] ?? 'N/A'),
                _buildAddressTile(),
              ],
            ),
            SizedBox(height: 20),

            // Actions Section
            _buildInfoSection(
              'Actions',
              [
                _buildActionTile(
                  Icons.assessment_outlined,
                  'Attendance Report',
                  'Generate detailed attendance report',
                  () => _showSnackBar('Attendance report generated!'),
                ),
                _buildActionTile(
                  Icons.receipt_long_outlined,
                  'Fees Receipt',
                  'Download fees payment receipt',
                  () => _showSnackBar('Fees receipt generated!'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Settings Section
            _buildInfoSection(
              'Settings',
              [
                _buildActionTile(
                  Icons.brightness_6_outlined,
                  'Change Theme',
                  'Switch between light and dark mode',
                  () => AcadexaApp.of(context)?.toggleTheme(),
                ),
                _buildActionTile(
                  Icons.logout_outlined,
                  'Logout',
                  'Sign out from your account',
                  _handleLogout,
                  isDestructive: true,
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
