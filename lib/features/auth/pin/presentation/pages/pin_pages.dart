import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/features/auth/pin/presentation/controllers/pin_controller.dart';
import 'package:diary_with_lock/core/widgets/themed_background.dart';

class SetPinPage extends StatelessWidget {
  const SetPinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PinController());
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
                                onTap: () {}, // Already on Password
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B9EFE),
                                    borderRadius: BorderRadius.circular(10),
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
                                onTap: () => Get.offNamed(AppRoutes.setPattern),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Pattern',
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Enter New Passcode!',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Pin dots
                      Obx(() => _PinDots(pin: controller.enteredPin.value)),
                      const SizedBox(height: 24),
                      // Numpad
                      _Numpad(
                        onDigit: (digit) {
                          controller.addDigit(digit);
                          if (controller.enteredPin.value.length == 4) {
                            controller.savePin();
                            Get.toNamed(AppRoutes.confirmPin);
                          }
                        },
                        onDelete: controller.removeDigit,
                        onClear: controller.clear,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // Next button
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    final isEnabled = controller.enteredPin.value.length == 4;
                    return ElevatedButton(
                      onPressed: isEnabled
                          ? () {
                              controller.savePin();
                              Get.toNamed(AppRoutes.confirmPin);
                            }
                          : null,
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
                        'Continue',
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

class ConfirmPinPage extends StatelessWidget {
  final bool isVerify;
  const ConfirmPinPage({super.key, this.isVerify = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PinController());
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
                      const SizedBox(height: 16),
                      Text(
                        isVerify ? 'Enter Passcode' : 'Confirm Passcode!',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isVerify
                            ? 'Welcome back! Please enter your PIN.'
                            : 'Let\'s double check that PIN.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF7F8C8D),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Pin dots
                      Obx(() => _PinDots(
                            pin: controller.enteredPin.value,
                            isError: controller.isError.value,
                          )),
                      if (controller.isError.value)
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text('PINs do not match',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      const SizedBox(height: 24),
                      // Numpad
                      _Numpad(
                        onDigit: (digit) async {
                          controller.addDigit(digit);
                          if (controller.enteredPin.value.length == 4) {
                            if (isVerify) {
                              final ok = await controller.verifyPin();
                              if (ok) Get.offAllNamed(AppRoutes.home);
                            } else {
                              final ok = await controller.confirmPin();
                              if (ok) Get.offAllNamed(AppRoutes.home);
                            }
                          }
                        },
                        onDelete: controller.removeDigit,
                        onClear: controller.clear,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // Finish/Verify button
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    final isEnabled = controller.enteredPin.value.length == 4;
                    return ElevatedButton(
                      onPressed: isEnabled
                          ? () async {
                              if (isVerify) {
                                final ok = await controller.verifyPin();
                                if (ok) Get.offAllNamed(AppRoutes.home);
                              } else {
                                final ok = await controller.confirmPin();
                                if (ok) Get.offAllNamed(AppRoutes.home);
                              }
                            }
                          : null,
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
                        isVerify ? 'Unlock' : 'Confirm',
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

class _PinDots extends StatelessWidget {
  final String pin;
  final bool isError;
  const _PinDots({required this.pin, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                i < pin.length ? const Color(0xFF3B9EFE) : Colors.transparent,
            border: Border.all(
              color: i < pin.length
                  ? const Color(0xFF3B9EFE)
                  : const Color(0xFF3B9EFE).withValues(alpha: 0.2),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _Numpad extends StatelessWidget {
  final Function(String) onDigit;
  final VoidCallback onDelete;
  final VoidCallback onClear;

  const _Numpad({
    required this.onDigit,
    required this.onDelete,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(['1', '2', '3']),
        const SizedBox(height: 12),
        _row(['4', '5', '6']),
        const SizedBox(height: 12),
        _row(['7', '8', '9']),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 72), // Left column empty
            const SizedBox(width: 16), // Padding between buttons
            _numBtn('0'),
            const SizedBox(width: 16), // Padding between buttons
            _actionBtn(onDelete),
          ],
        ),
      ],
    );
  }

  Widget _row(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _numBtn(digits[0]),
        const SizedBox(width: 16),
        _numBtn(digits[1]),
        const SizedBox(width: 16),
        _numBtn(digits[2]),
      ],
    );
  }

  Widget _numBtn(String digit) {
    return GestureDetector(
      onTap: () => onDigit(digit),
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            digit,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Color(0xFF3B9EFE),
            size: 24,
          ),
        ),
      ),
    );
  }
}
