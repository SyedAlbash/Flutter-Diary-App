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
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Check onboarding status immediately since services are now pre-initialized in main.dart
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    // Show splash for at least 2 seconds for a smooth transition
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final onboardingDone = StorageUtil.getBool(StorageUtil.keyOnboardingDone);

    if (onboardingDone) {
      final lockType = StorageUtil.getString(StorageUtil.keyLockType);
      if (lockType == 'pattern') {
        Get.offAllNamed('${AppRoutes.confirmPattern}/verify');
      } else if (lockType == 'pin') {
        Get.offAllNamed('${AppRoutes.confirmPin}/verify');
      } else {
        // No lock set, navigate directly to home
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
      setState(() => _ready = true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onStart() {
    Get.offAllNamed(AppRoutes.yourName);
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
                                  'assets/images/screens/Group 162759.png',
                                  width: 220,
                                  height: 220,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint(
                                        "Splash Image Load Error: $error");
                                    return Image.asset(
                                      'assets/images/screens/Splash Screen.png',
                                      width: 220,
                                      height: 220,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Logo or App Name
                              FadeTransition(
                                opacity: _fadeAnim,
                                child: Text(
                                  AppStrings.appName,
                                  style: GoogleFonts.pacifico(
                                    fontSize: 36,
                                    color: const Color(0xFF1A1A1A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              FadeTransition(
                                opacity: _fadeAnim,
                                child: Text(
                                  AppStrings.appTagline,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black.withOpacity(0.7),
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

                  // Bottom button
                  if (_ready)
                    Positioned(
                      left: 40,
                      right: 40,
                      bottom: 60,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: Container(
                          height: 60,
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
                                color: const Color(0xFF2196F3).withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _onStart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              AppStrings.letsStart,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Loading indicator
                  if (!_ready)
                    const Positioned(
                      bottom: 80,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2196F3),
                          strokeWidth: 3,
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
}
