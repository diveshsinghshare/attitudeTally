import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TopicDetailScreen extends StatelessWidget {
  final Map<String, dynamic> topic;
  const TopicDetailScreen({Key? key, required this.topic}) : super(key: key);
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Could not open $url')),
      // );
    }
  }


  @override
  Widget build(BuildContext context) {
    final baseUrl = "https://www.attitudetallyacademy.com/";
    final fileUrl =
    topic["file"] != null ? baseUrl + topic["file"] : null;
    final assignmentUrl =
    topic["assignment_link"] != null ? baseUrl + topic["assignment_link"] : null;
    final videoUrl =
    topic["video_link"] != null ? "https://vimeo.com/${topic["video_link"]}" : null;
    final contentUrl = topic["content_link"];

    return Scaffold(
      appBar: AppBar(title: Text(topic["notesName"] ?? "Topic Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: ${topic["date"] ?? ""}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Time: ${topic["time"] ?? ""}"),
            const SizedBox(height: 20),
            if (fileUrl != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Open Notes PDF"),
                onPressed: () => _openUrl(fileUrl),
              ),
            if (assignmentUrl != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.assignment),
                label: const Text("Open Assignment"),
                onPressed: () => _openUrl(assignmentUrl),
              ),
            if (videoUrl != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.video_library),
                label: const Text("Watch Video"),
                onPressed: () => _openUrl(videoUrl),
              ),
            if (contentUrl != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.link),
                label: const Text("Open Content Link"),
                onPressed: () => _openUrl(contentUrl),
              ),
          ],
        ),
      ),
    );
  }
}
