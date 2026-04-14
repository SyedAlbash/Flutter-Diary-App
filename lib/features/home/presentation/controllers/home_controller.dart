import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:diary_with_lock/core/database/database_helper.dart';
import 'package:diary_with_lock/features/home/data/models/diary_entry.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';

class HomeController extends GetxController {
  final RxList<DiaryEntry> entries = <DiaryEntry>[].obs;
  final RxString userName = ''.obs;
  final RxInt currentTab = 0.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserName();
    _loadEntries();
  }

  void _loadUserName() {
    userName.value = StorageUtil.getString(StorageUtil.keyUserName) ?? 'Beautiful';
  }

  Future<void> _loadEntries() async {
    try {
      final data = await DatabaseHelper.instance.getAllEntries();
      entries.assignAll(data);
      debugPrint("HomeController: Loaded ${data.length} entries");
    } catch (e) {
      debugPrint("HomeController: Error loading entries: $e");
    }
  }

  Future<void> addEntry(DiaryEntry entry) async {
    try {
      await DatabaseHelper.instance.insert(entry);
      await _loadEntries();
      entries.refresh();
      update();
      debugPrint("HomeController: Entry added successfully");
    } catch (e) {
      debugPrint("HomeController: Error adding entry: $e");
    }
  }

  Future<void> deleteEntry(String id) async {
    await DatabaseHelper.instance.delete(id);
    await _loadEntries();
    entries.refresh();
    update();
  }

  List<DiaryEntry> get entriesForPhotos =>
      entries.where((e) => e.imagePaths.isNotEmpty).toList();

  void sortNewestFirst() {
    entries.sort((a, b) => b.date.compareTo(a.date));
    entries.refresh();
    update();
  }

  void sortOldestFirst() {
    entries.sort((a, b) => a.date.compareTo(b.date));
    entries.refresh();
    update();
  }

  Future<void> updateEntry(DiaryEntry updatedEntry) async {
    try {
      await DatabaseHelper.instance.update(updatedEntry);
      await _loadEntries();
      entries.refresh();
      update();
      debugPrint("HomeController: Entry updated successfully");
    } catch (e) {
      debugPrint("HomeController: Error updating entry: $e");
    }
  }

  Future<void> deleteAllEntries() async {
    await DatabaseHelper.instance.deleteAll();
    entries.clear();
  }

  List<DiaryEntry> getEntriesForDate(DateTime date) {
    return entries.where((e) =>
        e.date.year == date.year &&
        e.date.month == date.month &&
        e.date.day == date.day).toList();
  }
}
