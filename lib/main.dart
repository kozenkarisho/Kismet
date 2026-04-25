import 'package:flutter/material.dart';
import 'link_card.dart'; // Import our LinkCard widget from the other file
// Entry point of the app. Flutter starts here, just like main() in Java.

void main() {
  runApp(const KismetApp());
}

// Root widget. Sets up the overall app configuration.
class KismetApp extends StatelessWidget {
  const KismetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kismet',
      debugShowCheckedModeBanner:
          false, // Removes the red debug banner from the top right corner
      theme: ThemeData.dark(),
      home:
          const HomeScreen(), // The first screen the user sees when they open the app
    );
  }
}

// The main screen of the app
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Near black background
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Padding(
          // 16 pixels of space on all sides
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // Align everything to the left
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App title
              const Text(
                'Kismet',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // App subtitle
              const Text(
                'Your Mind Vault',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              // Space between header and grid
              const SizedBox(height: 24),
              // Expanded makes the grid take up all remaining screen space
              Expanded(
                child: GridView.count(
                  // 2 cards per row
                  crossAxisCount: 2,
                  // Space between cards horizontally
                  crossAxisSpacing: 12,
                  // Space between cards vertically
                  mainAxisSpacing: 12,
                  // Height to width ratio of each card
                  childAspectRatio: 0.85,
                  children: const [
                    LinkCard(
                      title: 'YouTube',
                      url: 'https://youtube.com',
                      category: 'Video',
                    ),
                    LinkCard(
                      title: 'GitHub',
                      url: 'https://github.com',
                      category: 'Work',
                    ),
                    LinkCard(
                      title: 'Reddit',
                      url: 'https://reddit.com',
                      category: 'Social',
                    ),
                    LinkCard(
                      title: 'Netflix',
                      url: 'https://netflix.com',
                      category: 'Fun',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
