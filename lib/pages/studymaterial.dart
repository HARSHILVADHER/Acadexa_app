import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/study_material_service.dart';

class StudyMaterialPage extends StatefulWidget {
  @override
  _StudyMaterialPageState createState() => _StudyMaterialPageState();
}

class _StudyMaterialPageState extends State<StudyMaterialPage> {
  final Color primaryColor = Color(0xFF645BD6);
  final Color backgroundColor = Color(0xFFF5F6FA);
  
  String selectedType = 'notes';
  Map<String, dynamic> materials = {};
  bool isLoading = true;
  String errorMessage = '';

  final List<Map<String, String>> materialTypes = [
    {'value': 'notes', 'label': 'Notes'},
    {'value': 'assignment', 'label': 'Assignment'},
    {'value': 'presentation', 'label': 'Presentation'},
    {'value': 'worksheet', 'label': 'Worksheet'},
    {'value': 'reference', 'label': 'Reference Material'},
  ];

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  Future<void> _loadMaterials() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await StudyMaterialService.getStudyMaterials(type: selectedType);
      
      if (result['success'] == true) {
        setState(() {
          materials = result['materials'] ?? {};
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = result['message'] ?? 'Failed to load materials';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error occurred';
        isLoading = false;
      });
    }
  }

  Future<void> _downloadMaterial(Map<String, dynamic> material) async {
    try {
      _showSnackBar('Loading ${material['file_name']}...');

      final result = await StudyMaterialService.downloadMaterial(material['id']);
      
      if (result['success'] == true) {
        _showSnackBar('File loaded: ${result['file_name']}');
        _showFileDialog(result['file_name'], result['file_data']);
      } else {
        _showSnackBar(result['message'] ?? 'Failed to load file');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: primaryColor,
      ),
    );
  }

  void _showFileDialog(String fileName, String fileData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          fileName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'File loaded successfully. In a real app, this would open the PDF viewer.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Study Materials',
          style: GoogleFonts.poppins(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          // Type selector
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedType,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: primaryColor),
                style: GoogleFonts.poppins(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedType = newValue;
                    });
                    _loadMaterials();
                  }
                },
                items: materialTypes.map<DropdownMenuItem<String>>((type) {
                  return DropdownMenuItem<String>(
                    value: type['value'],
                    child: Text(type['label']!),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                : errorMessage.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              errorMessage,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadMaterials,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Retry',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _buildMaterialsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialsList() {
    if (materials.isEmpty || materials[selectedType] == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No materials available',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Check back later for new content',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    final typeMaterials = materials[selectedType] as Map<String, dynamic>;
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: typeMaterials.keys.length,
      itemBuilder: (context, index) {
        final subject = typeMaterials.keys.elementAt(index);
        final subjectMaterials = typeMaterials[subject] as List<dynamic>;
        
        return _buildSubjectCard(subject, subjectMaterials);
      },
    );
  }

  Widget _buildSubjectCard(String subject, List<dynamic> subjectMaterials) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Icon(Icons.folder, color: primaryColor, size: 28),
        title: Text(
          subject,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          '${subjectMaterials.length} file${subjectMaterials.length != 1 ? 's' : ''}',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        children: subjectMaterials.map<Widget>((material) {
          return _buildMaterialTile(material);
        }).toList(),
      ),
    );
  }

  Widget _buildMaterialTile(Map<String, dynamic> material) {
    return ListTile(
      leading: Icon(
        _getFileIcon(material['file_type']),
        color: primaryColor,
        size: 24,
      ),
      title: Text(
        material['title'] ?? material['file_name'],
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (material['description'] != null && material['description'].isNotEmpty)
            Text(
              material['description'],
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          SizedBox(height: 4),
          Text(
            material['file_name'],
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.visibility, color: primaryColor),
        onPressed: () => _downloadMaterial(material),
      ),
      onTap: () => _downloadMaterial(material),
    );
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }
}