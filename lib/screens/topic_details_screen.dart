// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class TopicDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> topic;
//   const TopicDetailScreen({Key? key, required this.topic}) : super(key: key);
//
//   Future<void> _openUrl(String url) async {
//     final uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     }
//   }
//
//   Widget _buildGradientButton({
//     required IconData icon,
//     required String text,
//     required VoidCallback onPressed,
//     List<Color>? colors,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: colors ?? [Colors.blueAccent, Colors.blue],
//         ),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: (colors ?? [Colors.blueAccent])[0].withOpacity(0.4),
//             blurRadius: 8,
//             offset: const Offset(2, 4),
//           ),
//         ],
//       ),
//       child: ElevatedButton.icon(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
//         ),
//         icon: Icon(icon, color: Colors.white),
//         label: Text(text, style: const TextStyle(color: Colors.white)),
//         onPressed: onPressed,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final baseUrl = "https://www.attitudetallyacademy.com/";
//     final fileUrl = topic["file"] != null ? baseUrl + topic["file"] : null;
//     final assignmentUrl =
//     topic["assignment_link"] != null ? baseUrl + topic["assignment_link"] : null;
//     final videoUrl =
//     topic["video_link"] != null ? "https://vimeo.com/${topic["video_link"]}" : null;
//     final contentUrl = topic["content_link"];
//
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: Text(topic["notesName"] ?? "Topic Details"),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xff6a11cb), Color(0xff2575fc)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Card(
//                   color: Colors.white.withOpacity(0.9),
//                   elevation: 6,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Date: ${topic["date"] ?? ""}",
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 16)),
//                         const SizedBox(height: 8),
//                         Text("Time: ${topic["time"] ?? ""}",
//                             style: const TextStyle(fontSize: 14)),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 if (fileUrl != null)
//                   _buildGradientButton(
//                     icon: Icons.picture_as_pdf,
//                     text: "Open Notes PDF",
//                     onPressed: () => _openUrl(fileUrl),
//                     colors: [Colors.redAccent, Colors.deepOrange],
//                   ),
//                 if (assignmentUrl != null)
//                   _buildGradientButton(
//                     icon: Icons.assignment,
//                     text: "Open Assignment",
//                     onPressed: () => _openUrl(assignmentUrl),
//                     colors: [Colors.purpleAccent, Colors.deepPurple],
//                   ),
//                 if (videoUrl != null)
//                   _buildGradientButton(
//                     icon: Icons.video_library,
//                     text: "Watch Video",
//                     onPressed: () => _openUrl(videoUrl),
//                     colors: [Colors.teal, Colors.greenAccent],
//                   ),
//                 if (contentUrl != null)
//                   _buildGradientButton(
//                     icon: Icons.link,
//                     text: "Open Content Link",
//                     onPressed: () => _openUrl(contentUrl),
//                     colors: [Colors.blueAccent, Colors.lightBlue],
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
