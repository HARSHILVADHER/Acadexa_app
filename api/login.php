<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config/database.php';

// Handle preflight OPTIONS request (for CORS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'error' => 'Method not allowed']);
    exit();
}

// Read JSON body
$input = json_decode(file_get_contents('php://input'), true);

if (!$input || !isset($input['email']) || empty(trim($input['email']))) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Email is required']);
    exit();
}

if (!isset($input['password']) || empty(trim($input['password']))) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Password is required']);
    exit();
}

$email = trim($input['email']);
$password = trim($input['password']);

// Validate email format
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'error' => 'Invalid email format']);
    exit();
}

try {
    // Fetch student record
    $stmt = $pdo->prepare("SELECT id, name, email, password, age, roll_no, contact, class_code, user_id 
                           FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $student = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$student) {
        http_response_code(401);
        echo json_encode(['success' => false, 'error' => 'Invalid email or password (email not found)']);
        exit();
    }

    // Verify password
    if (!password_verify($password, $student['password'])) {
        http_response_code(401);
        echo json_encode([
            'success' => false,
            'error' => 'Invalid email or password'
        ]);
        exit();
    }

    // Remove sensitive info
    unset($student['password']);

    // Login success
    echo json_encode([
        'success' => true,
        'message' => 'Login successful',
        'student' => $student
    ]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Database error: ' . $e->getMessage()
    ]);
}
?>
