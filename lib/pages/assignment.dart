import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AssignmentPage extends StatefulWidget {
  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final Color primaryColor = Color(0xFF2563EB);
  final Color secondaryColor = Color(0xFF1E40AF);
  final Color backgroundColor = Color(0xFFF8FAFC);

  int selectedTab = 0; // 0: Pending, 1: Submitted, 2: Completed

  final List<Map<String, dynamic>> assignments = [
    {
      'id': '1',
      'title': 'Physics Lab Report',
      'subject': 'Physics',
      'description': 'Complete the lab report on Newton\'s Laws of Motion with proper calculations and observations.',
      'dueDate': DateTime.now().add(Duration(days: 2)),
      'status': 'pending',
      'priority': 'high',
      'marks': 25,
      'submittedDate': null,
    },
    {
      'id': '2',
      'title': 'Chemistry Assignment',
      'subject': 'Chemistry',
      'description': 'Solve problems from Chapter 3: Chemical Bonding. Include molecular structures.',
      'dueDate': DateTime.now().add(Duration(days: 5)),
      'status': 'pending',
      'priority': 'medium',
      'marks': 20,
      'submittedDate': null,
    },
    {
      'id': '3',
      'title': 'Math Problem Set',
      'subject': 'Mathematics',
      'description': 'Complete exercises 1-15 from Calculus chapter on derivatives.',
      'dueDate': DateTime.now().subtract(Duration(days: 1)),
      'status': 'submitted',
      'priority': 'high',
      'marks': 30,
      'submittedDate': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'id': '4',
      'title': 'Biology Project',
      'subject': 'Biology',
      'description': 'Research project on photosynthesis process with diagrams.',
      'dueDate': DateTime.now().subtract(Duration(days: 7)),
      'status': 'completed',
      'priority': 'medium',
      'marks': 35,
      'submittedDate': DateTime.now().subtract(Duration(days: 8)),
      'grade': 'A',
      'feedback': 'Excellent work! Well-researched and presented.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryColor, secondaryColor],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Assignments',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_getFilteredAssignments().length} assignments',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildTab('Pending', 0)),
                  Expanded(child: _buildTab('Submitted', 1)),
                  Expanded(child: _buildTab('Completed', 2)),
                ],
              ),
            ),

            // Assignments List
            Expanded(
              child: _buildAssignmentsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final bool isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: isSelected ? primaryColor : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentsList() {
    final filteredAssignments = _getFilteredAssignments();

    if (filteredAssignments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredAssignments.length,
      itemBuilder: (context, index) {
        return _buildAssignmentCard(filteredAssignments[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;
    
    switch (selectedTab) {
      case 0:
        message = 'No pending assignments';
        icon = Icons.assignment_turned_in;
        break;
      case 1:
        message = 'No submitted assignments';
        icon = Icons.upload_file;
        break;
      case 2:
        message = 'No completed assignments';
        icon = Icons.check_circle;
        break;
      default:
        message = 'No assignments';
        icon = Icons.assignment;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 48, color: Colors.grey[400]),
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Check back later for updates',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment) {
    final dueDate = assignment['dueDate'] as DateTime;
    final isOverdue = dueDate.isBefore(DateTime.now()) && assignment['status'] == 'pending';
    final priority = assignment['priority'] as String;
    
    Color priorityColor;
    switch (priority) {
      case 'high':
        priorityColor = Colors.red;
        break;
      case 'medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return GestureDetector(
      onTap: () => _showAssignmentDetails(assignment),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isOverdue ? Border.all(color: Colors.red.withOpacity(0.3), width: 1) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          assignment['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                assignment['subject'],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: priorityColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                priority.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: priorityColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${assignment['marks']} marks',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Description
              Text(
                assignment['description'],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOverdue ? 'Overdue' : 'Due Date',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isOverdue ? Colors.red : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy').format(dueDate),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isOverdue ? Colors.red : Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  _buildStatusChip(assignment),
                ],
              ),

              // Grade and Feedback (for completed assignments)
              if (assignment['status'] == 'completed') ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Grade: ',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            assignment['grade'] ?? 'N/A',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      if (assignment['feedback'] != null) ...[
                        SizedBox(height: 8),
                        Text(
                          'Feedback: ${assignment['feedback']}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAssignmentDetails(Map<String, dynamic> assignment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      assignment['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      assignment['description'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Due Date', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                              Text(DateFormat('MMM dd, yyyy').format(assignment['dueDate']), style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Marks', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                              Text('${assignment['marks']} marks', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Subject', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                              Text(assignment['subject'], style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (assignment['status'] == 'pending')
              Container(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: Text('Submit Assignment', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                          content: Text('Are you sure you want to submit "${assignment['title']}"?', style: GoogleFonts.poppins()),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey[600])),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  assignment['status'] = 'submitted';
                                  assignment['submittedDate'] = DateTime.now();
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Assignment submitted successfully!'), backgroundColor: Colors.green),
                                );
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                              child: Text('Submit', style: GoogleFonts.poppins(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Submit Assignment',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(Map<String, dynamic> assignment) {
    final status = assignment['status'] as String;
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        text = 'Pending';
        icon = Icons.schedule;
        break;
      case 'submitted':
        color = Colors.blue;
        text = 'Submitted';
        icon = Icons.upload_file;
        break;
      case 'completed':
        color = Colors.green;
        text = 'Completed';
        icon = Icons.check_circle;
        break;
      default:
        color = Colors.grey;
        text = 'Unknown';
        icon = Icons.help;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredAssignments() {
    switch (selectedTab) {
      case 0:
        return assignments.where((a) => a['status'] == 'pending').toList();
      case 1:
        return assignments.where((a) => a['status'] == 'submitted').toList();
      case 2:
        return assignments.where((a) => a['status'] == 'completed').toList();
      default:
        return assignments;
    }
  }
}