<?php
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

// Check if email or password already exists
$sqlcheck = "SELECT * FROM 'tbl_admins' WHERE 'admin_email' = '$email'";
$result = $con->query($sqlcheck);

if ($result->num_rows > 0) {
    $response = array('status' => 'failed', 'message' => 'Email already exists');
    sendJsonResponse($response);
    exit;
} else {
    $response = array('status' => 'success', 'message' => 'Email is avalaible');
    sendJsonResponse($response);
    exit;
}

$sqlinsert="INSERT INTO `tbl_admins`(`admin_email`, `admin_pass`) VALUES ('$email','$password')";

if ($conn->query($sqlinsert) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}
	
	

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type');
    echo json_encode($sentArray);
}

?>