<?php
// Test attendance API with sample data
require_once 'config/database.php';

// Test with a known email from your database
$test_email = 'harshil@gmail.com'; // Change this to match your database

$input = ['email' => $test_email];

// Simulate the API call
$email = $input['email'];

try {
    // Get student info
    $stmt = $pdo->prepare("SELECT id, name, class_code FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $student = $stmt->fetch();
    
    if (!$student) {
        echo "Student not found for email: $email\n";
        exit();
    }
    
    echo "Student found: " . $student['name'] . " (ID: " . $student['id'] . ")\n";
    
    // Get attendance records for this student by matching student_id first, then by name
    $stmt = $pdo->prepare("
        SELECT a.date, a.status, a.class_code 
        FROM attendance a 
        WHERE a.student_id = ?
        ORDER BY a.date DESC
    ");
    $stmt->execute([$student['id']]);
    $attendance = $stmt->fetchAll();
    
    // If no records found by student_id, try to match by name
    if (empty($attendance)) {
        echo "No records found by student_id, trying name match...\n";
        $stmt = $pdo->prepare("
            SELECT a.date, a.status, a.class_code 
            FROM attendance a 
            WHERE LOWER(a.student_name) = LOWER(?)
            ORDER BY a.date DESC
        ");
        $stmt->execute([$student['name']]);
        $attendance = $stmt->fetchAll();
    }
    
    // If still no records, try partial name match
    if (empty($attendance)) {
        echo "No records found by exact name, trying partial match...\n";
        $stmt = $pdo->prepare("
            SELECT a.date, a.status, a.class_code 
            FROM attendance a 
            WHERE LOWER(a.student_name) LIKE LOWER(?)
            ORDER BY a.date DESC
        ");
        $stmt->execute(['%' . $student['name'] . '%']);
        $attendance = $stmt->fetchAll();
    }
    
    echo "Found " . count($attendance) . " attendance records\n";
    
    // Calculate attendance percentage
    $totalDays = count($attendance);
    $presentDays = 0;
    
    foreach ($attendance as $record) {
        if ($record['status'] === 'present') {
            $presentDays++;
        }
    }
    
    $percentage = $totalDays > 0 ? round(($presentDays / $totalDays) * 100) : 0;
    
    echo "Overall attendance: $presentDays/$totalDays = $percentage%\n";
    
    // Group attendance by subject/class
    $subjectAttendance = [];
    foreach ($attendance as $record) {
        $classCode = $record['class_code'];
        if (!isset($subjectAttendance[$classCode])) {
            $subjectAttendance[$classCode] = [
                'total' => 0,
                'present' => 0,
                'percentage' => 0
            ];
        }
        
        $subjectAttendance[$classCode]['total']++;
        if ($record['status'] === 'present') {
            $subjectAttendance[$classCode]['present']++;
        }
        
        $subjectAttendance[$classCode]['percentage'] = 
            round(($subjectAttendance[$classCode]['present'] / $subjectAttendance[$classCode]['total']) * 100);
    }
    
    echo "Subject-wise attendance:\n";
    foreach ($subjectAttendance as $subject => $data) {
        echo "- $subject: {$data['present']}/{$data['total']} = {$data['percentage']}%\n";
    }
    
} catch (PDOException $e) {
    echo "Database error: " . $e->getMessage() . "\n";
}
?>