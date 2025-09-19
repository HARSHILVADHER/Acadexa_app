import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/attendance_service.dart';
import 'package:intl/intl.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final Color primaryColor = Color(0xFF4CAF50);
  final Color backgroundColor = Color(0xFFF5F6FA);
  final Color cardColor = Colors.white;
  
  Map<String, dynamic>? attendanceData;
  bool isLoading = true;
  String? error;
  
  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }
  
  Future<void> _loadAttendance() async {
    try {
      final data = await AttendanceService.getAttendance();
      setState(() {
        attendanceData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Attendance',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.white, size: 48),
                      SizedBox(height: 16),
                      Text(
                        'Failed to load attendance',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            error = null;
                          });
                          _loadAttendance();
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Attendance',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAttendanceHeader(),
                              SizedBox(height: 20),
                              _buildDateSection(),
                              SizedBox(height: 20),
                              _buildLegend(),
                              SizedBox(height: 20),
                              Expanded(child: _buildSubjectsList()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
  
  Widget _buildAttendanceHeader() {
    final percentage = attendanceData?['overall_percentage'] ?? 0;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Colors.grey[600],
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Attendance',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Till Yesterday',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$percentage%',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDateSection() {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    final today = now;
    
    return Column(
      children: [
        _buildDateRow('Yesterday', DateFormat('dd MMM yyyy').format(yesterday)),
        SizedBox(height: 12),
        _buildDateRow('Today', DateFormat('dd MMM yyyy').format(today)),
      ],
    );
  }
  
  Widget _buildDateRow(String label, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          date,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  Widget _buildLegend() {
    return Row(
      children: [
        _buildLegendItem('Lab', Color(0xFF2E7D32)),
        SizedBox(width: 20),
        _buildLegendItem('Theory', primaryColor),
        SizedBox(width: 20),
        _buildLegendItem('Workshop', Color(0xFF7B1FA2)),
      ],
    );
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSubjectsList() {
    final subjectAttendance = attendanceData?['subject_attendance'] as Map<String, dynamic>? ?? {};
    
    if (subjectAttendance.isEmpty) {
      return Center(
        child: Text(
          'No attendance data available',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }
    
    return ListView.builder(
      itemCount: subjectAttendance.length,
      itemBuilder: (context, index) {
        final subject = subjectAttendance.keys.elementAt(index);
        final data = subjectAttendance[subject];
        final percentage = data['percentage'] ?? 0;
        
        return _buildSubjectCard(subject, percentage);
      },
    );
  }
  
  Widget _buildSubjectCard(String subject, int percentage) {
    Color barColor;
    if (percentage >= 75) {
      barColor = primaryColor;
    } else if (percentage >= 50) {
      barColor = Colors.orange;
    } else {
      barColor = Colors.red;
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            child: Text(
              subject,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: percentage / 100.0,
                    child: Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        '$percentage',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: percentage > 50 ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
