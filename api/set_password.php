<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/database.php';

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Allow only POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'error' => 'Method not allowed. Use POST method with JSON data: {"email":"user@example.com","password":"123456"}'
    ]);
    exit();
}

// Decode JSON input
$input = json_decode(file_get_contents('php://input'), true);

if (!$input || !is_array($input)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'error' => 'Invalid request body. Expected JSON.'
    ]);
    exit();
}

// Validate email
if (!isset($input['email']) || empty(trim($input['email']))) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'error' => 'Email is required'
    ]);
    exit();
}

$email = trim($input['email']);
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'error' => 'Invalid email format'
    ]);
    exit();
}

// Validate password
if (!isset($input['password']) || empty(trim($input['password']))) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'error' => 'Password is required'
    ]);
    exit();
}

$password = trim($input['password']);

// Example rule: password must be exactly 6 digits
if (!preg_match('/^\d{6}$/', $password)) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'error' => 'Password must be exactly 6 digits'
    ]);
    exit();
}

try {
    // Check if email exists
    $stmt = $pdo->prepare("SELECT id FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $student = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$student) {
        http_response_code(404);
        echo json_encode([
            'success' => false,
            'error' => 'Email not found'
        ]);
        exit();
    }

    // Hash password
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // Update password
    $stmt = $pdo->prepare("UPDATE students SET password = ? WHERE email = ?");
    $result = $stmt->execute([$hashedPassword, $email]);

    if ($result) {
        echo json_encode([
            'success' => true,
            'message' => 'Password set successfully'
        ]);
    } else {
        http_response_code(500);
        echo json_encode([
            'success' => false,
            'error' => 'Failed to set password'
        ]);
    }

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Database error: ' . $e->getMessage()
    ]);
}
