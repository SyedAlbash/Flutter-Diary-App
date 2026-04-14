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
        final currentTheme = tc.currentTheme;
        final bgImage = currentTheme.backgroundImage;
        final isDark = currentTheme.brightness == Brightness.dark;

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
            child: Container(
              width: double.infinity,
              height: double.infinity,
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
              child: Container(
                color: showOverlay
                    ? Colors.black.withOpacity(0.1)
                    : Colors.transparent,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
