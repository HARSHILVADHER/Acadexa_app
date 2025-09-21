import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/exam_service.dart';

class ExamPage extends StatefulWidget {
  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  int selectedSection = 0; // 0: Upcoming, 1: Your Exam, 2: Result

  final Color primaryColor = Color(0xFF645BD6);
  final Color cardColor = Colors.white;
  final Color backgroundColor = Color(0xFFF5F6FA);

  List<Map<String, dynamic>> upcomingExams = [];
  List<Map<String, dynamic>> todayExams = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  Future<void> _loadExams() async {
    try {
      final data = await ExamService.getExams();
      if (data['success'] == true) {
        setState(() {
          upcomingExams = List<Map<String, dynamic>>.from(data['upcoming_exams'] ?? []);
          todayExams = List<Map<String, dynamic>>.from(data['today_exams'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() {
          error = data['error'] ?? 'Failed to load exams';
          isLoading = false;
        });
      }
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
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        'Failed to load exams',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            error = null;
                          });
                          _loadExams();
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Padding(
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
                              if (upcomingExams.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No upcoming exams',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                );
                              }
                              return ListView.separated(
                                itemCount: upcomingExams.length,
                                separatorBuilder: (_, __) => SizedBox(height: 14),
                                itemBuilder: (context, index) {
                                  final exam = upcomingExams[index];
                                  return examCard(exam);
                                },
                              );
                            } else if (selectedSection == 1) {
                              // Today's Exams
                              if (todayExams.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No exams today',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                );
                              }
                              return ListView.separated(
                                itemCount: todayExams.length,
                                separatorBuilder: (_, __) => SizedBox(height: 14),
                                itemBuilder: (context, index) {
                                  final exam = todayExams[index];
                                  return examCard(exam);
                                },
                              );
                            } else {
                              // Results - Empty for now
                              return Center(
                                child: Text(
                                  'Results coming soon',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
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

  Widget examCard(Map<String, dynamic> exam) {
    final examDate = DateTime.parse(exam['exam_date']);
    final dayName = DateFormat('EEEE').format(examDate);
    final formattedDate = DateFormat('MMM dd, yyyy').format(examDate);
    final startTime = exam['start_time'];
    final endTime = exam['end_time'];
    
    return InkWell(
      onTap: () => _showExamDetails(exam),
      child: Card(
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
                      exam['exam_name'] ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$dayName, $formattedDate',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$startTime - $endTime',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
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

  void _showExamDetails(Map<String, dynamic> exam) {
    final examDate = DateTime.parse(exam['exam_date']);
    final dayName = DateFormat('EEEE').format(examDate);
    final formattedDate = DateFormat('MMM dd, yyyy').format(examDate);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          exam['exam_name'] ?? '',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontSize: 18,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Date', '$dayName, $formattedDate'),
              _buildDetailRow('Time', '${exam['start_time']} - ${exam['end_time']}'),
              _buildDetailRow('Total Marks', '${exam['total_marks']}'),
              _buildDetailRow('Passing Marks', '${exam['passing_marks']}'),
              if (exam['notes'] != null && exam['notes'].toString().isNotEmpty)
                _buildDetailRow('Notes', exam['notes']),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'Close',
              style: GoogleFonts.poppins(color: primaryColor),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}