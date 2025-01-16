import 'package:flutter/material.dart';

class Movieitem extends StatelessWidget {

  final String title;
  final String year;
  final String runtime;
  final String? poster;

  const Movieitem({
    super.key,
    required this.title,
    required this.year,
    required this.runtime,
    this.poster,
  });

 @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (poster != null)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(poster!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.broken_image, size: 50)),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Year: $year | Runtime: $runtime'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}