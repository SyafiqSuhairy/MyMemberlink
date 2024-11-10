import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController resetCodeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool isCodeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Reset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email to receive a reset code',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            isCodeSent
                ? Column(
                    children: [
                      TextField(
                        controller: resetCodeController,
                        decoration: const InputDecoration(
                          labelText: 'Reset Code',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitNewPassword,
                        child: const Text('Submit New Password'),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _sendResetCode,
                    child: const Text('Send Reset Code'),
                  ),
          ],
        ),
      ),
    );
  }

  void _sendResetCode() {
    // Add logic to send reset code via email here
    setState(() {
      isCodeSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reset code sent! Check your email.')),
    );
  }

  void _submitNewPassword() {
    String code = resetCodeController.text;
    String newPassword = newPasswordController.text;

    if (code.isNotEmpty && newPassword.isNotEmpty) {
      // Add logic to verify code and reset password in the backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successful!')),
      );
      Navigator.pop(context); // Return to the login screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter reset code and new password.')),
      );
    }
  }
}
