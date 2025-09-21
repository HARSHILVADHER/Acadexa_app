<?php
require_once 'config/database.php';

try {
    // Create study_materials table if it doesn't exist
    $createTable = "
    CREATE TABLE IF NOT EXISTS study_materials (
        id INT(11) AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        code VARCHAR(50) NOT NULL,
        subject VARCHAR(100) NOT NULL,
        type ENUM('notes', 'assignment', 'presentation', 'worksheet', 'reference') NOT NULL,
        description TEXT,
        file_name VARCHAR(255) NOT NULL,
        file_type VARCHAR(20) NOT NULL,
        file_data LONGBLOB NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )";
    
    $pdo->exec($createTable);
    echo "Table created successfully.<br>";
    
    // Sample PDF content (minimal PDF structure)
    $samplePdfContent = "%PDF-1.4
1 0 obj
<<
/Type /Catalog
/Pages 2 0 R
>>
endobj
2 0 obj
<<
/Type /Pages
/Kids [3 0 R]
/Count 1
>>
endobj
3 0 obj
<<
/Type /Page
/Parent 2 0 R
/MediaBox [0 0 612 792]
/Contents 4 0 R
>>
endobj
4 0 obj
<<
/Length 44
>>
stream
BT
/F1 12 Tf
100 700 Td
(Sample Study Material) Tj
ET
endstream
endobj
xref
0 5
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
0000000115 00000 n 
0000000206 00000 n 
trailer
<<
/Size 5
/Root 1 0 R
>>
startxref
300
%%EOF";

    // Sample materials data
    $materials = [
        // Notes
        [
            'title' => 'Physics Chapter 1 - Motion',
            'code' => '12 EM Science',
            'subject' => 'Physics',
            'type' => 'notes',
            'description' => 'Complete notes on motion and kinematics',
            'file_name' => 'physics_motion_notes.pdf',
            'file_type' => 'pdf',
            'file_data' => $samplePdfContent
        ],
        [
            'title' => 'Chemistry Organic Compounds',
            'code' => '12 EM Science',
            'subject' => 'Chemistry',
            'type' => 'notes',
            'description' => 'Detailed notes on organic chemistry',
            'file_name' => 'chemistry_organic_notes.pdf',
            'file_type' => 'pdf',
            'file_data' => $samplePdfContent
        ],
        [
            'title' => 'Mathematics Calculus',
            'code' => '12 EM Science',
            'subject' => 'Mathematics',
            'type' => 'notes',
            'description' => 'Calculus fundamentals and applications',
            'file_name' => 'math_calculus_notes.pdf',
            'file_type' => 'pdf',
            'file_data' => $samplePdfContent
        ],
        
        // Assignments
        [
            'title' => 'Physics Assignment 1',
            'code' => '12 EM Science',
            'subject' => 'Physics',
            'type' => 'assignment',
            'description' => 'Problems on motion and force',
            'file_name' => 'physics_assignment_1.pdf',
            'file_type' => 'pdf',
            'file_data' => $samplePdfContent
        ],
        [
            'title' => 'Chemistry Lab Assignment',
            'code' => '12 EM Science',
            'subject' => 'Chemistry',
            'type' => 'assignment',
            'description' => 'Laboratory experiments and observations',
            'file_name' => 'chemistry_lab_assignment.pdf',
            'file_type' => 'pdf',
            'file_data' => $samplePdfContent
        ],
        
        // Presentations
        [
            'title' => 'Physics Presentation - Waves',
            'code' => '12 EM Science',
            'subject' => 'Physics',
            'type' => 'presentation',
            'description' => 'Introduction to wave mechanics',
            'file_name' => 'physics_waves_presentation.pdf',
            'file_type' => 'pdf',
            'file_data' => $samplePdfContent
        ],
        
        // Worksheets
        [
            'title' => 'Math Practice Worksheet',
            'code' => '12 EM Science',
            'subject' => 'Mathematics',
            'type' => 'worksheet',
            'description' => 'Practice problems for calculus',
            'file_name' => 'math_practice_worksheet.pdf',
            'file_type' => 'pdf',
            'file_data' => $samplePdfContent
        ],
        
        // Reference Materials
        [
            'title' => 'Physics Reference Guide',
            'code' => '12 EM Science',
            'subject' => 'Physics',
            'type' => 'reference',
            'description' => 'Quick reference for physics formulas',
            'file_name' => 'physics_reference_guide.pdf',
            'file_type' => 'pdf',
            'file_data' => $samplePdfContent
        ]
    ];
    
    // Insert sample data
    $stmt = $pdo->prepare("
        INSERT INTO study_materials (title, code, subject, type, description, file_name, file_type, file_data) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ");
    
    foreach ($materials as $material) {
        $stmt->execute([
            $material['title'],
            $material['code'],
            $material['subject'],
            $material['type'],
            $material['description'],
            $material['file_name'],
            $material['file_type'],
            $material['file_data']
        ]);
    }
    
    echo "Sample study materials inserted successfully!<br>";
    echo "Total materials: " . count($materials) . "<br>";
    
    // Display inserted data
    $stmt = $pdo->query("SELECT id, title, subject, type, file_name FROM study_materials ORDER BY type, subject");
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<h3>Inserted Materials:</h3>";
    echo "<table border='1' style='border-collapse: collapse; width: 100%;'>";
    echo "<tr><th>ID</th><th>Title</th><th>Subject</th><th>Type</th><th>File Name</th></tr>";
    
    foreach ($results as $row) {
        echo "<tr>";
        echo "<td>" . $row['id'] . "</td>";
        echo "<td>" . $row['title'] . "</td>";
        echo "<td>" . $row['subject'] . "</td>";
        echo "<td>" . $row['type'] . "</td>";
        echo "<td>" . $row['file_name'] . "</td>";
        echo "</tr>";
    }
    echo "</table>";
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
?>