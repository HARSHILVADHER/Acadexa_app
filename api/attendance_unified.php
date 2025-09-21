<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

require_once 'config/database.php';

// Get parameters
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    $email = $input['email'] ?? null;
    $date = $input['date'] ?? null;
} else {
    $email = $_GET['email'] ?? null;
    $date = $_GET['date'] ?? null;
}

// Debug output
error_log("Email: " . $email);
error_log("Date: " . $date);

if (!$email) {
    echo json_encode(['success' => false, 'error' => 'Email is required']);
    exit();
}

try {
    // Get student name from email
    $stmt = $pdo->prepare("SELECT name FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $student = $stmt->fetch();
    
    if (!$student) {
        echo json_encode(['success' => false, 'error' => 'Student not found']);
        exit();
    }
    
    $studentName = $student['name'];
    error_log("Student name: " . $studentName);
    
    if ($date) {
        // Get attendance for specific date
        $stmt = $pdo->prepare("SELECT status FROM attendance WHERE student_name = ? AND date = ?");
        $stmt->execute([$studentName, $date]);
        $attendance = $stmt->fetch();
        
        if ($attendance) {
            echo json_encode([
                'success' => true,
                'has_attendance' => true,
                'status' => $attendance['status'],
                'date' => $date,
                'student_name' => $studentName
            ]);
        } else {
            echo json_encode([
                'success' => true,
                'has_attendance' => false,
                'status' => null,
                'date' => $date,
                'student_name' => $studentName
            ]);
        }
    } else {
        // Get overall attendance
        $stmt = $pdo->prepare("SELECT date, status FROM attendance WHERE student_name = ? ORDER BY date DESC");
        $stmt->execute([$studentName]);
        $records = $stmt->fetchAll();
        
        $total = count($records);
        $present = 0;
        
        foreach ($records as $record) {
            if ($record['status'] === 'present') {
                $present++;
            }
        }
        
        $percentage = $total > 0 ? round(($present / $total) * 100) : 0;
        
        echo json_encode([
            'success' => true,
            'student_name' => $studentName,
            'overall_percentage' => $percentage,
            'total_days' => $total,
            'present_days' => $present,
            'records' => $records
        ]);
    }
    
} catch (PDOException $e) {
    error_log("Database error: " . $e->getMessage());
    echo json_encode(['success' => false, 'error' => 'Database error: ' . $e->getMessage()]);
}
?>