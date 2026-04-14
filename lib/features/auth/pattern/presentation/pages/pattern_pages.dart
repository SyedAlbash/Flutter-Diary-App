import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/features/auth/pattern/presentation/controllers/pattern_controller.dart';
import 'package:diary_with_lock/core/widgets/themed_background.dart';

class SetPatternPage extends StatelessWidget {
  const SetPatternPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatternController());
    return _PatternScaffold(
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

class ConfirmPatternPage extends StatelessWidget {
  final bool isVerify;
  const ConfirmPatternPage({super.key, this.isVerify = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PatternController());
    return _PatternScaffold(
      title: isVerify ? 'Draw Pattern' : 'Confirm Pattern!',
      subtitle: isVerify
          ? 'Enter your pattern to unlock.'
          : 'Draw the pattern again to confirm.',
      controller: controller,
      showStepIndicator: !isVerify,
      stepIndex: 2,
      switchLabel: isVerify ? null : 'Switch to PIN',
      onSwitch: isVerify ? null : () => Get.toNamed(AppRoutes.confirmPin),
      onNext: () async {
        if (controller.enteredPattern.length >= 4) {
          if (isVerify) {
            final ok = await controller.verifyPattern();
            if (ok) Get.offAllNamed(AppRoutes.home);
          } else {
            final ok = await controller.confirmPattern();
            if (ok) Get.offAllNamed(AppRoutes.home);
          }
        }
      },
    );
  }
}

class _PatternScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final PatternController controller;
  final bool showStepIndicator;
  final int stepIndex;
  final String? switchLabel;
  final VoidCallback? onSwitch;
  final VoidCallback onNext;

  const _PatternScaffold({
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: ThemedBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Diary Illustration
                      Center(
                        child: Image.asset(
                          'assets/images/screens/Group 162759.png',
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password / Pattern Toggle
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Get.offNamed(AppRoutes.setPin),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Password',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF2C3E50),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B9EFE),
                                    borderRadius: BorderRadius.circular(10),
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
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF7F8C8D),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 260,
                        child: Center(
                          child: Obx(() => _PatternGrid(
                                controller: controller,
                                isError: controller.isError.value,
                              )),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (controller.isError.value)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text('Pattern is incorrect',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    final isEnabled = controller.enteredPattern.length >= 4;
                    return ElevatedButton(
                      onPressed: isEnabled ? onNext : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B9EFE),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            const Color(0xFF3B9EFE).withValues(alpha: 0.3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatternGrid extends StatefulWidget {
  final PatternController controller;
  final bool isError;

  const _PatternGrid({required this.controller, required this.isError});

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
      onPanEnd: (_) => setState(() => _currentPosition = null),
      child: Container(
        width: 260,
        height: 260,
        color: Colors.transparent,
        child: CustomPaint(
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
              return Obx(() {
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
              });
            }),
          ),
        ),
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
