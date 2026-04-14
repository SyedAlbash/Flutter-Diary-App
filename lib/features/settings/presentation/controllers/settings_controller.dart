import 'package:get/get.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';

class SettingsController extends GetxController {
  var reminderEnabled = false.obs;
  var reminderTime = '10:41'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    reminderEnabled.value = StorageUtil.getBool(StorageUtil.keyReminderEnabled, defaultValue: true);
    reminderTime.value = StorageUtil.getString(StorageUtil.keyReminderTime) ?? '10:41';
  }

  String get formattedReminderTime {
    final parts = reminderTime.value.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]).toString().padLeft(2, '0');
    final isPM = hour >= 12;
    final h = (hour % 12 == 0) ? 12 : hour % 12;
    return '$h:$minute ${isPM ? 'PM' : 'AM'}';
  }
}
