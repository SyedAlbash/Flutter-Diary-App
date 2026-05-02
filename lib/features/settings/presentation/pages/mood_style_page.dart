import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diary_with_lock/core/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';
import 'package:diary_with_lock/core/widgets/themed_background.dart';

class MoodStylePage extends StatefulWidget {
  final bool isSelectionMode;
  const MoodStylePage({super.key, this.isSelectionMode = false});

  @override
  State<MoodStylePage> createState() => _MoodStylePageState();
}

class _MoodStylePageState extends State<MoodStylePage> {
  String _selectedMood = 'Normal Mood Pack';
  bool _isSelectionMode = false;

  final List<Map<String, dynamic>> _moodPacks = [
    {
      'name': 'Normal Mood Pack',
      'emojis': ['😊', '😔', '😡', '😴', '🤔', '🥳'],
    },
    {
      'name': 'Animals Mood',
      'isPng': true,
      'emojis': [
        'assets/emojis/Animals_Mood/1.png',
        'assets/emojis/Animals_Mood/3.png',
        'assets/emojis/Animals_Mood/4.png',
        'assets/emojis/Animals_Mood/5.png',
        'assets/emojis/Animals_Mood/6.png',
        'assets/emojis/Animals_Mood/6.png',
      ],
    },
    {
      'name': 'Aqua Mood',
      'isPng': true,
      'emojis': [
        'assets/emojis/Aqua_Mood/1.png',
        'assets/emojis/Aqua_Mood/2.png',
        'assets/emojis/Aqua_Mood/3.png',
        'assets/emojis/Aqua_Mood/4.png',
        'assets/emojis/Aqua_Mood/5.png',
        'assets/emojis/Aqua_Mood/6.png',
      ],
    },
    {
      'name': 'Cat Mood',
      'isSvg': true,
      'emojis': [
        'assets/emojis/Cat_Mood/Icon.svg',
        'assets/emojis/Cat_Mood/Icon (1).svg',
        'assets/emojis/Cat_Mood/Icon (2).svg',
        'assets/emojis/Cat_Mood/Icon (3).svg',
        'assets/emojis/Cat_Mood/Icon (4).svg',
        'assets/emojis/Cat_Mood/Icon (5).svg',
      ],
    },
    {
      'name': 'Pet Mood',
      'isPng': true,
      'emojis': [
        'assets/emojis/Pet_Mood/1.png',
        'assets/emojis/Pet_Mood/2.png',
        'assets/emojis/Pet_Mood/3.png',
        'assets/emojis/Pet_Mood/5.png',
        'assets/emojis/Pet_Mood/6.png',
        'assets/emojis/Pet_Mood/6.png',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _isSelectionMode = widget.isSelectionMode || (Get.arguments?['isSelectionMode'] ?? false);
    _selectedMood = StorageUtil.getString('mood_style') ?? 'Normal Mood Pack';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          _isSelectionMode ? 'Select Mood' : 'Mood style',
          style: AppTextStyles.poppins(
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
                  _isSelectionMode 
                    ? 'Pick an emoji that fits your mood today'
                    : 'Choose an emoji pack that reflects your daily',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.poppins(
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
                        setState(() => _selectedMood = pack['name'] as String);
                        await StorageUtil.setString(
                            'mood_style', pack['name'] as String);
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
                                  pack['name'] as String,
                                  style: AppTextStyles.poppins(
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
                                final emojis = pack['emojis'] as List<dynamic>?;
                                final isSvg = pack['isSvg'] == true;
                                final isPng = pack['isPng'] == true;

                                Widget emojiWidget = const SizedBox.shrink();
                                if (emojis != null && index < emojis.length) {
                                  final path = emojis[index] as String;
                                  if (isSvg) {
                                    emojiWidget = SvgPicture.asset(
                                      path,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.contain,
                                    );
                                  } else if (isPng) {
                                    emojiWidget = Image.asset(
                                      path,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.contain,
                                    );
                                  } else {
                                    emojiWidget = Text(
                                      path,
                                      style: const TextStyle(fontSize: 32),
                                    );
                                  }
                                }

                                return GestureDetector(
                                  onTap: () async {
                                    if (_isSelectionMode) {
                                      final emojis = pack['emojis'] as List<dynamic>?;
                                      if (emojis != null && index < emojis.length) {
                                        final path = emojis[index] as String;
                                        // Save the pack selection first
                                        await StorageUtil.setString('mood_style', pack['name'] as String);
                                        // Return the specific emoji
                                        Get.back(result: path);
                                      }
                                    } else {
                                      // If not in selection mode, tapping an emoji just selects the pack
                                      setState(() => _selectedMood = pack['name'] as String);
                                      await StorageUtil.setString('mood_style', pack['name'] as String);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F6F7),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Center(child: emojiWidget),
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
