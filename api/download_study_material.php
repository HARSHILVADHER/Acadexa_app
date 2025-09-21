<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit(0);
}

require_once 'config/database.php';

try {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($input['material_id']) || !isset($input['email'])) {
        echo json_encode(['success' => false, 'message' => 'Material ID and email are required']);
        exit;
    }
    
    $material_id = $input['material_id'];
    $email = $input['email'];
    
    // Verify student exists and get class
    $stmt = $pdo->prepare("SELECT class_code FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $student = $stmt->fetch(PDO::FETCH_ASSOC);
    
    
    if (!$student) {
        echo json_encode(['success' => false, 'message' => 'Student not found']);
        exit;
    }
    
    // Get material data
    $stmt = $pdo->prepare("SELECT file_name, file_type, file_data, code FROM study_materials WHERE id = ?");
    $stmt->execute([$material_id]);
    $material = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$material) {
        echo json_encode(['success' => false, 'message' => 'Material not found']);
        exit;
    }
    
    // Check if student has access to this material (same class)
    if ($material['code'] !== $student['class_code']) {
        echo json_encode(['success' => false, 'message' => 'Access denied']);
        exit;
    }
    
    // Return file data as base64
    echo json_encode([
        'success' => true,
        'file_name' => $material['file_name'],
        'file_type' => $material['file_type'],
        'file_data' => base64_encode($material['file_data'])
    ]);
    
} catch (Exception $e) {
    echo json_encode(['success' => false, 'message' => 'Server error: ' . $e->getMessage()]);
}
?>