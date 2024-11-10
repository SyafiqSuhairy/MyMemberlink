import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_member_link/myconfig.dart';
import 'package:my_member_link/views/main_screen.dart';
import 'package:my_member_link/views/password_reset_screen.dart';
import 'package:my_member_link/views/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool rememberme = false;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/login.png'),
                TextField(
                    controller: emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        hintText: "Your Email")),
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  controller: passwordcontroller,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: "Your Password"),
                ),
                Row(
                  children: [
                    const Text("Remember me"),
                    Checkbox(
                      value: rememberme,
                      onChanged: (bool? value) {
                        setState(() {
                          String email = emailcontroller.text;
                          String pass = passwordcontroller.text;
                          if (value!) {
                            if (email.isNotEmpty && pass.isNotEmpty) {
                              storeSharedPrefs(value, email, pass);
                            } else {
                              rememberme = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter your credentials"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                          } else {
                            email = "";
                            pass = "";
                            storeSharedPrefs(value, email, pass);
                          }
                          rememberme = value;
                        });
                      },
                    ),
                  ],
                ),
                MaterialButton(
                  elevation: 10,
                  onPressed: onLogin,
                  minWidth: 400,
                  height: 50,
                  color: Colors.blue[800],
                  child: const Text("Login",
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  child: const Text("Forgot Password?"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PasswordResetScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => const RegisterScreen()));
                  },
                  child: const Text("Create new account?"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLogin() {
    // Login function code as before
  }

  Future<void> storeSharedPrefs(bool value, String email, String pass) async {
    // Store preferences function code as before
  }

  Future<void> loadPref() async {
    // Load preferences function code as before
  }
}
