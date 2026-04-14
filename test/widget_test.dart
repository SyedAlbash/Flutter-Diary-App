import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';
import 'package:diary_with_lock/core/theme/theme_controller.dart';
import 'package:diary_with_lock/main.dart';

void main() {
  setUp(() async {
    // Initialize required services for the app to build
    SharedPreferences.setMockInitialValues({});
    await StorageUtil.init();
    
    // Put ThemeController so GetBuilder in DiaryApp works
    Get.put(ThemeController());
  });

  tearDown(() {
    Get.reset(); // Clear GetX dependencies after each test
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DiaryApp());

    // Verify that it doesn't crash on initial build.
    expect(tester.takeException(), isNull);
  });
}
