<?php
require_once 'config/database.php';

use Ratchet\Server\IoServer;
use Ratchet\Http\HttpServer;
use Ratchet\WebSocket\WsServer;
use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;

class AcadexaWebSocketServer implements MessageComponentInterface {
    protected $clients;
    protected $userConnections;
    protected $pdo;

    public function __construct() {
        $this->clients = new \SplObjectStorage;
        $this->userConnections = [];
        
        // Database connection
        $database = new Database();
        $this->pdo = $database->getConnection();
    }

    public function onOpen(ConnectionInterface $conn) {
        $this->clients->attach($conn);
        echo "New connection! ({$conn->resourceId})\n";
    }

    public function onMessage(ConnectionInterface $from, $msg) {
        $data = json_decode($msg, true);
        
        if (!$data) {
            return;
        }

        switch ($data['type']) {
            case 'subscribe':
                $this->handleSubscription($from, $data);
                break;
            case 'request_data':
                $this->handleDataRequest($from, $data);
                break;
            default:
                echo "Unknown message type: {$data['type']}\n";
        }
    }

    public function onClose(ConnectionInterface $conn) {
        $this->clients->detach($conn);
        
        // Remove from user connections
        foreach ($this->userConnections as $userId => $connection) {
            if ($connection === $conn) {
                unset($this->userConnections[$userId]);
                break;
            }
        }
        
        echo "Connection {$conn->resourceId} has disconnected\n";
    }

    public function onError(ConnectionInterface $conn, \Exception $e) {
        echo "An error has occurred: {$e->getMessage()}\n";
        $conn->close();
    }

    private function handleSubscription($conn, $data) {
        $userId = $data['user_id'] ?? null;
        
        if ($userId) {
            $this->userConnections[$userId] = $conn;
            echo "User {$userId} subscribed\n";
            
            // Send confirmation
            $conn->send(json_encode([
                'type' => 'subscription_confirmed',
                'user_id' => $userId,
                'message' => 'Successfully subscribed to live updates'
            ]));
        }
    }

    private function handleDataRequest($conn, $data) {
        $dataType = $data['data_type'] ?? null;
        
        switch ($dataType) {
            case 'attendance':
                $this->sendAttendanceData($conn, $data);
                break;
            case 'exams':
                $this->sendExamData($conn, $data);
                break;
            case 'study_materials':
                $this->sendStudyMaterialData($conn, $data);
                break;
        }
    }

    private function sendAttendanceData($conn, $data) {
        // Simulate fetching attendance data
        $attendanceData = [
            'type' => 'attendance',
            'overall_data' => [
                'overall_percentage' => rand(70, 95),
                'present_days' => rand(20, 30),
                'total_days' => 30
            ],
            'today_attendance' => [
                'success' => true,
                'has_attendance' => true,
                'status' => rand(0, 1) ? 'present' : 'absent'
            ],
            'yesterday_attendance' => [
                'success' => true,
                'has_attendance' => true,
                'status' => 'present'
            ]
        ];
        
        $conn->send(json_encode($attendanceData));
    }

    private function sendExamData($conn, $data) {
        // Simulate fetching exam data
        $examData = [
            'type' => 'exams',
            'today_exams' => [],
            'upcoming_exams' => [
                [
                    'exam_name' => 'Mathematics Test',
                    'exam_date' => date('Y-m-d', strtotime('+3 days')),
                    'start_time' => '10:00 AM',
                    'end_time' => '12:00 PM'
                ]
            ]
        ];
        
        $conn->send(json_encode($examData));
    }

    private function sendStudyMaterialData($conn, $data) {
        // Simulate fetching study material data
        $materialData = [
            'type' => 'study_materials',
            'action' => 'update',
            'materials' => [
                'notes' => [
                    'Mathematics' => [
                        [
                            'id' => 1,
                            'title' => 'Calculus Notes',
                            'file_name' => 'calculus_notes.pdf',
                            'file_type' => 'pdf',
                            'description' => 'Complete calculus notes'
                        ]
                    ]
                ]
            ]
        ];
        
        $conn->send(json_encode($materialData));
    }

    // Method to broadcast updates to all connected users
    public function broadcastUpdate($data) {
        foreach ($this->clients as $client) {
            $client->send(json_encode($data));
        }
    }

    // Method to send update to specific user
    public function sendToUser($userId, $data) {
        if (isset($this->userConnections[$userId])) {
            $this->userConnections[$userId]->send(json_encode($data));
        }
    }
}

// Start the WebSocket server
$server = IoServer::factory(
    new HttpServer(
        new WsServer(
            new AcadexaWebSocketServer()
        )
    ),
    8080
);

echo "WebSocket server started on port 8080\n";
$server->run();
?>