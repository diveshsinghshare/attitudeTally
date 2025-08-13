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
  String selectedRole = 'Applicant';

  Future<void> login() async {
    setState(() => isLoading = true);

    final url = Uri.parse("https://www.attitudetallyacademy.com/mobile/app/login.php");

    final payload = {
      "username": _usernameController.text.trim().isEmpty
          ? "6399783295"
          : _usernameController.text.trim(),
      "password": _passwordController.text.trim().isEmpty
          ? "6399783295"
          : _passwordController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 1) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CourseListScreen()),
        );
      } else {
        _showSnack(data["message"] ?? "Login failed");
      }
    } catch (e) {
      _showSnack("Error: $e");
    }

    setState(() => isLoading = false);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00ACC8), Color(0xFF003366)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/logo.png", height: 80),
                  const SizedBox(height: 16),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003366),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Login to continue",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 24),

                  // Role selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _roleChip("Applicant"),
                      const SizedBox(width: 12),
                      _roleChip("Employer"),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Username field
                  _inputField(
                    controller: _usernameController,
                    hint: "Username",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  _inputField(
                    controller: _passwordController,
                    hint: "Password",
                    icon: Icons.lock,
                    obscureText: !isPasswordVisible,
                    suffix: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: isLoading ? null : login,
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00ACC8), Color(0xFF003366)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            "LOGIN",
                            style: TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Forgot password
                  GestureDetector(
                    onTap: () {
                      // forgot password action
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color(0xFF003366),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleChip(String role) {
    final bool selected = selectedRole == role;
    return ChoiceChip(
      label: Text(role.toUpperCase()),
      selected: selected,
      selectedColor: const Color(0xFF00ACC8),
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      onSelected: (value) {
        setState(() {
          selectedRole = role;
        });
      },
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color(0xFF00ACC8)),
        suffixIcon: suffix,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
