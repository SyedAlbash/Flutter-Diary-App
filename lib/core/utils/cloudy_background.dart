import 'package:flutter/material.dart';
import 'package:diary_with_lock/core/theme/app_theme.dart';

class CloudyBackground extends StatelessWidget {
  final Widget child;
  const CloudyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFB8D4F0),
            Color(0xFFD4E8F8),
            Color(0xFFF5D0E0),
            Color(0xFFF8C8D8),
          ],
          stops: [0.0, 0.4, 0.75, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Cloud decorations
          Positioned(top: 40, left: -20, child: _cloud(120, 60)),
          Positioned(top: 80, right: -10, child: _cloud(100, 50)),
          Positioned(top: 150, left: 50, child: _cloud(80, 40)),
          Positioned(bottom: 200, right: 20, child: _cloud(90, 45)),
          Positioned(bottom: 150, left: -10, child: _cloud(110, 55)),
          child,
        ],
      ),
    );
  }

  Widget _cloud(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int total;
  final int current;
  const StepIndicator({super.key, required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        total,
        (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == current ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == current
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
