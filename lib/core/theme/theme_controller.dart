import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';

/// Defines a single app theme with all the colors needed
class AppThemeData {
  final String name;
  final Color primary;
  final Color primaryLight;
  final Color accent;
  final Color background;
  final Color scaffoldBackground;
  final Color cardBg;
  final Color textDark;
  final Color textGrey;
  final Color bottomNavBg;
  final Color pinCircle;
  final Color patternDot;
  final List<Color> gradientColors;
  final Brightness brightness;
  final String? backgroundImage;

  const AppThemeData({
    required this.name,
    required this.primary,
    required this.primaryLight,
    required this.accent,
    required this.background,
    required this.scaffoldBackground,
    required this.cardBg,
    required this.textDark,
    required this.textGrey,
    required this.bottomNavBg,
    required this.pinCircle,
    required this.patternDot,
    required this.gradientColors,
    this.brightness = Brightness.light,
    this.backgroundImage,
  });
}

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();

  final _themeIndex = 0.obs;
  int get themeIndex => _themeIndex.value;

  /// All available themes (showing only those with pictures)
  static const List<AppThemeData> themes = [
    // 0 - Sky Blue (Home Empty State base theme)
    AppThemeData(
      name: 'Sky Blue',
      primary: Color(0xFF3B9EFE),
      primaryLight: Color(0xFFE3F2FD),
      accent: Color(0xFFBBDEFB),
      background: Color(0xFFF5F9FF),
      scaffoldBackground: Color(0xFFF5F9FF),
      cardBg: Colors.white,
      textDark: Color(0xFF1A1A1A),
      textGrey: Color(0xFF757575),
      bottomNavBg: Colors.white,
      pinCircle: Color(0xFF3B9EFE),
      patternDot: Color(0xFF3B9EFE),
      gradientColors: [Color(0xFFE0F2FD), Color(0xFFF9E8F5)],
      brightness: Brightness.light,
    ),
    // 1 - Dreamy (1.png – dark blue witch / moonlit night)
    // 1 - Stellar (2.png – dark wood candles / writing)
    AppThemeData(
      name: 'Stellar',
      primary: Color(0xFFFFB74D),
      primaryLight: Color(0xFF5D3A1A),
      accent: Color(0xFFFFCC80),
      background: Color(0xFF1A0C04),
      scaffoldBackground: Colors.transparent,
      cardBg: Color(0xCC2A1810),
      textDark: Color(0xFFFFE8D0),
      textGrey: Color(0xFFBCA088),
      bottomNavBg: Color(0xE62A1810),
      pinCircle: Color(0xFFFFB74D),
      patternDot: Color(0xFFFFB74D),
      gradientColors: [Color(0xFF1A0C04), Color(0xFF3E2010)],
      brightness: Brightness.dark,
      backgroundImage: 'assets/images/themes/2.png',
    ),
    // 2 - Magic (4.png – girl on bike, light purple road)
    AppThemeData(
      name: 'Magic',
      primary: Color(0xFF7B1FA2),
      primaryLight: Color(0xFFE1BEE7),
      accent: Color(0xFFF3E5F5),
      background: Color(0xFFC4B0D8),
      scaffoldBackground: Colors.transparent,
      cardBg: Color(0xD9FFFFFF),
      textDark: Color(0xFF3D1060),
      textGrey: Color(0xFF6A4890),
      bottomNavBg: Color(0xCCFFFFFF),
      pinCircle: Color(0xFF7B1FA2),
      patternDot: Color(0xFF7B1FA2),
      gradientColors: [Color(0xFF7B1FA2), Color(0xFFC4B0D8)],
      backgroundImage: 'assets/images/themes/4.png',
    ),
    // 3 - Ethereal (8.png – unicorn, light lavender/pink)
    AppThemeData(
      name: 'Ethereal',
      primary: Color(0xFF8E4EC6),
      primaryLight: Color(0xFFE8D0F8),
      accent: Color(0xFFF0E4FA),
      background: Color(0xFFBEB0D8),
      scaffoldBackground: Colors.transparent,
      cardBg: Color(0xD9FFFFFF),
      textDark: Color(0xFF3A1860),
      textGrey: Color(0xFF6850A0),
      bottomNavBg: Color(0xCCFFFFFF),
      pinCircle: Color(0xFF8E4EC6),
      patternDot: Color(0xFF8E4EC6),
      gradientColors: [Color(0xFF8E4EC6), Color(0xFFBEB0D8)],
      backgroundImage: 'assets/images/themes/8.png',
    ),
    // 4 - Cloudy (9.png – girl reading under moonlight, dark navy)
    AppThemeData(
      name: 'Cloudy',
      primary: Color(0xFFFDD835),
      primaryLight: Color(0xFF1A2448),
      accent: Color(0xFFFFE082),
      background: Color(0xFF0A1430),
      scaffoldBackground: Colors.transparent,
      cardBg: Color(0xCC122040),
      textDark: Color(0xFFD8E4F4),
      textGrey: Color(0xFF8898C0),
      bottomNavBg: Color(0xE6122040),
      pinCircle: Color(0xFFFDD835),
      patternDot: Color(0xFFFDD835),
      gradientColors: [Color(0xFF0A1430), Color(0xFF1A3060)],
      brightness: Brightness.dark,
      backgroundImage: 'assets/images/themes/9.png',
    ),
    // 5 - Galaxy (11.png – sunset palm trees, warm sandy bottom)
    AppThemeData(
      name: 'Galaxy',
      primary: Color(0xFF1A5276),
      primaryLight: Color(0xFFFFE0A0),
      accent: Color(0xFFFFF5E0),
      background: Color(0xFFF0C878),
      scaffoldBackground: Colors.transparent,
      cardBg: Color(0xD9FFFFFF),
      textDark: Color(0xFF1A2840),
      textGrey: Color(0xFF4A5A70),
      bottomNavBg: Color(0xCCFFFFFF),
      pinCircle: Color(0xFF1A5276),
      patternDot: Color(0xFF1A5276),
      gradientColors: [Color(0xFF1A5276), Color(0xFFF0C878)],
      backgroundImage: 'assets/images/themes/11.png',
    ),
    // 6 - Bloom (14.png – carnival fireworks, dark magenta/purple)
    AppThemeData(
      name: 'Bloom',
      primary: Color(0xFFFF8A65),
      primaryLight: Color(0xFF4A1830),
      accent: Color(0xFFFFAB91),
      background: Color(0xFF3A1028),
      scaffoldBackground: Colors.transparent,
      cardBg: Color(0xCC401838),
      textDark: Color(0xFFF4D8E4),
      textGrey: Color(0xFFC8A0B4),
      bottomNavBg: Color(0xE6401838),
      pinCircle: Color(0xFFFF8A65),
      patternDot: Color(0xFFFF8A65),
      gradientColors: [Color(0xFF3A1028), Color(0xFF6A2050)],
      brightness: Brightness.dark,
      backgroundImage: 'assets/images/themes/14.png',
    ),
    // 7 - Sunny (15.png – mushroom candy land, salmon pink)
    AppThemeData(
      name: 'Sunny',
      primary: Color(0xFFC62828),
      primaryLight: Color(0xFFFFCDD2),
      accent: Color(0xFFFFEBEE),
      background: Color(0xFFE8A098),
      scaffoldBackground: Colors.transparent,
      cardBg: Color(0xD9FFFFFF),
      textDark: Color(0xFF5A1818),
      textGrey: Color(0xFF884040),
      bottomNavBg: Color(0xCCFFFFFF),
      pinCircle: Color(0xFFC62828),
      patternDot: Color(0xFFC62828),
      gradientColors: [Color(0xFFC62828), Color(0xFFE8A098)],
      backgroundImage: 'assets/images/themes/15.png',
    ),
    // 8 - Ocean (16.png – girl by night ocean, dark teal-blue)
    AppThemeData(
      name: 'Ocean',
      primary: Color(0xFFE040FB),
      primaryLight: Color(0xFF05384A),
      accent: Color(0xFFCE93D8),
      background: Color(0xFF003850),
      scaffoldBackground: Colors.transparent,
      cardBg: Color(0xCC054060),
      textDark: Color(0xFFD0F0F8),
      textGrey: Color(0xFF80B8D0),
      bottomNavBg: Color(0xE6054060),
      pinCircle: Color(0xFFE040FB),
      patternDot: Color(0xFFE040FB),
      gradientColors: [Color(0xFF003850), Color(0xFF106880)],
      brightness: Brightness.dark,
      backgroundImage: 'assets/images/themes/16.png',
    ),
    // 9 - Rose (17.png – bunnies in flower garden, dark green)
    AppThemeData(
      name: 'Rose',
      primary: Color(0xFF81C784),
      primaryLight: Color(0xFF1B3A20),
      accent: Color(0xFFA5D6A7),
      background: Color(0xFF2A4A30),
      scaffoldBackground: Colors.transparent,
      cardBg: Color(0xCC1A3820),
      textDark: Color(0xFFDCF0E0),
      textGrey: Color(0xFF98C0A0),
      bottomNavBg: Color(0xE61A3820),
      pinCircle: Color(0xFF81C784),
      patternDot: Color(0xFF81C784),
      gradientColors: [Color(0xFF2A4A30), Color(0xFF3A6A40)],
      brightness: Brightness.dark,
      backgroundImage: 'assets/images/themes/17.png',
    ),
    // 10 - Twilight (28.png – cyclist with balloons, light cream)
    AppThemeData(
      name: 'Twilight',
      primary: Color(0xFF5C6BC0),
      primaryLight: Color(0xFFC5CAE9),
      accent: Color(0xFFE8EAF6),
      background: Color(0xFFF5ECE0),
      scaffoldBackground: Colors.transparent,
      cardBg: Color(0xD9FFFFFF),
      textDark: Color(0xFF2A1A50),
      textGrey: Color(0xFF6A5A88),
      bottomNavBg: Color(0xCCFFFFFF),
      pinCircle: Color(0xFF5C6BC0),
      patternDot: Color(0xFF5C6BC0),
      gradientColors: [Color(0xFF5C6BC0), Color(0xFFF5ECE0)],
      backgroundImage: 'assets/images/themes/28.png',
    ),
    // 11 - Mystery (30.png – adventure van in mountains, pink)
    AppThemeData(
      name: 'Mystery',
      primary: Color(0xFFD81B60),
      primaryLight: Color(0xFFF8BBD0),
      accent: Color(0xFFFCE4EC),
      background: Color(0xFFF8A0C8),
      scaffoldBackground: Colors.transparent,
      cardBg: Color(0xD9FFFFFF),
      textDark: Color(0xFF6A0838),
      textGrey: Color(0xFF9A4070),
      bottomNavBg: Color(0xCCFFFFFF),
      pinCircle: Color(0xFFD81B60),
      patternDot: Color(0xFFD81B60),
      gradientColors: [Color(0xFFD81B60), Color(0xFFF8A0C8)],
      backgroundImage: 'assets/images/themes/30.png',
    ),
  ];

  AppThemeData get currentTheme => themes[_themeIndex.value];

  bool get isLockCreated =>
      StorageUtil.getString(StorageUtil.keyLockType) != null;

  /// Determines if the custom theme should be applied based on route and tab
  bool shouldApplyTheme(String? route, {int? tabIndex}) {
    final bool isLockScreen = route?.contains('/verify') ?? false;
    final bool isHomePage = route == AppRoutes.home;

    if (isHomePage) {
      // Only apply theme on the Diary tab (index 0) if a lock is created
      return isLockCreated && tabIndex == 0;
    }

    if (isLockScreen) {
      // Only apply theme on lock screen if a lock is actually created
      return isLockCreated;
    }

    return false;
  }

  AppThemeData getThemeFor({String? route, int? tabIndex}) {
    return shouldApplyTheme(route, tabIndex: tabIndex)
        ? currentTheme
        : themes[0];
  }

  ThemeData getThemeDataFor({String? route, int? tabIndex}) {
    return _buildThemeData(getThemeFor(route: route, tabIndex: tabIndex));
  }

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    final stored = StorageUtil.getString('theme_index');
    debugPrint("ThemeController: Loading theme from storage: $stored");
    if (stored != null) {
      final idx = int.tryParse(stored) ?? 0;
      if (idx >= 0 && idx < themes.length) {
        _themeIndex.value = idx;
      }
    } else {
      debugPrint(
          "ThemeController: No theme found in storage, using default (0)");
    }
  }

  void refreshTheme() {
    _loadTheme();
    update();
  }

  Future<void> changeTheme(int index) async {
    if (index >= 0 && index < themes.length) {
      _themeIndex.value = index;
      await StorageUtil.setString('theme_index', index.toString());

      // Notify GetBuilder listeners (including the root app widget)
      update();

      // Force a rebuild on the next frame so all Obx widgets repaint
      Get.forceAppUpdate();
    }
  }

  ThemeData get themeData => _buildThemeData(currentTheme);
  ThemeData get defaultThemeData => _buildThemeData(themes[0]);

  static ThemeData _buildThemeData(AppThemeData t) {
    final isDark = t.brightness == Brightness.dark;
    return ThemeData(
      brightness: t.brightness,
      primaryColor: t.primary,
      scaffoldBackgroundColor: t.scaffoldBackground,
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: t.primary,
              secondary: t.accent,
              surface: t.cardBg,
            )
          : ColorScheme.light(
              primary: t.primary,
              secondary: t.accent,
            ),
      textTheme: GoogleFonts.poppinsTextTheme(
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: t.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: t.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: t.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
