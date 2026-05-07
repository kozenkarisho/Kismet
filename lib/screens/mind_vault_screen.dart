import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/mind_space_card.dart';

class MindVaultScreen extends StatefulWidget {
  const MindVaultScreen({super.key});

  @override
  State<MindVaultScreen> createState() => _MindVaultScreenState();
}

class _MindVaultScreenState extends State<MindVaultScreen> {
  // The list of Mind Spaces. Lives here so it survives rebuilds.
  List<String> spaces = [
    "Movies",
    "Recipes",
    "Education",
    "Religion",
    "Memes",
    "Songs",
  ];

  void _addSpace() {
    setState(() {
      spaces.add("New Space ${spaces.length + 1}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F04),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 24, 24),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Color(0xFFC6C9AB),
                          size: 36,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Mind Vault',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFE3E4CE),
                          fontWeight: FontWeight.w900,
                          fontSize: 36,
                          letterSpacing: -0.72,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: spaces.length,
                    itemBuilder: (context, index) {
                      return MindSpaceCard(title: spaces[index]);
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 32,
              right: 24,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFDFFF00),
                  shape: BoxShape.circle,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: _addSpace,
                    child: const Icon(Icons.add, color: Colors.black, size: 32),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
