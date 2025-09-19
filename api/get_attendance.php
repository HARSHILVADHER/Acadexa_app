<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/database.php';

// Handle both GET and POST requests
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    $email = $input['email'] ?? null;
} else if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $email = $_GET['email'] ?? 'harshil@gmail.com'; // Default for testing
} else {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit();
}

if (!$email) {
    http_response_code(400);
    echo json_encode(['error' => 'Email is required']);
    exit();
}

try {
    // Get student info
    $stmt = $pdo->prepare("SELECT id, name, class_code FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $student = $stmt->fetch();
    
    if (!$student) {
        http_response_code(404);
        echo json_encode(['error' => 'Student not found']);
        exit();
    }
    
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
        $stmt = $pdo->prepare("
            SELECT a.date, a.status, a.class_code 
            FROM attendance a 
            WHERE LOWER(a.student_name) LIKE LOWER(?)
            ORDER BY a.date DESC
        ");
        $stmt->execute(['%' . $student['name'] . '%']);
        $attendance = $stmt->fetchAll();
    }
    
    // Calculate attendance percentage
    $totalDays = count($attendance);
    $presentDays = 0;
    
    foreach ($attendance as $record) {
        if ($record['status'] === 'present') {
            $presentDays++;
        }
    }
    
    $percentage = $totalDays > 0 ? round(($presentDays / $totalDays) * 100) : 0;
    
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
    
    echo json_encode([
        'success' => true,
        'student_name' => $student['name'],
        'overall_percentage' => $percentage,
        'total_days' => $totalDays,
        'present_days' => $presentDays,
        'attendance_records' => $attendance,
        'subject_attendance' => $subjectAttendance
    ]);
    
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>