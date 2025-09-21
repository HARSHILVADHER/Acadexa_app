import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/attendance_service.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final Color primaryColor = Color(0xFF645BD6); // Purple theme
  final Color backgroundColor = Color(0xFFF5F6FA);
  final Color cardColor = Colors.white;
  
  Map<String, dynamic>? overallData;
  Map<String, dynamic>? todayAttendance;
  Map<String, dynamic>? yesterdayAttendance;
  Map<String, dynamic>? selectedDateAttendance;
  
  bool isLoading = true;
  String? error;
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  bool showCalendar = false;
  
  @override
  void initState() {
    super.initState();
    _loadAllData();
  }
  
  Future<void> _loadAllData() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final yesterday = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));
      
      final results = await Future.wait([
        AttendanceService.getOverallAttendance(),
        AttendanceService.getAttendanceForDate(today),
        AttendanceService.getAttendanceForDate(yesterday),
      ]);
      
      setState(() {
        overallData = results[0];
        todayAttendance = results[1];
        yesterdayAttendance = results[2];
        selectedDateAttendance = results[1]; // Default to today
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }
  
  Future<void> _loadDateAttendance(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    try {
      final data = await AttendanceService.getAttendanceForDate(dateStr);
      setState(() {
        selectedDateAttendance = data;
      });
    } catch (e) {
      setState(() {
        selectedDateAttendance = {'success': false, 'error': e.toString()};
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
                        onPressed: _loadAllData,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAttendanceGraph(),
                              SizedBox(height: 20),
                              _buildTodayYesterdaySection(),
                              if (showCalendar) ...[
                                SizedBox(height: 20),
                                _buildCalendarSection(),
                              ],
                              SizedBox(height: 20),
                              _buildSelectedDateAttendance(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
  
  Widget _buildAttendanceGraph() {
    final percentage = overallData?['overall_percentage'] ?? 0;
    final presentDays = overallData?['present_days'] ?? 0;
    final totalDays = overallData?['total_days'] ?? 0;
    
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage >= 75 ? primaryColor : 
                    percentage >= 50 ? Colors.orange : Colors.red,
                  ),
                ),
              ),
              Text(
                '$percentage%',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Attendance',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '$presentDays out of $totalDays days',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTodayYesterdaySection() {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Attendance',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    showCalendar = !showCalendar;
                  });
                },
                icon: Icon(
                  Icons.calendar_today,
                  color: primaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildDateRow('Today', DateTime.now(), todayAttendance),
          SizedBox(height: 12),
          _buildDateRow('Yesterday', DateTime.now().subtract(Duration(days: 1)), yesterdayAttendance),
        ],
      ),
    );
  }
  
  Widget _buildDateRow(String label, DateTime date, Map<String, dynamic>? attendanceData) {
    String status = 'No attendance';
    Color statusColor = Colors.grey;
    
    if (attendanceData != null && attendanceData['success'] == true) {
      if (attendanceData['has_attendance'] == true) {
        status = attendanceData['status'] == 'present' ? 'Present' : 'Absent';
        statusColor = attendanceData['status'] == 'present' ? Colors.green : Colors.red;
      }
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              DateFormat('dd MMM yyyy').format(date),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Text(
            status,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildCalendarSection() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Date',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDate,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              defaultTextStyle: GoogleFonts.poppins(fontSize: 14),
              weekendTextStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.red),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
                focusedDate = focusedDay;
                showCalendar = false; // Hide calendar after selection
              });
              _loadDateAttendance(selectedDay);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSelectedDateAttendance() {
    String status = 'No attendance';
    Color statusColor = Colors.grey;
    String dateStr = DateFormat('dd MMM yyyy').format(selectedDate);
    
    if (selectedDateAttendance != null && selectedDateAttendance!['success'] == true) {
      if (selectedDateAttendance!['has_attendance'] == true) {
        status = selectedDateAttendance!['status'] == 'present' ? 'Present' : 'Absent';
        statusColor = selectedDateAttendance!['status'] == 'present' ? Colors.green : Colors.red;
      }
    }
    
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance for $dateStr',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    status == 'Present' ? Icons.check_circle : 
                    status == 'Absent' ? Icons.cancel : Icons.help_outline,
                    color: statusColor,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
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
