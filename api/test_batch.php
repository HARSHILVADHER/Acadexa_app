<?php
require_once 'config/database.php';

// Test batch retrieval directly
$email = 'harshil@gmail.com'; // Use the actual email from your login

echo "<h3>Direct Batch Test</h3>";
echo "<p>Testing email: $email</p>";

try {
    // First, let's see what columns exist in both tables
    echo "<h4>Students table structure:</h4>";
    $stmt = $pdo->query("DESCRIBE students");
    $students_columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach($students_columns as $col) {
        echo "<p>" . $col['Field'] . " (" . $col['Type'] . ")</p>";
    }
    
    echo "<h4>Classes table structure:</h4>";
    $stmt = $pdo->query("DESCRIBE classes");
    $classes_columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach($classes_columns as $col) {
        echo "<p>" . $col['Field'] . " (" . $col['Type'] . ")</p>";
    }
    
    // Now try to find the student
    $stmt = $pdo->prepare("SELECT * FROM students WHERE email = ?");
    $stmt->execute([$email]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($result) {
        echo "<h4>Student found:</h4>";
        foreach($result as $key => $value) {
            echo "<p><strong>$key:</strong> $value</p>";
        }
    } else {
        echo "<p><strong>No student found with email: $email</strong></p>";
    }
    
    // Show all classes
    echo "<h4>All classes in database:</h4>";
    $stmt = $pdo->query("SELECT * FROM classes LIMIT 5");
    $classes = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach($classes as $class) {
        echo "<p>";
        foreach($class as $key => $value) {
            echo "<strong>$key:</strong> $value | ";
        }
        echo "</p>";
    }

    // Test the API directly
    echo "<hr><h4>Testing get_batch.php API:</h4>";
    
    $postData = json_encode(['email' => $email]);
    
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, 'http://localhost/acadexa_app_one/api/get_batch.php');
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

} catch (Exception $e) {
    echo "<p><strong>ERROR:</strong> " . $e->getMessage() . "</p>";
}
?>