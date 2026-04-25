import 'package:flutter/material.dart';

// This is the first screen the user sees when they open Kismet
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Near black, not pure black - easier on the eyes
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        // SafeArea = stops content hiding behind the phone notch or status bar
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // CrossAxisAlignment.start = align everything to the left edge
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Building each section separately keeps this method readable
              _buildHeader(),
              const SizedBox(height: 20), // Gap between sections
              _buildSerenityBar(),
              const SizedBox(height: 20),
              _buildTwoPanels(),
              const SizedBox(height: 20),
              _buildMindVault(),
            ],
          ),
        ),
      ),
    );
  }

  // _ at the start = private, only this class can use it
  // Splits the big build() into smaller readable pieces
  // Header has Kismet title on the left and profile icon on the right
  Widget _buildHeader() {
    return Row(
      // spaceBetween = pushes first child left, last child right
      // Same as CSS: display flex; justify-content: space-between
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Kismet',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // Circular container for the profile icon
        // BoxShape.circle = makes it round instead of rectangular
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1A1A1A),
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  // The AI search bar where users talk to Serenity
  // Serenity is Kismet's built-in AI assistant
  Widget _buildSerenityBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        // Rounded corners, like border-radius in CSS
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ask Serenity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          // This looks like a search bar but is just a styled container for now
          // We'll make it actually functional when we add Serenity AI later
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey, size: 18),
                SizedBox(width: 8),
                Text(
                  'Search your Mind Vault...',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Two panels sitting side by side
  // Left = Recently Reanalysed, Right = Quick Summaries
  Widget _buildTwoPanels() {
    return Row(
      children: [
        // Expanded = takes up equal half of the available width
        // Both panels use Expanded so they always split the screen 50/50
        Expanded(
          child: Container(
            height: 160,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recently\nReanalysed',
                  // \n = line break, splits the title onto two lines
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Gap between the two panels
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 160,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick\nSummaries',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Mind Vault is the main feature section at the bottom
  // This will eventually show the grid of Mind Spaces
  // Expanded = takes up ALL remaining screen space below the other sections
  Widget _buildMindVault() {
    return Expanded(
      child: Container(
        // double.infinity = stretch to full available width, like CSS width: 100%
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mind Vault',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
