<?php
include_once("dbconnect.php");

$email = $_POST['email'];
$password = password_hash($_POST['password'], PASSWORD_DEFAULT);

$sql = "INSERT INTO tbl_user (email, password) VALUES ('$email', '$password')";
if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success", "message" => "Registration successful"]);
} else {
    echo json_encode(["status" => "failed", "message" => "Registration failed"]);
}
?>
