<?php
include_once("dbconnect.php");

$email = $_POST['email'];
$reset_code = rand(100000, 999999); // Generate a random 6-digit code

// Check if user exists
$sql = "SELECT * FROM tbl_user WHERE email = '$email'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Insert the reset code into the password_resets table
    $sql = "INSERT INTO password_resets (email, reset_code) VALUES ('$email', '$reset_code')";
    if ($conn->query($sql) === TRUE) {
        // Here, you would typically send the code to the user via email
        echo json_encode(["status" => "success", "message" => "Reset code sent"]);
    } else {
        echo json_encode(["status" => "failed", "message" => "Failed to generate reset code"]);
    }
} else {
    echo json_encode(["status" => "failed", "message" => "Email not found"]);
}
?>
