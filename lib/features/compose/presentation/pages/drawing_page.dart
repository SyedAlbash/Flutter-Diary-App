import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diary_with_lock/core/theme/app_theme.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final List<DrawingPoint?> _points = [];
  final List<DrawingPoint?> _undone = [];
  Color _selectedColor = AppColors.primary;
  double _strokeWidth = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F2FD),
              Color(0xFFF9E8F5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black87,
                        size: 22,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() {
                        _points.clear();
                        _undone.clear();
                      }),
                      icon: const Icon(
                        Icons.layers_clear_rounded,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _undo,
                      icon: const Icon(
                        Icons.undo_rounded,
                        color: Colors.black54,
                      ),
                    ),
                    IconButton(
                      onPressed: _redo,
                      icon: const Icon(
                        Icons.redo_rounded,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _onDone,
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B9EFE),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFF3B9EFE).withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Draw a sticker',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.86,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF3B9EFE),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onPanStart: (details) {
                          final localPosition = details.localPosition;
                          setState(() {
                            _undone.clear();
                            _points.add(DrawingPoint(
                              point: localPosition,
                              paint: Paint()
                                ..color = _selectedColor
                                ..strokeWidth = _strokeWidth
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true,
                            ));
                          });
                        },
                        onPanUpdate: (details) {
                          final localPosition = details.localPosition;
                          setState(() {
                            _points.add(DrawingPoint(
                              point: localPosition,
                              paint: Paint()
                                ..color = _selectedColor
                                ..strokeWidth = _strokeWidth
                                ..strokeCap = StrokeCap.round
                                ..isAntiAlias = true,
                            ));
                          });
                        },
                        onPanEnd: (details) {
                          setState(() => _points.add(null));
                        },
                        child: CustomPaint(
                          painter: DrawerPainter(points: _points),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _colorBtn(const Color(0xFFFF5252)),
                        _colorBtn(const Color(0xFFFF8A80)),
                        _colorBtn(const Color(0xFFFFC1A3)),
                        _colorBtn(const Color(0xFF69F0AE)),
                        _colorBtn(const Color(0xFF26C6DA)),
                        _colorBtn(const Color(0xFF8D6E63)),
                        _colorBtn(const Color(0xFF2979FF)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorBtn(Color color) {
    final selected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
          ],
        ),
      ),
    );
  }

  void _undo() {
    if (_points.isEmpty) return;
    setState(() {
      while (_points.isNotEmpty) {
        final p = _points.removeLast();
        _undone.insert(0, p);
        if (p == null) break;
      }
    });
  }

  void _redo() {
    if (_undone.isEmpty) return;
    setState(() {
      while (_undone.isNotEmpty) {
        final p = _undone.removeAt(0);
        _points.add(p);
        if (p == null) break;
      }
    });
  }

  void _onDone() {
    Get.back();
    Get.snackbar(
      'Drawing Saved!',
      'Your drawing has been added.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
    );
  }
}

class DrawingPoint {
  final Offset point;
  final Paint paint;
  DrawingPoint({required this.point, required this.paint});
}

class DrawerPainter extends CustomPainter {
  final List<DrawingPoint?> points;
  DrawerPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!.point, points[i + 1]!.point, points[i]!.paint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [points[i]!.point], points[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
