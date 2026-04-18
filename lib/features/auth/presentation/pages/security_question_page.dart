import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';
import 'package:diary_with_lock/core/widgets/themed_background.dart';

class SecurityQuestionPage extends StatefulWidget {
  final bool isRecovery;
  const SecurityQuestionPage({super.key, this.isRecovery = false});

  @override
  State<SecurityQuestionPage> createState() => _SecurityQuestionPageState();
}

class _SecurityQuestionPageState extends State<SecurityQuestionPage> {
  final List<String> _questions = [
    'What is your pet\'s name?',
    'What is your mother\'s maiden name?',
    'What was the name of your first school?',
    'In what city were you born?',
    'What is your favorite color?',
  ];

  String? _selectedQuestion;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isRecovery) {
      _selectedQuestion =
          StorageUtil.getString(StorageUtil.keySecurityQuestion);
    } else {
      _selectedQuestion = _questions[0];
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final answer = _answerController.text.trim().toLowerCase();
    if (answer.isEmpty) {
      Get.snackbar(
        'Error',
        'Please provide an answer',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
      );
      return;
    }

    if (widget.isRecovery) {
      final savedAnswer = StorageUtil.getString(StorageUtil.keySecurityAnswer);
      if (answer == savedAnswer?.toLowerCase()) {
        // Successful recovery
        _clearAllLocks();
        Get.offAllNamed(AppRoutes.home);
        Get.snackbar(
          'Success',
          'Lock removed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
        );
      } else {
        Get.snackbar(
          'Incorrect Answer',
          'The answer provided is incorrect',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
        );
      }
    } else {
      // Setup mode
      StorageUtil.setString(
          StorageUtil.keySecurityQuestion, _selectedQuestion!);
      StorageUtil.setString(StorageUtil.keySecurityAnswer, answer);
      Get.offAllNamed(AppRoutes.home);
      Get.snackbar(
        'Security Setup',
        'Security question saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
      );
    }
  }

  void _clearAllLocks() {
    StorageUtil.remove(StorageUtil.keyPin);
    StorageUtil.remove(StorageUtil.keyPattern);
    StorageUtil.remove(StorageUtil.keyLockType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ThemedBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        Center(
                          child: Image.asset(
                            'assets/images/screens/Group 162759.png',
                            height: 120,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          widget.isRecovery
                              ? 'Security Recovery'
                              : 'Security Question',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1C1E),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.isRecovery
                              ? 'Please answer your security question to reset your lock'
                              : 'This will help you recover your diary if you forget your lock',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF7F8C8D),
                          ),
                        ),
                        const SizedBox(height: 40),
                        if (widget.isRecovery)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: const Color(0xFFE3F2FD)),
                            ),
                            child: Text(
                              _selectedQuestion ?? 'No question set',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1C1E),
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: const Color(0xFFE3F2FD)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedQuestion,
                                isExpanded: true,
                                items: _questions.map((q) {
                                  return DropdownMenuItem(
                                    value: q,
                                    child: Text(q,
                                        style:
                                            GoogleFonts.poppins(fontSize: 14)),
                                  );
                                }).toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedQuestion = val),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE3F2FD)),
                          ),
                          child: TextField(
                            controller: _answerController,
                            style: GoogleFonts.poppins(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Your answer...',
                              hintStyle: GoogleFonts.poppins(
                                color: const Color(0xFFBDC3C7),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: _onContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B9EFE),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            widget.isRecovery
                                ? 'Verify & Remove Lock'
                                : 'Save & Continue',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
