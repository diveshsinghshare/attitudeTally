import 'dart:convert';
import 'package:attitude_app/screens/topic_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({Key? key}) : super(key: key);

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  Map<String, dynamic>? profile;
  List<dynamic> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      print("No token found in SharedPreferences");
      setState(() => isLoading = false);
      return;
    }

    try {
      // Fetch profile
      final profileRes = await http.get(
        Uri.parse("https://www.attitudetallyacademy.com/mobile/app/user/profile"),
        headers: {"Authorization": "Bearer $token"},
      );
      print("Profile API Response: ${profileRes.body}");
      final profileData = jsonDecode(profileRes.body);
      if (profileData["status"] == 1) {
        profile = profileData["user"];
      }

      // Fetch courses
      final courseRes = await http.get(
        Uri.parse("https://www.attitudetallyacademy.com/mobile/app/user/course_list.php"),
        headers: {"Authorization": "Bearer $token"},
      );
      print("Course API Response: ${courseRes.body}");
      final courseData = jsonDecode(courseRes.body);
      if (courseData["status"] == 1) {
        courses = courseData["courses"];
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5, // half screen width
        child: Drawer(
          child: profile == null
              ? const Center(child: Text("No profile"))
              : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/profile.png"),
              ),
              const SizedBox(height: 12),
              Text("Email: ${profile!["email"]}"),
              Text("Mobile: ${profile!["mobile"]}"),
              Text("City: ${profile!["city"]}"),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text("Courses"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return ListTile(
            title: Text(course["course_name"]),
            subtitle: Text("${course["topics"]} topics"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TopicListScreen(courseId: course["id"]),
                ),
              );
            },

          );
        },
      ),
    );
  }
}
