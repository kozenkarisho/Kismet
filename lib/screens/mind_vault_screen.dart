import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/patterns.dart';

class MindVaultScreen extends StatefulWidget {
  const MindVaultScreen({super.key});

  @override
  State<MindVaultScreen> createState() => _MindVaultScreenState();
}

class _MindVaultScreenState extends State<MindVaultScreen> {
  final List<Map<String, dynamic>> _spaces = [
    {
      'id': '1',
      'title': 'Movies',
      'bannerType': 'color',
      'bannerValue': 'bg-blue-500/20'
    },
    {
      'id': '2',
      'title': 'Recipes',
      'bannerType': 'pattern',
      'bannerValue': 'dots',
      'bannerColor': '#f87171'
    },
    {
      'id': '3',
      'title': 'Education',
      'bannerType': 'color',
      'bannerValue': 'bg-green-500/20'
    },
    {
      'id': '4',
      'title': 'Religion',
      'bannerType': 'pattern',
      'bannerValue': 'circles',
      'bannerColor': '#60a5fa'
    },
    {
      'id': '5',
      'title': 'Memes',
      'bannerType': 'color',
      'bannerValue': 'bg-purple-500/20'
    },
    {
      'id': '6',
      'title': 'Songs',
      'bannerType': 'pattern',
      'bannerValue': 'dots',
      'bannerColor': '#fbbf24'
    },
  ];

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = true; // Force dark mode for consistency with design

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F04),
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorative glow
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFDFFF00).withOpacity(0.05),
                ),
              ),
            ),
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1F2113),
                            border: Border.all(
                              color: const Color(0x0DFFFFFF),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Color(0xFFE3E4CE),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Mind Vault',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFE3E4CE),
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _isEditing = !_isEditing),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isEditing
                                ? const Color(0xFFDFFF00)
                                : const Color(0xFF1F2113),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0x0DFFFFFF),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _isEditing ? 'Done' : 'Edit',
                            style: GoogleFonts.inter(
                              color: _isEditing
                                  ? Colors.black
                                  : const Color(0xFFE3E4CE),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Grid of Spaces
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.8, // Prevents text overflow
                    ),
                    itemCount: _spaces.length,
                    itemBuilder: (context, index) {
                      final space = _spaces[index];
                      return _buildSpaceCard(space, isDark);
                    },
                  ),
                ),
              ],
            ),

            // "New Space" FAB (Only visible when editing)
            if (_isEditing)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _addNewSpace, // <-- Calls the dialog function
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFFF00),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFDFFF00).withOpacity(0.3),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'New Space',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFFDFFF00),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpaceCard(Map<String, dynamic> space, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2113),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0x0DFFFFFF),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          if (space['bannerType'] == 'pattern' &&
              space['bannerValue'] == 'dots')
            PatternDots(color: Colors.white, opacity: 0.15),
          if (space['bannerType'] == 'pattern' &&
              space['bannerValue'] == 'circles')
            Positioned(
              top: -24,
              left: -24,
              child: SizedBox(
                width: 128,
                height: 128,
                child: ConcentricCircles(color: Colors.white, opacity: 0.1),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                space['title'],
                style: GoogleFonts.inter(
                  color: const Color(0xFFE3E4CE),
                  fontWeight: FontWeight.w600,
                  fontSize: 21,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.north_east,
                    color: Color(0xFFE3E4CE),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- NEW: Dialog to ask for space name ---
  void _addNewSpace() {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2113),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0x0DFFFFFF), width: 1),
        ),
        title: const Text(
          'New Space',
          style:
              TextStyle(color: Color(0xFFE3E4CE), fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: _controller,
          style: const TextStyle(color: Color(0xFFE3E4CE)),
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter space name...',
            hintStyle: TextStyle(color: Color(0xFFC6C9AB)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: Color(0x0DFFFFFF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: Color(0xFFDFFF00)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFFC6C9AB))),
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                setState(() {
                  _spaces.add({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'title': _controller.text.trim(),
                    'bannerType': 'color',
                    'bannerValue': 'bg-white',
                  });
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDFFF00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Create',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
