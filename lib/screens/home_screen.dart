// home_screen.dart
// This is the Grand Lobby of the Kismet app.
// It greets the user, offers the Serenity search kiosk,
// and presents the main Bento Box grid of content tiles.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import our two screens for navigation.
import 'mind_vault_screen.dart';

// Import our reusable furniture widgets.
import '../widgets/kismet_logo.dart'; // The official app wordmark sign.
import '../widgets/serenity_bar.dart'; // The AI search kiosk.
// Note: link_card.dart is not used directly here; the private _BentoLinkCard
// widget below handles link display inside the Bento grid.
import '../widgets/mind_space_card.dart'; // A card that represents a category.

// HomeScreen is StatelessWidget because the home lobby itself holds no state.
// All interactivity here is just navigation; nothing needs to be remembered.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // --- DUMMY DATA ---
  // Think of this as a fake menu board we hang in the lobby before the
  // real kitchen (state management) is connected. It shows visitors what
  // the food will look like, even though nothing is live yet.

  // A list of sample saved links. Each entry is a Map with three keys.
  static const List<Map<String, String>> _dummyLinks = [
    {
      'title': 'Why Flutter is the Future',
      'url': 'medium.com',
      'category': 'Development',
    },
    {
      'title': 'Bento UI Design Trends 2025',
      'url': 'dribbble.com',
      'category': 'Design',
    },
    {
      'title': 'The Art of Deep Work',
      'url': 'youtube.com',
      'category': 'Productivity',
    },
  ];

  // A list of sample Mind Space category names.
  static const List<String> _dummySpaces = ['Movies', 'Recipes', 'Education'];

  @override
  Widget build(BuildContext context) {
    // Scaffold is the skeleton of the screen.
    // It provides a standard page structure with background color support.
    return Scaffold(
      // The deep, almost-black green that is the foundation of our dark theme.
      backgroundColor: const Color(0xFF0D0F04),

      // SafeArea ensures our content never overlaps the phone's status bar
      // or the home indicator at the bottom. Like bumpers on a bowling lane.
      body: SafeArea(
        // SingleChildScrollView makes the entire screen scrollable.
        // This is important so the Bento grid is always accessible,
        // even on smaller phone screens.
        child: SingleChildScrollView(
          // physics controls how the scroll feels when you reach the end.
          // BouncingScrollPhysics gives a satisfying elastic bounce, like iOS.
          physics: const BouncingScrollPhysics(),

          child: Padding(
            // Apply equal horizontal padding of 24px on left and right.
            // This creates breathing room so content does not touch the screen edges.
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Column(
              // Stretch children to full width of the column.
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // =========================================================
                // SECTION 1: THE HEADER ROW
                // This is like the reception desk area at the top of the lobby.
                // Left side has the brand sign, right side has the profile button.
                // =========================================================
                const SizedBox(
                  height: 24,
                ), // Top breathing room above the header.

                Row(
                  // Space the logo and profile icon to opposite sides of the Row.
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    // Our new KismetLogo widget replaces the old hardcoded Text.
                    // It is now a proper, reusable piece of furniture.
                    const KismetLogo(),

                    // Profile icon button: a circle with a person outline inside.
                    // This is a placeholder for future profile/settings navigation.
                    Container(
                      width: 36, // Circle diameter.
                      height: 36, // Must match width for a perfect circle.

                      decoration: BoxDecoration(
                        // A perfect circle border, like a badge or avatar frame.
                        shape: BoxShape.circle,
                        border: Border.all(
                          // Subtle off-white border, not too bright.
                          color: const Color(0xFFE3E4CE),
                          width: 1, // Thin, delicate border line.
                        ),
                      ),

                      child: const Icon(
                        Icons.person_outline,
                        color: Color(0xFFE3E4CE), // Matching off-white icon.
                        size: 20, // Icon slightly smaller than the container.
                      ),
                    ),
                  ],
                ),

                // =========================================================
                // SECTION 2: THE GREETING
                // Like a welcome mat at the entrance, personalized to the visitor.
                // =========================================================
                const SizedBox(
                  height: 32,
                ), // Space between header and greeting.
                // The big, bold welcome name.
                Text(
                  'Hi, User',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFE3E4CE), // Off-white for the name.
                    fontWeight: FontWeight.w900, // Maximum bold, high impact.
                    fontSize: 32,
                    height:
                        1.0, // Tight line height so the two text lines sit close.
                  ),
                ),

                const SizedBox(
                  height: 8,
                ), // Small gap between name and tagline.
                // The soft tagline below the name.
                Text(
                  'what do you wanna rekindle today ....',
                  style: GoogleFonts.inter(
                    color: const Color(
                      0xFFC6C9AB,
                    ), // A slightly dimmer off-white.
                    fontWeight:
                        FontWeight.w400, // Regular weight for a gentle tone.
                    fontSize: 16,
                  ),
                ),

                // =========================================================
                // SECTION 3: THE SERENITY BAR (Information Kiosk)
                // Previously, this was a hardcoded widget duplicated right here.
                // Now we simply place our dedicated SerenityBar furniture piece.
                // It is like replacing a hand-drawn sign with a real printed one.
                // =========================================================
                const SizedBox(height: 24), // Space before the search bar.
                // SerenityBar is now imported and placed cleanly as a widget.
                // The Padding that used to wrap the inline search bar is gone.
                const SerenityBar(),

                // =========================================================
                // SECTION 4: THE BENTO BOX GRID
                // This is the main exhibit hall of the lobby.
                //
                // HOW IT WORKS (plain English):
                // Imagine a Japanese bento box tray. You have a big compartment
                // for the main meal and smaller ones for sides. In Flutter, we
                // build this tray row by row using Column and Row widgets.
                //
                // Each Row is one horizontal layer of the tray.
                // Inside a Row, we use Expanded(flex: N) to set proportional widths:
                //   - flex: 2 means "take up 2 shares of available space"
                //   - flex: 1 means "take up 1 share of available space"
                // So in a Row with flex:2 and flex:1, the first item is twice as wide.
                // We wrap cards in AspectRatio to control their height automatically.
                // =========================================================
                const SizedBox(height: 24), // Space before the grid begins.
                // --- BENTO ROW 1: Wide "Recent Links" + Narrow "Movies" ---
                // Like a big main dish compartment beside a smaller side dish.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align tops.
                  children: [
                    // LEFT: Wide card, takes 2 shares of horizontal space.
                    // This is the "hero" bento tile for recent saved links.
                    Expanded(
                      flex: 2, // This card is twice as wide as its neighbor.
                      child: AspectRatio(
                        // 0.9 ratio makes it slightly taller than it is wide.
                        // This gives it more visual weight as the hero tile.
                        aspectRatio: 0.9,
                        child: _BentoLinkCard(
                          // Pass the first dummy link from our list.
                          title: _dummyLinks[0]['title']!,
                          url: _dummyLinks[0]['url']!,
                          category: _dummyLinks[0]['category']!,
                          // isHero: true will signal special styling inside the card.
                          isHero: true,
                        ),
                      ),
                    ),

                    // A small horizontal gap between the two compartments.
                    const SizedBox(width: 12),

                    // RIGHT: Narrow card, takes 1 share of horizontal space.
                    // This is a category (Mind Space) tile, like a side dish.
                    Expanded(
                      flex: 1, // Half the width of its left neighbor.
                      child: AspectRatio(
                        // 0.9 ratio keeps the height consistent with the left card.
                        aspectRatio: 0.9,
                        child: MindSpaceCard(
                          // Use the first dummy space name.
                          title: _dummySpaces[0],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12), // Vertical gap between bento rows.
                // --- BENTO ROW 2: Two equal "Read" and "Design" link cards ---
                // Like two equal side dishes sitting next to each other.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT: Equal-width card for the second dummy link.
                    Expanded(
                      flex: 1, // Both cards share equal space in this row.
                      child: AspectRatio(
                        // A square aspect ratio (1:1) for a balanced look.
                        aspectRatio: 1,
                        child: _BentoLinkCard(
                          title: _dummyLinks[1]['title']!,
                          url: _dummyLinks[1]['url']!,
                          category: _dummyLinks[1]['category']!,
                          isHero:
                              false, // Not a hero, so standard styling applies.
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 12,
                    ), // Gap between the two equal cards.
                    // RIGHT: Equal-width card for the third dummy link.
                    Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: _BentoLinkCard(
                          title: _dummyLinks[2]['title']!,
                          url: _dummyLinks[2]['url']!,
                          category: _dummyLinks[2]['category']!,
                          isHero: false,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 12,
                ), // Vertical gap before the third row.
                // --- BENTO ROW 3: Two Mind Space cards + one wide placeholder ---
                // Like a row with two small snack compartments and a condiment container.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT: Narrow Mind Space card for "Recipes".
                    Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: MindSpaceCard(title: _dummySpaces[1]),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // MIDDLE: Another Mind Space card for "Education".
                    Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: MindSpaceCard(title: _dummySpaces[2]),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 12,
                ), // Gap before the final full-width tile.
                // --- BENTO ROW 4: Full-width "Mind Vault" teaser ---
                // This is the long bottom tray compartment spanning the full width.
                // It teases the Mind Vault screen and acts as the navigation gateway.
                _MindVaultTeaserCard(
                  onTap: () {
                    // Navigate to the MindVaultScreen when the tile is tapped.
                    Navigator.push(
                      context,
                      // MaterialPageRoute handles the transition animation.
                      MaterialPageRoute(
                        builder: (_) => const MindVaultScreen(),
                      ),
                    );
                  },
                ),

                // Bottom padding so the last card never sits flush with the edge.
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE HELPER WIDGET: _BentoLinkCard
// =============================================================================
// This is a styled wrapper around the core LinkCard concept, designed for
// the Bento grid. Think of it as a picture frame that can display a link.
// The 'isHero' flag controls whether it gets the yellow accent treatment.
// It is private (prefixed with _) because only this file needs it.
class _BentoLinkCard extends StatelessWidget {
  // Properties this card needs to display its content.
  final String title;
  final String url;
  final String category;
  final bool isHero; // If true, the card gets extra yellow styling.

  const _BentoLinkCard({
    required this.title,
    required this.url,
    required this.category,
    required this.isHero,
  });

  @override
  Widget build(BuildContext context) {
    // Container provides the visible box with background, corners, and border.
    return Container(
      decoration: BoxDecoration(
        // If this is the hero card, use a warmer dark tone to make it stand out.
        // Otherwise use the standard surface color.
        color: isHero
            ? const Color(0xFF252819) // Slightly warmer dark tone for the hero.
            : const Color(
                0xFF1F2113,
              ), // Standard surface color for normal cards.
        // 32px corner radius is our design system rule for all Bento tiles.
        borderRadius: BorderRadius.circular(32),

        border: Border.all(
          // Hero gets a yellow border; others get a subtle white border.
          color: isHero
              ? const Color(0xFFDFFF00).withValues(
                  alpha: 0.4,
                ) // Soft yellow glow.
              : Colors.white.withValues(alpha: 0.08), // Barely visible white.
          width: 1,
        ),
      ),

      // Internal padding so content does not touch the card edges.
      padding: const EdgeInsets.all(18),

      // Column stacks the content top to bottom inside the card.
      child: Column(
        // Align all text content to the left edge.
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // --- Category Label (top) ---
          // A small uppercase label, like a tab on a file folder.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              // Hero cards get a yellow pill; others get a dark pill.
              color: isHero
                  ? const Color(0xFFDFFF00).withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(9999), // Pill shape.
            ),
            child: Text(
              category.toUpperCase(), // Always uppercase for the label style.
              style: GoogleFonts.inter(
                // Hero category label uses yellow text; others use dim grey.
                color: isHero
                    ? const Color(0xFFDFFF00)
                    : const Color(0xFFC6C9AB),
                fontSize: 9, // Very small, like a fine-print label.
                fontWeight:
                    FontWeight.w700, // Bold so it stays legible despite size.
                letterSpacing: 1.5, // Wide spacing for that capsule-label look.
              ),
            ),
          ),

          // Spacer between the category label and the title.
          const Spacer(),

          // --- Link Title (middle, flexible) ---
          // The main descriptive name of the saved link.
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(
                0xFFE3E4CE,
              ), // Standard off-white for all titles.
              fontWeight: FontWeight.w700, // Bold for readability.
              fontSize: 14, // Medium size, fits within the tile.
              height: 1.3, // Slight line height for multi-line titles.
            ),
            // Limit to 3 lines so very long titles do not overflow the card.
            maxLines: 3,
            overflow: TextOverflow.ellipsis, // Truncate with "..." if too long.
          ),

          const SizedBox(height: 10), // Gap between title and the URL chip.
          // --- URL Chip (bottom) ---
          // A small pill showing the domain, like a source tag.
          Row(
            children: [
              // A tiny dot icon for visual flavor before the URL.
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFFC6C9AB), // Dim grey dot.
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6), // Small gap between dot and URL text.
              // The URL text itself, truncated if too long.
              Expanded(
                child: Text(
                  url,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFC6C9AB), // Dim muted color.
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis, // Clip long URLs.
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PRIVATE HELPER WIDGET: _MindVaultTeaserCard
// =============================================================================
// This is the full-width bottom Bento tile that navigates to the Mind Vault.
// Think of it as a large shop window you can tap to walk inside the library.
class _MindVaultTeaserCard extends StatelessWidget {
  // onTap is a callback function; it tells the card what to do when pressed.
  final VoidCallback onTap;

  const _MindVaultTeaserCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    // GestureDetector wraps the whole card to make it tappable.
    return GestureDetector(
      onTap: onTap, // Run the callback when the user taps the card.

      child: Container(
        // Fixed height for the teaser strip. Wide and short, like a footer banner.
        height: 90,

        decoration: BoxDecoration(
          color: const Color(0xFF1F2113), // Standard surface dark color.
          borderRadius: BorderRadius.circular(32), // Consistent 32px radius.
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08), // Very subtle border.
            width: 1,
          ),
        ),

        // Padding inside the card to keep content away from edges.
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),

        child: Row(
          // Space the title and arrow icon on opposite ends.
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          // Align items to the vertical center of the row.
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            // Left side: icon and label.
            Row(
              children: [
                // A small yellow brain icon to represent "Mind Vault".
                const Icon(
                  Icons
                      .hub_outlined, // A network/hub icon suggesting connections.
                  color: Color(0xFFDFFF00), // Branded yellow icon.
                  size: 22,
                ),

                const SizedBox(width: 12), // Gap between icon and text.
                // The section label.
                Text(
                  'Mind Vault',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFE3E4CE),
                    fontWeight: FontWeight.w800, // Heavy weight for the label.
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            // Right side: a chevron arrow indicating this is tappable.
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFC6C9AB), // Dim arrow, not too distracting.
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
