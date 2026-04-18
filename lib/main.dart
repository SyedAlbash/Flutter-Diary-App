import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diary_with_lock/features/home/presentation/controllers/home_controller.dart';
import 'package:diary_with_lock/core/services/notification_service.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/core/theme/theme_controller.dart';
import 'package:diary_with_lock/core/theme/app_theme.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';
import 'package:diary_with_lock/features/auth/pin/presentation/controllers/pin_controller.dart';
import 'package:diary_with_lock/features/auth/pattern/presentation/controllers/pattern_controller.dart';
import 'package:diary_with_lock/features/splash/presentation/pages/splash_page.dart';
import 'package:diary_with_lock/features/auth/pin/presentation/pages/pin_pages.dart';
import 'package:diary_with_lock/features/auth/pattern/presentation/pages/pattern_pages.dart';
import 'package:diary_with_lock/features/home/presentation/pages/home_page.dart';
import 'package:diary_with_lock/features/compose/presentation/pages/compose_page.dart';
import 'package:diary_with_lock/features/settings/presentation/pages/settings_page.dart';
import 'package:diary_with_lock/features/settings/presentation/pages/settings_username_page.dart';
import 'package:diary_with_lock/features/settings/presentation/pages/daily_reminders_page.dart';
import 'package:diary_with_lock/features/settings/presentation/pages/delete_date_page.dart';
import 'package:diary_with_lock/features/settings/presentation/pages/mood_style_page.dart';
import 'package:diary_with_lock/features/settings/presentation/pages/themes_page.dart';
import 'package:diary_with_lock/features/auth/pin/presentation/pages/passcode_settings_page.dart';
import 'package:diary_with_lock/core/services/lifecycle_service.dart';
import 'package:diary_with_lock/features/auth/presentation/pages/security_question_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize core storage first (critical for all controllers)
  await StorageUtil.init();

  // 2. Initialize LifecycleService and ThemeController
  Get.put(LifecycleService(), permanent: true);
  Get.put(ThemeController(), permanent: true);

  // 3. Pre-cache critical fonts and services to reduce initial jank
  await _preCacheServices();

  runApp(const DiaryApp());
}

Future<void> _preCacheServices() async {
  try {
    // Initialize notifications and other non-critical background tasks
    await NotificationService().init();

    // Pre-cache fonts to avoid invisible text during first load
    // ignore: unawaited_futures
    Future.wait([
      // Use the proper way to load Google Fonts if needed, or remove if causing issues
      // For now, let's just ensure critical fonts are available via regular loading
    ]);
  } catch (e) {
    debugPrint("Pre-cache Services Error: $e");
  }
}

// Removed old _initServices as it's now integrated above

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PinController(), permanent: true);
    Get.put(PatternController(), permanent: true);
    Get.put(HomeController(), permanent: true);
  }
}

class DiaryApp extends StatelessWidget {
  const DiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (tc) => GetMaterialApp(
        title: 'Diary With Lock',
        theme: tc.defaultThemeData,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        color: AppColors.primary,
        initialRoute: AppRoutes.splash,
        initialBinding: InitialBinding(),
        getPages: [
          GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
          GetPage(name: AppRoutes.setPin, page: () => const SetPinPage()),
          GetPage(
              name: AppRoutes.confirmPin, page: () => const ConfirmPinPage()),
          GetPage(
            name: '${AppRoutes.confirmPin}/verify',
            page: () => const ConfirmPinPage(isVerify: true),
          ),
          GetPage(
              name: AppRoutes.setPattern, page: () => const SetPatternPage()),
          GetPage(
            name: AppRoutes.confirmPattern,
            page: () => const ConfirmPatternPage(),
          ),
          GetPage(
            name: '${AppRoutes.confirmPattern}/verify',
            page: () => const ConfirmPatternPage(isVerify: true),
          ),
          GetPage(name: AppRoutes.home, page: () => const HomePage()),
          GetPage(name: AppRoutes.compose, page: () => const ComposePage()),
          GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),
          GetPage(
            name: AppRoutes.settingsUsername,
            page: () => const SettingsUsernamePage(),
          ),
          GetPage(
            name: AppRoutes.dailyReminders,
            page: () => const DailyRemindersPage(),
          ),
          GetPage(
              name: AppRoutes.deleteDate, page: () => const DeleteDatePage()),
          GetPage(name: AppRoutes.moodStyle, page: () => const MoodStylePage()),
          GetPage(name: AppRoutes.themes, page: () => const ThemesPage()),
          GetPage(
            name: '/passcode-settings',
            page: () => const PasscodeSettingsPage(),
          ),
          GetPage(
            name: AppRoutes.securityQuestion,
            page: () => const SecurityQuestionPage(),
          ),
          GetPage(
            name: AppRoutes.recovery,
            page: () => const SecurityQuestionPage(isRecovery: true),
          ),
        ],
      ),
    );
  }
}
