<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

include 'config/database.php';

$input = json_decode(file_get_contents('php://input'), true);
$email = $input['email'] ?? '';

if (empty($email)) {
    echo json_encode(['error' => 'Email is required', 'student_count' => 0, 'year' => '']);
    exit;
}

try {
    // Get user's class_code from students table
    $stmt = $pdo->prepare("SELECT class_code FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$user) {
        echo json_encode(['error' => 'User not found', 'student_count' => 0, 'year' => '']);
        exit;
    }
    
    $class_code = $user['class_code'];
    
    // Count all students with same class_code
    $stmt = $pdo->prepare("SELECT COUNT(*) as count FROM students WHERE class_code = ?");
    $stmt->execute([$class_code]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    // Get year and mentor_name from classes table
    $stmt = $pdo->prepare("SELECT year, mentor_name FROM classes WHERE code = ?");
    $stmt->execute([$class_code]);
    $classInfo = $stmt->fetch(PDO::FETCH_ASSOC);
    
    // Get all student names with same class_code
    $stmt = $pdo->prepare("SELECT name FROM students WHERE class_code = ?");
    $stmt->execute([$class_code]);
    $students = $stmt->fetchAll(PDO::FETCH_COLUMN);
    
    echo json_encode([
        'student_count' => (int)$result['count'],
        'year' => $classInfo['year'] ?? '',
        'mentor_name' => $classInfo['mentor_name'] ?? '',
        'students' => $students
    ]);
    
} catch (PDOException $e) {
    echo json_encode(['error' => 'Database error', 'student_count' => 0, 'year' => '']);
}
?>