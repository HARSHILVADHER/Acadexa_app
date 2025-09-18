<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/database.php';

// Handle preflight (CORS) request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Allow only POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit();
}

// Try to read JSON body
$input = json_decode(file_get_contents('php://input'), true);

// If JSON is empty, fallback to normal POST form-data
$email = $input['email'] ?? ($_POST['email'] ?? null);

if (!$email) {
    http_response_code(400);
    echo json_encode(['error' => 'Email is required']);
    exit();
}

$email = trim($email);

// Validate email format
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid email format']);
    exit();
}

try {
    // Check if email exists in students table
    $stmt = $pdo->prepare("SELECT id, email, password FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $student = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($student) {
        if (empty($student['password'])) {
            echo json_encode([
                'exists' => true,
                'hasPassword' => false,
                'message' => 'Email found. Please set your password.'
            ]);
        } else {
            echo json_encode([
                'exists' => true,
                'hasPassword' => true,
                'message' => 'Email found. Please enter your password.'
            ]);
        }
    } else {
        echo json_encode([
            'exists' => false,
            'hasPassword' => false,
            'message' => 'Email not found in our records.'
        ]);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>
