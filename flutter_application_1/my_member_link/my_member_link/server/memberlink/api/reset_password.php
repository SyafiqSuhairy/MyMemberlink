<?php
include_once("dbconnect.php");

$email = $_POST['email'];
$reset_code = $_POST['reset_code'];
$new_password = $_POST['new_password'];

// Verify reset code
$sql = "SELECT * FROM password_resets WHERE email = '$email' AND reset_code = '$reset_code'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Update password
    $hashed_password = password_hash($new_password, PASSWORD_DEFAULT);
    $sql = "UPDATE tbl_user SET password = '$hashed_password' WHERE email = '$email'";
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Password reset successful"]);
        // Remove reset code after successful password reset
        $conn->query("DELETE FROM password_resets WHERE email = '$email'");
    } else {
        echo json_encode(["status" => "failed", "message" => "Password reset failed"]);
    }
} else {
    echo json_encode(["status" => "failed", "message" => "Invalid reset code"]);
}
?>
