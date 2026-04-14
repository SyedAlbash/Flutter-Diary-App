import 'package:get/get.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';

class PinController extends GetxController {
  final RxString enteredPin = ''.obs;
  final RxString savedPin = ''.obs;
  final RxBool isError = false.obs;

  void addDigit(String digit) {
    if (enteredPin.value.length < 4) {
      enteredPin.value += digit;
      isError.value = false;
    }
  }

  void removeDigit() {
    if (enteredPin.value.isNotEmpty) {
      enteredPin.value =
          enteredPin.value.substring(0, enteredPin.value.length - 1);
    }
  }

  void clear() {
    enteredPin.value = '';
    isError.value = false;
  }

  void savePin() {
    savedPin.value = enteredPin.value;
    enteredPin.value = '';
  }

  Future<bool> confirmPin() async {
    if (enteredPin.value == savedPin.value) {
      await StorageUtil.setString(StorageUtil.keyPin, savedPin.value);
      await StorageUtil.setString(StorageUtil.keyLockType, 'pin');
      await StorageUtil.setBool(StorageUtil.keyOnboardingDone, true);
      return true;
    }
    isError.value = true;
    enteredPin.value = '';
    return false;
  }

  Future<bool> verifyPin() async {
    final storedPin = StorageUtil.getString(StorageUtil.keyPin);
    if (enteredPin.value == storedPin) {
      return true;
    }
    isError.value = true;
    enteredPin.value = '';
    return false;
  }
}
