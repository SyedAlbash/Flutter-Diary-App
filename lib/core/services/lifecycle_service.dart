import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';

class LifecycleService extends GetxService with WidgetsBindingObserver {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndLock();
    }
  }

  void _checkAndLock() {
    final lockType = StorageUtil.getString(StorageUtil.keyLockType);
    if (lockType == null) return;

    // Don't lock if we're already on a lock or setup screen
    final currentRoute = Get.currentRoute;
    if (currentRoute == AppRoutes.setPin ||
        currentRoute == AppRoutes.confirmPin ||
        currentRoute == AppRoutes.setPattern ||
        currentRoute == AppRoutes.confirmPattern ||
        currentRoute == AppRoutes.splash ||
        currentRoute == '/confirm-pin/verify' ||
        currentRoute == '/confirm-pattern/verify' ||
        currentRoute == AppRoutes.securityQuestion ||
        currentRoute == AppRoutes.recovery) {
      return;
    }

    if (lockType == 'pin') {
      Get.offAllNamed('${AppRoutes.confirmPin}/verify');
    } else if (lockType == 'pattern') {
      Get.offAllNamed('${AppRoutes.confirmPattern}/verify');
    }
  }
}
