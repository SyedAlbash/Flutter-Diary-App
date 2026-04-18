import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/core/theme/theme_controller.dart';
import 'package:diary_with_lock/features/auth/pin/presentation/controllers/pin_controller.dart';
import 'package:diary_with_lock/core/widgets/themed_background.dart';

class SetPinPage extends StatefulWidget {
  const SetPinPage({super.key});

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  final controller = Get.find<PinController>();

  @override
  void initState() {
    super.initState();
    controller.clear();
  }

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
              onTap: () => controller.clear(),
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
                            GestureDetector(
                              onTap:
                                  () {}, // Prevent clearing when tapping toggle
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white10 : Colors.white,
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
                                        onTap: () {}, // Already on Password
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF3B9EFE),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Password',
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
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            Get.offNamed(AppRoutes.setPattern),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Pattern',
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
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Enter New Passcode!',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Pin dots
                            Obx(() =>
                                _PinDots(pin: controller.enteredPin.value)),
                            const SizedBox(height: 16),
                            // Numpad
                            GestureDetector(
                              onTap:
                                  () {}, // Prevent clearing when tapping numpad
                              child: _Numpad(
                                isDark: isDark,
                                onDigit: (digit) {
                                  controller.addDigit(digit);
                                  // No auto-proceed during setup, user must click 'Continue' button
                                },
                                onDelete: controller.removeDigit,
                                onClear: controller.clear,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: Obx(() {
                          final isEnabled =
                              controller.enteredPin.value.length == 4;
                          return GestureDetector(
                            onTap:
                                () {}, // Prevent clearing when tapping button
                            child: ElevatedButton(
                              onPressed: isEnabled
                                  ? () {
                                      controller.savePin();
                                      Get.toNamed(AppRoutes.confirmPin);
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3B9EFE),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: const Color(0xFF3B9EFE)
                                    .withValues(alpha: 0.3),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text(
                                'Continue',
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

class ConfirmPinPage extends StatefulWidget {
  final bool isVerify;
  const ConfirmPinPage({super.key, this.isVerify = false});

  @override
  State<ConfirmPinPage> createState() => _ConfirmPinPageState();
}

class _ConfirmPinPageState extends State<ConfirmPinPage> {
  final controller = Get.find<PinController>();

  @override
  void initState() {
    super.initState();
    controller.clear();
  }

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
              onTap: () => controller.clear(),
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
                            Text(
                              widget.isVerify
                                  ? 'Enter Passcode'
                                  : 'Confirm Passcode!',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.isVerify
                                  ? 'Welcome back! Please enter your PIN.'
                                  : 'Let\'s double check that PIN.',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: subTextColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Pin dots
                            Obx(() => _PinDots(
                                  pin: controller.enteredPin.value,
                                  isError: controller.isError.value,
                                )),
                            if (controller.isError.value)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                    widget.isVerify
                                        ? 'Incorrect PIN'
                                        : 'PINs do not match',
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12)),
                              ),
                            const SizedBox(height: 16),
                            // Numpad
                            GestureDetector(
                              onTap:
                                  () {}, // Prevent clearing when tapping numpad
                              child: _Numpad(
                                isDark: isDark,
                                onDigit: (digit) async {
                                  controller.addDigit(digit);
                                  if (controller.enteredPin.value.length == 4) {
                                    // Only auto-unlock when verifying (lock is active)
                                    if (widget.isVerify) {
                                      final ok = await controller.verifyPin();
                                      if (ok) Get.offAllNamed(AppRoutes.home);
                                    }
                                    // During confirmation/setup flow, user must click 'Confirm' button
                                  }
                                },
                                onDelete: controller.removeDigit,
                                onClear: controller.clear,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (widget.isVerify)
                              GestureDetector(
                                onTap:
                                    () {}, // Prevent clearing when tapping button
                                child: TextButton(
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
                                    'Forgot Password',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF3B9EFE),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    if (!widget.isVerify)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: Obx(() {
                            final isEnabled =
                                controller.enteredPin.value.length == 4;
                            return GestureDetector(
                              onTap:
                                  () {}, // Prevent clearing when tapping button
                              child: ElevatedButton(
                                onPressed: isEnabled
                                    ? () async {
                                        if (widget.isVerify) {
                                          final ok =
                                              await controller.verifyPin();
                                          if (ok)
                                            Get.offAllNamed(AppRoutes.home);
                                        } else {
                                          final ok =
                                              await controller.confirmPin();
                                          if (ok) {
                                            Get.offAllNamed(
                                                AppRoutes.securityQuestion);
                                          }
                                        }
                                      }
                                    : null,
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
                                  widget.isVerify ? 'Unlock' : 'Confirm',
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

class _PinDots extends StatelessWidget {
  final String pin;
  final bool isError;
  const _PinDots({required this.pin, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isActive = index < pin.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? (isError ? Colors.red : const Color(0xFF3B9EFE))
                : Colors.transparent,
            border: Border.all(
              color: isActive
                  ? (isError ? Colors.red : const Color(0xFF3B9EFE))
                  : const Color(0xFFE3F2FD),
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}

class _Numpad extends StatelessWidget {
  final Function(String) onDigit;
  final VoidCallback onDelete;
  final VoidCallback onClear;
  final bool isDark;

  const _Numpad({
    required this.onDigit,
    required this.onDelete,
    required this.onClear,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          if (index == 9) {
            return const SizedBox(); // Empty space
          }
          if (index == 10) {
            return _buildDigit('0');
          }
          if (index == 11) {
            return _buildDelete();
          }
          return _buildDigit('${index + 1}');
        },
      ),
    );
  }

  Widget _buildDigit(String digit) {
    return GestureDetector(
      onTap: () => onDigit(digit),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white12 : Colors.white,
          shape: BoxShape.circle,
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            digit,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDelete() {
    return GestureDetector(
      onTap: onDelete,
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            color: isDark ? Colors.white70 : const Color(0xFF3B9EFE),
            size: 28,
          ),
        ),
      ),
    );
  }
}
