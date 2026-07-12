import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/memory.dart';

class DatabaseService {
  Isar? _isar;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([MemorySchema], directory: dir.path);
    _isInitialized = true;
  }

  Future<void> addMemory(Memory memory) async {
    await _isar!.writeTxn(() async {
      await _isar!.memorys.put(memory);
    });
  }

  List<Memory> getAllMemories() {
    return _isar!.memorys.where().findAllSync();
  }

  List<Memory> getMemoriesByTag(String tag) {
    return _isar!.memorys.filter().tagsElementEqualTo(tag).findAllSync();
  }
}
