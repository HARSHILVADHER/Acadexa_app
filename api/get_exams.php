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
} else {
    $email = $_GET['email'] ?? null;
}

if (!$email) {
    echo json_encode(['success' => false, 'error' => 'Email is required']);
    exit();
}

try {
    // Get student info and class code
    $stmt = $pdo->prepare("SELECT class_code FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $student = $stmt->fetch();
    
    if (!$student) {
        echo json_encode(['success' => false, 'error' => 'Student not found']);
        exit();
    }
    
    $classCode = $student['class_code'];
    
    // Get all exams for this class code
    $stmt = $pdo->prepare("
        SELECT exam_name, exam_date, start_time, end_time, total_marks, passing_marks, notes
        FROM exam 
        WHERE code = ?
        ORDER BY exam_date ASC
    ");
    $stmt->execute([$classCode]);
    $exams = $stmt->fetchAll();
    
    // Separate exams into categories
    $today = date('Y-m-d');
    $upcomingExams = [];
    $todayExams = [];
    
    foreach ($exams as $exam) {
        if ($exam['exam_date'] == $today) {
            $todayExams[] = $exam;
        } elseif ($exam['exam_date'] > $today) {
            $upcomingExams[] = $exam;
        }
    }
    
    echo json_encode([
        'success' => true,
        'class_code' => $classCode,
        'upcoming_exams' => $upcomingExams,
        'today_exams' => $todayExams,
        'all_exams' => $exams
    ]);
    
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'error' => 'Database error: ' . $e->getMessage()]);
}
?>