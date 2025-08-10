import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'course_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;
  String selectedRole = 'Applicant'; // Default role

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse("https://www.attitudetallyacademy.com/mobile/app/login.php");

    // final payload = {
    //   "username": _usernameController.text.trim(),
    //   "password": _passwordController.text.trim()
    // };



    final payload = {
      "username": "6399783295",
      "password": "6399783295"
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 1) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(data["message"])),
        // );
        // Save token to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CourseListScreen()),
        );
        // Store token or navigate
        print("Token: ${data["token"]}");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Login failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[700],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Image.asset("assets/logo.png", height: 60),
                const SizedBox(height: 8),
                const Text(
                  "PLEASE ENTER CREDENTIALS FOR LOGIN",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Color(0xFF003366),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Role selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text("APPLICANT"),
                      selected: selectedRole == 'Applicant',
                      onSelected: (selected) {
                        setState(() {
                          selectedRole = 'Applicant';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text("EMPLOYER"),
                      selected: selectedRole == 'Employer',
                      onSelected: (selected) {
                        setState(() {
                          selectedRole = 'Employer';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Username field
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Password field
                TextField(
                  controller: _passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366)),
                    onPressed: isLoading ? null : login,
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text("LOGIN"),
                  ),
                ),
                const SizedBox(height: 8),

                // Forgot password
                GestureDetector(
                  onTap: () {
                    // Navigate to forgot password
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
