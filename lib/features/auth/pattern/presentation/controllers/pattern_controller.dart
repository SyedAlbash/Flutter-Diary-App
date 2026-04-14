import 'package:get/get.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';

class PatternController extends GetxController {
  final RxList<int> enteredPattern = <int>[].obs;
  final RxList<int> savedPattern = <int>[].obs;
  final RxBool isError = false.obs;
  final RxBool isDrawing = false.obs;

  void addDot(int index) {
    if (!enteredPattern.contains(index)) {
      enteredPattern.add(index);
      isError.value = false;
    }
  }

  void clear() {
    enteredPattern.clear();
    isError.value = false;
    isDrawing.value = false;
  }

  void savePattern() {
    savedPattern.assignAll(enteredPattern);
    enteredPattern.clear();
  }

  Future<bool> confirmPattern() async {
    if (_listEquals(enteredPattern, savedPattern)) {
      await StorageUtil.setString(
          StorageUtil.keyPattern, savedPattern.join(','));
      await StorageUtil.setString(StorageUtil.keyLockType, 'pattern');
      await StorageUtil.setBool(StorageUtil.keyOnboardingDone, true);
      return true;
    }
    isError.value = true;
    enteredPattern.clear();
    return false;
  }

  Future<bool> verifyPattern() async {
    final stored = StorageUtil.getString(StorageUtil.keyPattern);
    final storedList =
        stored?.split(',').map(int.parse).toList() ?? [];
    if (_listEquals(enteredPattern, storedList)) {
      return true;
    }
    isError.value = true;
    enteredPattern.clear();
    return false;
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
