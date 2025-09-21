<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/database.php';

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit();
}

$input = json_decode(file_get_contents('php://input'), true);
$email = $input['email'] ?? null;
$address = $input['address'] ?? null;

if (!$email || !$address) {
    http_response_code(400);
    echo json_encode(['error' => 'Email and address are required']);
    exit();
}

try {
    $stmt = $pdo->prepare("UPDATE students SET address = ? WHERE email = ?");
    $result = $stmt->execute([$address, $email]);

    if ($result && $stmt->rowCount() > 0) {
        echo json_encode(['success' => true, 'message' => 'Address updated successfully']);
    } else {
        http_response_code(404);
        echo json_encode(['error' => 'Student not found or no changes made']);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error']);
}
?>