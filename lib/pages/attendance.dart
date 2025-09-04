import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class AttendancePage extends StatelessWidget {
  final Color primaryColor = Color(0xFF645BD6); // Purple tone
  final Color cardColor = Colors.white;
  final Color backgroundColor = Color(0xFFF5F6FA);

  // Example attendance data for a week
  final List<double> attendance = [1, 0.8, 0.9, 0.7, 1, 0.6, 0.85];
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'Attendance',
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
        child: Card(
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
                  'Weekly Attendance',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 18),
                SizedBox(
                  height: 220,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 1.2,
                      minY: 0,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 0.2,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${(value * 100).toInt()}%',
                                style: GoogleFonts.poppins(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int idx = value.toInt();
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  days[idx],
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(attendance.length, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: attendance[i],
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(6),
                              width: 22,
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 1,
                                color: primaryColor.withOpacity(0.08),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Tap on bars to see daily attendance.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
