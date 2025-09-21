<?php
// Test the attendance APIs
echo "Testing Attendance APIs\n\n";

// Test get_overall_attendance.php
echo "1. Testing Overall Attendance API:\n";
$url1 = "http://localhost/acadexa_app_one/api/get_overall_attendance.php?email=harshil@gmail.com";
$response1 = file_get_contents($url1);
echo "Response: " . $response1 . "\n\n";

// Test get_attendance_by_date.php
echo "2. Testing Attendance by Date API:\n";
$url2 = "http://localhost/acadexa_app_one/api/get_attendance_by_date.php?email=harshil@gmail.com&date=2025-05-21";
$response2 = file_get_contents($url2);
echo "Response: " . $response2 . "\n\n";

// Test with different date
echo "3. Testing with different date (2025-05-20):\n";
$url3 = "http://localhost/acadexa_app_one/api/get_attendance_by_date.php?email=harshil@gmail.com&date=2025-05-20";
$response3 = file_get_contents($url3);
echo "Response: " . $response3 . "\n";
?>