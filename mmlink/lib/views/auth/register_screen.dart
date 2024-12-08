import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mmlink/myconfig.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  String passwordStrength = "---"; // Initial password strength
  Color strengthColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], // Light green background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/register.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 10), // Spacing
                const Text(
                  "Join us! Create an account to get started.", // New text
                  style: TextStyle(
                    fontSize: 16,                // Adjust the size as needed
                    fontWeight: FontWeight.bold, // Bold text
                    color: Colors.black54,       // Subtle color for the text
                  ),
                  textAlign: TextAlign.center,   // Center the text
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Your Email",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  controller: passwordcontroller,
                  onChanged: (value) {
                    checkPasswordStrength(value);
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    hintText: "Your Password",
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Password Strength: "),
                    Text(
                      passwordStrength,
                      style: TextStyle(
                          color: strengthColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  elevation: 10,
                  onPressed: onRegisterDialog,
                  minWidth: 400,
                  height: 50,
                  color: Colors.green,
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: const Text(
                    "Already registered? Login",
                    style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onRegisterDialog() {
    String email = emailcontroller.text;
    String password = passwordcontroller.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter email and password"),
      ));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Register new account?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              onPressed: userRegistration,
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //   content: Text("Registration Canceled"),
                //   backgroundColor: Colors.red,
                // ));
              },
            ),
          ],
        );
      },
    );
  }

  void checkPasswordStrength(String password) {
    setState(() {
      if (password.length <= 3) {
        passwordStrength = "Weak";
        strengthColor = Colors.red;
      } else if (password.length > 3 && password.length <= 6) {
        passwordStrength = "Moderate";
        strengthColor = Colors.orange;
      } else {
        passwordStrength = "Strong";
        strengthColor = Colors.green;
      }
    });
  }

  void userRegistration() {
    String email = emailcontroller.text;
    String pass = passwordcontroller.text;
    http.post(
        Uri.parse("${MyConfig.servername}/memberlink/api/register_user.php"),
        body: {"email": email, "password": pass}).then((response) {
      print(response);
      // print(response.statusCode);
      // print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          // User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Success"),
            backgroundColor: Color.fromARGB(255, 12, 12, 12),
          ));
          Navigator.of(context).pop();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (content) => const MainScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Registration Failed"),
            backgroundColor: Colors.red,
          ));
        }
      } else {}
    });
  }
}
