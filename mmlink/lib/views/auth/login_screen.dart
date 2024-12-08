import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mmlink/myconfig.dart';
import 'package:mmlink/views/newsletter/news_screen.dart';
import 'package:mmlink/views/auth/register_screen.dart';
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
    // TODO: implement initState
    super.initState();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], //Light green background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/login.png',
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 10), // Spacing
                const Text(
                  "Welcome Back! Please login to continue.", // New text
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
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Your Password",
                  ),
                ),
                const SizedBox(height: 10),
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
                  color: Colors.green,
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (content) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal:20),
                    child: const Text("Create new account?",
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

  void onLogin() {
    String email = emailcontroller.text;
    String pass = passwordcontroller.text;
    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter email and password"),
      ));
      return;
    }
    http.post(Uri.parse("${MyConfig.servername}/memberlink/api/login_user.php"),
        body: {"email": email, "pass": pass}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          // User user = User.fromJson(data['data']);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Color.fromARGB(255, 12, 12, 12),
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const MainScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  Future<void> storeSharedPrefs(bool value, String email, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      prefs.setString("email", email);
      prefs.setString("password", pass);
      prefs.setBool("rememberme", value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Stored"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    } else {
      prefs.setString("email", email);
      prefs.setString("password", pass);
      prefs.setBool("rememberme", value);
      emailcontroller.text = "";
      passwordcontroller.text = "";
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Removed"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
    }
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailcontroller.text = prefs.getString("email") ?? "";
    passwordcontroller.text = prefs.getString("password") ?? "";
    rememberme = prefs.getBool("rememberme") ?? false;
    setState(() {});
  }
}