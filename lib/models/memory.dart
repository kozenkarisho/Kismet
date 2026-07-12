import 'package:isar/isar.dart';

// This tells Isar to generate the database code for this class
part 'memory.g.dart';

@collection
class Memory {
  // Every Isar object needs a unique ID. autoIncrement handles this for us.
  Id id = Isar.autoIncrement;

  late String url;
  late String title;
  late String summary; // The 2-sentence AI summary
  late List<String> tags; // The 3 AI tags (e.g., ['movies', 'sci-fi', '2024'])
  late DateTime createdAt;

  // A helpful constructor to make creating new memories easier
  Memory({
    required this.url,
    required this.title,
    required this.summary,
    required this.tags,
    required this.createdAt,
  });
}
