import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/core/theme/app_theme.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';
import 'package:diary_with_lock/core/widgets/themed_background.dart';
import 'package:diary_with_lock/core/theme/theme_controller.dart';

class YourNamePage extends StatefulWidget {
  const YourNamePage({super.key});

  @override
  State<YourNamePage> createState() => _YourNamePageState();
}

class _YourNamePageState extends State<YourNamePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar('Oops!', 'Please enter your name',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      return;
    }
    // Dismiss keyboard before navigation to prevent overflow on next screen
    FocusScope.of(context).unfocus();

    StorageUtil.setString(StorageUtil.keyUserName, _nameController.text.trim());
    StorageUtil.setBool(StorageUtil.keyOnboardingDone, true);
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      body: ThemedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Progress dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(true),
                    _dot(false),
                    _dot(false),
                  ],
                ),
                const SizedBox(height: 60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What should we\ncall you?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your name will be shown on the home screen.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: GetBuilder<ThemeController>(builder: (tc) {
                        final Color cardColor = tc.currentTheme.cardBg;
                        final bool isLightBg =
                            cardColor.computeLuminance() > 0.5;
                        final Color inputTextColor =
                            isLightBg ? Colors.black : Colors.white;
                        final Color inputHintColor =
                            isLightBg ? Colors.black54 : Colors.white60;

                        return TextField(
                          controller: _nameController,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: inputTextColor,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your name...',
                            hintStyle: TextStyle(color: inputHintColor),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                // Next button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Get Started',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded,
                              size: 20, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
