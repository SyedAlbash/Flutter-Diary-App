import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Check onboarding status
    _checkStatus();
  }

  void _checkStatus() {
    final bool onboardingDone =
        StorageUtil.getBool(StorageUtil.keyOnboardingDone, defaultValue: false);

    if (onboardingDone) {
      // Returning user - auto navigate after delay
      _navigateAfterSplash();
    } else {
      // New user - show "Let's Start" button
      setState(() {
        _showOnboarding = true;
      });
    }
  }

  Future<void> _navigateAfterSplash() async {
    // Show splash for at least 2 seconds for a smooth transition
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final lockType = StorageUtil.getString(StorageUtil.keyLockType);

    if (lockType == 'pattern') {
      Get.offAllNamed('${AppRoutes.confirmPattern}/verify');
    } else if (lockType == 'pin') {
      Get.offAllNamed('${AppRoutes.confirmPin}/verify');
    } else {
      Get.offAllNamed(AppRoutes.home);
    }
  }

  void _onStartPressed() {
    StorageUtil.setBool(StorageUtil.keyOnboardingDone, true);
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F2FD), // New Light blue top
              Color(0xFFF9E8F5), // New Light pink bottom
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Central content - Using SingleChildScrollView to prevent overflow issues
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Center(
                      child: SingleChildScrollView(
                        child: RepaintBoundary(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Centered Splash Image (Diary with Lock)
                              FadeTransition(
                                opacity: _fadeAnim,
                                child: Image.asset(
                                  'assets/screens/Group 162759.webp',
                                  width: 150, // Smaller icon
                                  height: 150,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint(
                                        "Splash Image Load Error: $error");
                                    return Image.asset(
                                      'assets/screens/Splash Screen.webp',
                                      width: 150,
                                      height: 150,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Logo or App Name
                              FadeTransition(
                                opacity: _fadeAnim,
                                child: Text(
                                  AppStrings.appName,
                                  style: GoogleFonts.pacifico(
                                    fontSize: 28, // Smaller text
                                    color: const Color(0xFF1A1A1A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              FadeTransition(
                                opacity: _fadeAnim,
                                child: Text(
                                  AppStrings.appTagline,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13, // Smaller text
                                    color: Colors.black.withValues(alpha: 0.7),
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Loading indicator or Let's Start button
                  Positioned(
                    bottom: 60,
                    left: 40,
                    right: 40,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: _showOnboarding
                          ? _buildStartButton()
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2196F3),
                                strokeWidth: 3,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF64B5F6),
            Color(0xFF2196F3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onStartPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              AppStrings.letsStart,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
