import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/utils/email_util.dart';
import 'package:diary_with_lock/core/widgets/themed_background.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _starRating = 0;
  String _selectedType = 'General Feedback';
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  final List<String> _feedbackTypes = [
    'General Feedback',
    'Bug Report',
    'Suggestion',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Feedback',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: ThemedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Tell Us About Your\nExperience',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your thoughts help us shape a more\nmindful journey for everyone.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF7F8C8D),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                // Star rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () => setState(() => _starRating = i + 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          i < _starRating ? Icons.star : Icons.star,
                          color: i < _starRating
                              ? const Color(0xFFFFC107)
                              : const Color(0xFFFFC107).withValues(alpha: 0.2),
                          size: 44,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                // Feedback type selector
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: _feedbackTypes.map((type) {
                      final isSelected = _selectedType == type;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedType = type),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF3B9EFE)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF3B9EFE)
                                            .withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Text(
                              type.replaceAll(' Feedback', ''),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF7F8C8D),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 32),
                // Text field
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _feedbackController,
                          maxLines: null,
                          expands: true,
                          maxLength: 500,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF2C3E50),
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Tell us more about what you liked or what we can improve...',
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFFBDC3C7),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                            counterText: "",
                          ),
                          textAlignVertical: TextAlignVertical.top,
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 16),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'MAX 500 CHARACTERS',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFBDC3C7),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_starRating == 0) {
                        Get.snackbar(
                          'Rating Required',
                          'Please select a star rating',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                        );
                        return;
                      }
                      if (_feedbackController.text.trim().isEmpty) {
                        Get.snackbar(
                          'Feedback Required',
                          'Please tell us more about your experience',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                        );
                        return;
                      }

                      try {
                        await EmailUtil.sendFeedbackEmail(
                          rating: _starRating,
                          feedback: _feedbackController.text.trim(),
                          type: _selectedType,
                        );

                        Get.back();
                        Get.snackbar(
                          'Thank you!',
                          'Opening your email app to send feedback...',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.withValues(alpha: 0.1),
                          duration: const Duration(seconds: 3),
                        );
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Could not open email app. Please try again.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B9EFE),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Submit Feedback',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.send_rounded, size: 22),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
