<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

require_once 'config/database.php';

try {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($input['email'])) {
        echo json_encode(['success' => false, 'message' => 'Email is required']);
        exit;
    }
    
    $email = $input['email'];
    $type = isset($input['type']) ? $input['type'] : null;
    
    // Get student's class from students table
    $stmt = $pdo->prepare("SELECT class_code FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $student = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$student) {
        echo json_encode(['success' => false, 'message' => 'Student not found']);
        exit;
    }
    
    $class = $student['class_code'];
    
    // Build query based on type filter
    $query = "SELECT id, title, code, subject, type, description, file_name, file_type, created_at 
              FROM study_materials WHERE code = ?";
    $params = [$class];
    
    if ($type) {
        $query .= " AND type = ?";
        $params[] = $type;
    }
    
    $query .= " ORDER BY subject, type, created_at DESC";
    
    $stmt = $pdo->prepare($query);
    $stmt->execute($params);
    $materials = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Group materials by type and subject
    $grouped_materials = [];
    foreach ($materials as $material) {
        $type = $material['type'];
        $subject = $material['subject'];
        
        if (!isset($grouped_materials[$type])) {
            $grouped_materials[$type] = [];
        }
        
        if (!isset($grouped_materials[$type][$subject])) {
            $grouped_materials[$type][$subject] = [];
        }
        
        $grouped_materials[$type][$subject][] = $material;
    }
    
    echo json_encode([
        'success' => true,
        'materials' => $grouped_materials,
        'class' => $class
    ]);
    
} catch (Exception $e) {
    echo json_encode(['success' => false, 'message' => 'Server error: ' . $e->getMessage()]);
}
?>