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

  // Asks the user for a name via a popup dialog.
  // Returns the typed name, or null if the user cancelled.
  Future<String?> _askForSpaceName() async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1F2113),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'New Mind Space',
          style: GoogleFonts.inter(
            color: const Color(0xFFE3E4CE),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.inter(color: const Color(0xFFE3E4CE)),
          decoration: InputDecoration(
            hintText: 'e.g. Books, Travel...',
            hintStyle: GoogleFonts.inter(color: const Color(0xFFC6C9AB)),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF454932)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFDFFF00)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: const Color(0xFFC6C9AB)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: Text(
              'Add',
              style: GoogleFonts.inter(
                color: const Color(0xFFDFFF00),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    controller.dispose();
    return result;
  }

  Future<void> _addSpace() async {
    final name = await _askForSpaceName();
    // Bail out if the user cancelled or typed only whitespace.
    if (name == null || name.trim().isEmpty) return;

    setState(() {
      spaces.add(name.trim());
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
