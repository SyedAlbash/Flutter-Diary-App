import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/core/theme/theme_controller.dart';
import 'package:diary_with_lock/features/auth/pattern/presentation/controllers/pattern_controller.dart';
import 'package:diary_with_lock/core/widgets/themed_background.dart';

class SetPatternPage extends StatefulWidget {
  const SetPatternPage({super.key});

  @override
  State<SetPatternPage> createState() => _SetPatternPageState();
}

class _SetPatternPageState extends State<SetPatternPage> {
  final controller = Get.put(PatternController());

  @override
  void initState() {
    super.initState();
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return _PatternScaffold(
      isVerify: false,
      title: 'Set a Pattern',
      subtitle: 'Draw a pattern to protect your diary.',
      controller: controller,
      showStepIndicator: true,
      stepIndex: 1,
      switchLabel: 'Switch to PIN',
      onSwitch: () => Get.toNamed(AppRoutes.setPin),
      onNext: () {
        if (controller.enteredPattern.length >= 4) {
          controller.savePattern();
          Get.toNamed(AppRoutes.confirmPattern);
        }
      },
    );
  }
}

class ConfirmPatternPage extends StatefulWidget {
  final bool isVerify;
  const ConfirmPatternPage({super.key, this.isVerify = false});

  @override
  State<ConfirmPatternPage> createState() => _ConfirmPatternPageState();
}

class _ConfirmPatternPageState extends State<ConfirmPatternPage> {
  final controller = Get.put(PatternController());

  @override
  void initState() {
    super.initState();
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return _PatternScaffold(
      isVerify: widget.isVerify,
      title: widget.isVerify ? 'Draw Pattern' : 'Confirm Pattern!',
      subtitle: widget.isVerify
          ? 'Enter your pattern to unlock.'
          : 'Draw the pattern again to confirm.',
      controller: controller,
      showStepIndicator: !widget.isVerify,
      stepIndex: 2,
      switchLabel: widget.isVerify ? null : 'Switch to PIN',
      onSwitch:
          widget.isVerify ? null : () => Get.toNamed(AppRoutes.confirmPin),
      onNext: () async {
        if (controller.enteredPattern.length >= 4) {
          if (widget.isVerify) {
            final ok = await controller.verifyPattern();
            if (ok) Get.offAllNamed(AppRoutes.home);
          } else {
            final ok = await controller.confirmPattern();
            if (ok) {
              Get.offAllNamed(AppRoutes.securityQuestion);
            }
          }
        }
      },
    );
  }
}

class _PatternScaffold extends StatelessWidget {
  final bool isVerify;
  final String title;
  final String subtitle;
  final PatternController controller;
  final bool showStepIndicator;
  final int stepIndex;
  final String? switchLabel;
  final VoidCallback? onSwitch;
  final VoidCallback onNext;

  const _PatternScaffold({
    required this.isVerify,
    required this.title,
    required this.subtitle,
    required this.controller,
    required this.showStepIndicator,
    required this.stepIndex,
    required this.switchLabel,
    required this.onSwitch,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (tc) {
        final currentTheme = tc.getThemeFor(route: Get.currentRoute);
        final isDark = currentTheme.brightness == Brightness.dark;
        final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
        final subTextColor = isDark ? Colors.white70 : const Color(0xFF7F8C8D);

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new,
                  color: isDark ? Colors.white : Colors.black),
              onPressed: () => Get.back(),
            ),
          ),
          body: ThemedBackground(
            child: GestureDetector(
              onTap: () {
                // Reset pattern when tapping anywhere outside the interactive elements
                controller.clear();
              },
              behavior: HitTestBehavior.opaque,
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            // Diary Illustration
                            Center(
                              child: Image.asset(
                                'assets/images/screens/Group 162759.png',
                                height: 110,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Password / Pattern Toggle
                            if (onSwitch != null)
                              GestureDetector(
                                onTap:
                                    () {}, // Prevent clearing when tapping toggle
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.1)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: isDark
                                        ? null
                                        : [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.05),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: onSwitch,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Password',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                color: isDark
                                                    ? Colors.white
                                                    : const Color(0xFF2C3E50),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {}, // Already on Pattern
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF3B9EFE),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Pattern',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            Text(
                              title,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            if (subtitle.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                subtitle,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            // Pattern Grid
                            GestureDetector(
                              onTap:
                                  () {}, // Prevent clearing when tapping grid
                              child: SizedBox(
                                height: 240,
                                child: Center(
                                  child: Obx(() => _PatternGrid(
                                        controller: controller,
                                        isError: controller.isError.value,
                                        onFinish: isVerify ? onNext : null,
                                      )),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (controller.isError.value)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                    isVerify
                                        ? 'Pattern is incorrect'
                                        : 'Patterns do not match',
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12)),
                              ),
                            if (isVerify)
                              TextButton(
                                onPressed: () =>
                                    Get.toNamed(AppRoutes.recovery),
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B9EFE)
                                      .withValues(alpha: 0.1),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'Forgot Passcode?',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF3B9EFE),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (!isVerify)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: Obx(() {
                            final isEnabled =
                                controller.enteredPattern.length >= 4;
                            return GestureDetector(
                              onTap:
                                  () {}, // Prevent clearing when tapping button
                              child: ElevatedButton(
                                onPressed: isEnabled ? onNext : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B9EFE),
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                      const Color(0xFF3B9EFE)
                                          .withValues(alpha: 0.3),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                child: Text(
                                  showStepIndicator ? 'Continue' : 'Unlock',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PatternGrid extends StatefulWidget {
  final PatternController controller;
  final bool isError;
  final VoidCallback? onFinish;

  const _PatternGrid({
    required this.controller,
    required this.isError,
    this.onFinish,
  });

  @override
  State<_PatternGrid> createState() => _PatternGridState();
}

class _PatternGridState extends State<_PatternGrid> {
  Offset? _currentPosition;
  final List<GlobalKey> _keys = List.generate(9, (_) => GlobalKey());

  int? _getDotAt(Offset position) {
    for (int i = 0; i < 9; i++) {
      final ctx = _keys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox;
      final pos = box.localToGlobal(Offset.zero);
      final rect =
          Rect.fromLTWH(pos.dx, pos.dy, box.size.width, box.size.height);
      if (rect.contains(position)) return i;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isError ? Colors.red : const Color(0xFF3B9EFE);
    return GestureDetector(
      onPanStart: (d) {
        widget.controller.clear();
        setState(() => _currentPosition = d.globalPosition);
        final dot = _getDotAt(d.globalPosition);
        if (dot != null) widget.controller.addDot(dot);
      },
      onPanUpdate: (d) {
        setState(() => _currentPosition = d.globalPosition);
        final dot = _getDotAt(d.globalPosition);
        if (dot != null) widget.controller.addDot(dot);
      },
      onPanEnd: (_) {
        setState(() => _currentPosition = null);
        if (widget.controller.enteredPattern.length >= 4) {
          // Add a small delay so the user can see the completed pattern before it disappears or unlocks
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && widget.onFinish != null) {
              widget.onFinish!();
            }
          });
        }
      },
      child: Container(
        width: 260,
        height: 260,
        color: Colors.transparent,
        child: Obx(() => CustomPaint(
              painter: _PatternPainter(
                selected: widget.controller.enteredPattern,
                current: _currentPosition,
                keys: _keys,
                color: color,
              ),
              child: GridView.count(
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(9, (i) {
                  final selected = widget.controller.enteredPattern.contains(i);
                  return Center(
                    key: _keys[i],
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: selected ? 20 : 16,
                      height: selected ? 20 : 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected ? color : Colors.transparent,
                        border: Border.all(
                          color: selected
                              ? color
                              : const Color(0xFF3B9EFE).withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            )),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final List<int> selected;
  final Offset? current;
  final List<GlobalKey> keys;
  final Color color;

  _PatternPainter({
    required this.selected,
    required this.current,
    required this.keys,
    required this.color,
  });

  Offset? _center(int index) {
    final ctx = keys[index].currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final pos = box.localToGlobal(Offset.zero);
    return Offset(pos.dx + box.size.width / 2, pos.dy + box.size.height / 2);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (selected.isEmpty) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    RenderBox? referenceBox;
    for (var key in keys) {
      if (key.currentContext != null) {
        referenceBox = key.currentContext!.findRenderObject() as RenderBox?;
        break;
      }
    }
    if (referenceBox == null) return;

    final firstDotPos = _center(0);
    if (firstDotPos == null) return;

    final painterOrigin = Offset(
      firstDotPos.dx - (280 / 6),
      firstDotPos.dy - (280 / 6),
    );

    for (int i = 0; i < selected.length - 1; i++) {
      final a = _center(selected[i]);
      final b = _center(selected[i + 1]);
      if (a != null && b != null) {
        canvas.drawLine(a - painterOrigin, b - painterOrigin, paint);
      }
    }

    if (current != null && selected.isNotEmpty) {
      final last = _center(selected.last);
      if (last != null) {
        canvas.drawLine(last - painterOrigin, current! - painterOrigin, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
