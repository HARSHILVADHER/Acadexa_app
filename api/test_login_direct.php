<?php
require_once 'config/database.php';

// Test login directly
$email = 'harshil@gmail.com';
$password = '111111';

echo "<h3>Direct Login Test</h3>";
echo "<p>Testing email: $email</p>";
echo "<p>Testing password: $password</p>";

try {
    $stmt = $pdo->prepare("SELECT id, name, email, password FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $student = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($student) {
        echo "<p><strong>User found:</strong> " . $student['name'] . "</p>";
        echo "<p><strong>Stored password:</strong> " . $student['password'] . "</p>";
        echo "<p><strong>Password verify result:</strong> " . (password_verify($password, $student['password']) ? 'SUCCESS' : 'FAILED') . "</p>";
        
        // Test the actual login API
        echo "<hr><h4>Testing Login API:</h4>";
        
        $postData = json_encode(['email' => $email, 'password' => $password]);
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, 'http://localhost/acadexa_app_one/api/login.php');
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        echo "<p><strong>HTTP Code:</strong> $httpCode</p>";
        echo "<p><strong>API Response:</strong></p>";
        echo "<pre>" . htmlspecialchars($response) . "</pre>";
        
    } else {
        echo "<p><strong>ERROR:</strong> User not found</p>";
    }
} catch (Exception $e) {
    echo "<p><strong>ERROR:</strong> " . $e->getMessage() . "</p>";
}
?>