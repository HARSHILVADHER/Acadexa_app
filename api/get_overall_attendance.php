<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

require_once 'config/database.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    $email = $input['email'] ?? null;
} else if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $email = $_GET['email'] ?? 'harshil@gmail.com';
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
    $stmt = $pdo->prepare("SELECT id, name FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $student = $stmt->fetch();
    
    if (!$student) {
        echo json_encode(['success' => false, 'error' => 'Student not found']);
        exit();
    }
    
    // Get all attendance records for this student by matching name
    $stmt = $pdo->prepare("
        SELECT date, status 
        FROM attendance 
        WHERE LOWER(student_name) = LOWER(?)
        ORDER BY date DESC
    ");
    $stmt->execute([$student['name']]);
    $attendance = $stmt->fetchAll();
    
    // Calculate overall percentage
    $totalDays = count($attendance);
    $presentDays = 0;
    
    foreach ($attendance as $record) {
        if ($record['status'] === 'present') {
            $presentDays++;
        }
    }
    
    $percentage = $totalDays > 0 ? round(($presentDays / $totalDays) * 100) : 0;
    
    echo json_encode([
        'success' => true,
        'student_name' => $student['name'],
        'overall_percentage' => $percentage,
        'total_days' => $totalDays,
        'present_days' => $presentDays
    ]);
    
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>