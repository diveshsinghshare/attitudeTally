import 'dart:convert';
import 'package:attitude_app/screens/pdf_viewer_screen.dart';
import 'package:attitude_app/screens/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TopicListScreen extends StatefulWidget {
  final int courseId;
  const TopicListScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  List<dynamic> topics = [];
  bool isLoading = true;

  final List<List<Color>> cardGradients = [
    [Color(0xFFff9a9e), Color(0xFFfad0c4)],
    [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
    [Color(0xFFfbc2eb), Color(0xFFa6c1ee)],
    [Color(0xFF84fab0), Color(0xFF8fd3f4)],
    [Color(0xFFfccb90), Color(0xFFd57eeb)],
  ];

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
    print("_openInApp");
    print(url);

    if (url.toLowerCase().contains(".pdf")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerScreen(url: url, title: 'file',),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewScreen(url: url),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Topics"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6a11cb), Color(0xff2575fc)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
            : ListView.builder(
          padding: const EdgeInsets.only(top: 80, bottom: 16),
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            final gradientColors =
            cardGradients[index % cardGradients.length];

            return Container(
              margin:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic["notesName"] ?? "No title",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Date: ${topic["date"]}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (topic["file"] != null)
                        IconButton(
                          icon: const Icon(Icons.assignment,
                              color: Colors.white),
                          onPressed: () => _openInApp(
                              topic["file"]),
                        ),
                      if (topic["assignment_link"] != null)
                        IconButton(
                          icon: const Icon(Icons.link,
                              color: Colors.white),
                          onPressed: () =>
                              _openInApp(topic["assignment_link"]),
                        ),
                      if (topic["video_link"] != null)
                        IconButton(
                          icon: const Icon(Icons.video_call,
                              color: Colors.white),
                          onPressed: () =>
                              _openInApp(topic["video_link"]),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
