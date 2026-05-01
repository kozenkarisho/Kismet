import 'package:flutter/material.dart';

// A single card widget that displays one saved link
class LinkCard extends StatelessWidget {
  // These are the props, like React props or Java fields
  final String title;
  final String url;
  final String category;

  // Constructor, receives the props when the widget is created
  const LinkCard({
    super.key,
    required this.title,
    required this.url,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Card background color
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        // Rounded corners like border-radius in CSS
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      // Column stacks the category, title, and button vertically
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category label at the top
          Text(
            category.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 8),
          // Link title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          //open link button
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),

            child: const Text(
              'Open Link',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
