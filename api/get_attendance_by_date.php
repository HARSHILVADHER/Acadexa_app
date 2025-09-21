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
    $date = $input['date'] ?? null;
} else if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $email = $_GET['email'] ?? 'harshil@gmail.com';
    $date = $_GET['date'] ?? date('Y-m-d');
} else {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit();
}

if (!$email || !$date) {
    http_response_code(400);
    echo json_encode(['error' => 'Email and date are required']);
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
    
    // Get attendance for specific date by matching student name
    $stmt = $pdo->prepare("
        SELECT status 
        FROM attendance 
        WHERE LOWER(student_name) = LOWER(?) AND date = ?
        LIMIT 1
    ");
    $stmt->execute([$student['name'], $date]);
    $attendance = $stmt->fetch();
    
    if ($attendance) {
        echo json_encode([
            'success' => true,
            'has_attendance' => true,
            'status' => $attendance['status'],
            'date' => $date
        ]);
    } else {
        echo json_encode([
            'success' => true,
            'has_attendance' => false,
            'status' => null,
            'date' => $date
        ]);
    }
    
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>