import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(course['course_name'] ?? ''),
        subtitle: Text('Topics: ${course['topics']}'),
        trailing: ElevatedButton(
          onPressed: () {
            // Placeholder for navigation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('View ${course['course_name']}')),
            );
          },
          child: const Text('View'),
        ),
      ),
    );
  }
}
