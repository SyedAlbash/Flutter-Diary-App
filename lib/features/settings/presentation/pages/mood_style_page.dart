import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';
import 'package:diary_with_lock/core/widgets/themed_background.dart';

class MoodStylePage extends StatefulWidget {
  const MoodStylePage({super.key});

  @override
  State<MoodStylePage> createState() => _MoodStylePageState();
}

class _MoodStylePageState extends State<MoodStylePage> {
  String _selectedMood = 'Mood - Cat';

  final List<Map<String, dynamic>> _moodPacks = [
    {
      'name': 'Mood - Cat',
      'icons': [
        Icons.pets_rounded,
        Icons.sentiment_satisfied_alt_rounded,
        Icons.sentiment_very_satisfied_rounded,
        Icons.sentiment_neutral_rounded,
        Icons.sentiment_dissatisfied_rounded,
        Icons.local_florist_rounded,
      ],
      'isIcon': true,
    },
    {
      'name': 'Normal Mood Pack',
      'emojis': ['😊', '😔', '😡', '😴', '🤔', '🥳'],
      'isIcon': false,
    },
    {
      'name': 'Animals Mood',
      'emojis': ['🐰', '🐷', '🐨', '🐱', '🐶', '🐹'],
      'isIcon': false,
    },
    {
      'name': 'Aqua Mood',
      'emojis': [
        '😍',
        '😊',
        '😎',
        '😂',
        '😐',
        '🥹'
      ], // Using emojis that look like the blue bubbles if possible
      'isIcon': false,
      'isAqua': true, // Custom flag to apply blue styling if needed
    },
    {
      'name': 'Cute Pet Mood',
      'emojis': ['🐱', '😸', '😹', '😻', '😼', '😽'],
      'isIcon': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedMood = StorageUtil.getString('mood_style') ?? 'Mood - Cat';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Mood style',
          style: GoogleFonts.poppins(
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
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Choose an emoji pack that reflects your daily',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF7F8C8D),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _moodPacks.length,
                  itemBuilder: (ctx, i) {
                    final pack = _moodPacks[i];
                    final isSelected = _selectedMood == pack['name'];
                    return GestureDetector(
                      onTap: () async {
                        setState(() => _selectedMood = pack['name']);
                        await StorageUtil.setString('mood_style', pack['name']);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  pack['name'],
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: const Color(0xFF1A1A1A),
                                  ),
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? const Color(0xFF3B9EFE)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF3B9EFE)
                                          : const Color(0xFFBDC3C7),
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // 3x2 Grid
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 1,
                              ),
                              itemCount: 6,
                              itemBuilder: (ctx, index) {
                                final isIcon = pack['isIcon'] as bool;
                                final isAqua = pack['isAqua'] == true;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: isAqua
                                        ? const Color(0xFFE3F2FD)
                                        : const Color(0xFFF5F6F7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: isIcon
                                        ? Icon(
                                            (pack['icons'] as List)[index],
                                            color: const Color(0xFF3B9EFE),
                                            size: 36,
                                          )
                                        : Text(
                                            (pack['emojis'] as List)[index],
                                            style: TextStyle(
                                              fontSize: 32,
                                              color: isAqua
                                                  ? const Color(0xFF3B9EFE)
                                                  : null,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
