<?php
include_once("dbconnect.php");

$email = $_POST['email'];
$password = $_POST['password'];

$sql = "SELECT * FROM tbl_user WHERE email = '$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    if (password_verify($password, $row['password'])) {
        echo json_encode(["status" => "success", "message" => "Login successful"]);
    } else {
        echo json_encode(["status" => "failed", "message" => "Invalid credentials"]);
    }
} else {
    echo json_encode(["status" => "failed", "message" => "User not found"]);
}
?>
