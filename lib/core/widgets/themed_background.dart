import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:diary_with_lock/core/theme/theme_controller.dart';

class ThemedBackground extends StatelessWidget {
  final Widget child;
  final bool showOverlay;

  const ThemedBackground({
    super.key,
    required this.child,
    this.showOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (tc) {
        final currentRoute = Get.currentRoute;
        final currentTheme = tc.getThemeFor(route: currentRoute);
        final bgImage = currentTheme.backgroundImage;
        final isDark = currentTheme.brightness == Brightness.dark;

        final size = MediaQuery.of(context).size;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: currentTheme.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: currentTheme.bottomNavBg,
            systemNavigationBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
          ),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                // Fixed background that covers the entire screen regardless of keyboard
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Container(
                    decoration: BoxDecoration(
                      color: currentTheme.background,
                      image: bgImage != null
                          ? DecorationImage(
                              image: AssetImage(bgImage),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            )
                          : null,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: showOverlay
                      ? Colors.black.withValues(alpha: 0.1)
                      : Colors.transparent,
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
