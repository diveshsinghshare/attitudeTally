import 'dart:convert';
import 'package:attitude_app/screens/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attitude_app/screens/web_view_screen.dart';
class TopicListScreen extends StatefulWidget {
  final int courseId;
  const TopicListScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  List<dynamic> topics = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      print("No token found");
      setState(() => isLoading = false);
      return;
    }

    try {
      final res = await http.post(
        Uri.parse("https://www.attitudetallyacademy.com/mobile/app/user/topics"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"id": widget.courseId}),
      );

      print("Topics API Response: ${res.body}");

      final data = jsonDecode(res.body);
      if (data["status"] == 1) {
        topics = data["topics"];
      }
    } catch (e) {
      print("Error fetching topics: $e");
    }

    setState(() => isLoading = false);
  }

  void _openInApp(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseUrl = "https://www.attitudetallyacademy.com/";

    return Scaffold(
      appBar: AppBar(title: const Text("Topics")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(topic["notesName"] ?? "No title"),
              subtitle: Text("Date: ${topic["date"]}"),
              onTap: () {
                if (topic["file"] != null) {
                  _openInApp("$baseUrl${topic["file"]}");
                }
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (topic["assignment_link"] != null)
                    IconButton(
                      icon: const Icon(Icons.assignment),
                      onPressed: () => _openInApp(
                          "$baseUrl${topic["assignment_link"]}"),
                    ),
                  if (topic["content_link"] != null)
                    IconButton(
                      icon: const Icon(Icons.link),
                      onPressed: () =>
                          _openInApp(topic["content_link"]),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
