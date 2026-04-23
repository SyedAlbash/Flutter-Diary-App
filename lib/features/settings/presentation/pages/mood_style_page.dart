import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      'name': 'Normal Mood Pack',
      'emojis': ['😊', '😔', '😡', '😴', '🤔', '🥳'],
      'isIcon': false,
    },
    {
      'name': 'Animals Mood',
      'emojis': [
        'assets/emojis/Animals_Mood/1.webp',
        'assets/emojis/Animals_Mood/2.webp',
        'assets/emojis/Animals_Mood/3.webp',
        'assets/emojis/Animals_Mood/4.webp',
        'assets/emojis/Animals_Mood/5.webp',
        'assets/emojis/Animals_Mood/6.webp'
      ],
      'isIcon': false,
      'isImage': true,
    },
    {
      'name': 'Aqua Mood',
      'emojis': [
        'assets/emojis/Aqua_Mood/1.webp',
        'assets/emojis/Aqua_Mood/2.webp',
        'assets/emojis/Aqua_Mood/3.webp',
        'assets/emojis/Aqua_Mood/4.webp',
        'assets/emojis/Aqua_Mood/5.webp',
        'assets/emojis/Aqua_Mood/6.webp'
      ],
      'isIcon': false,
      'isImage': true,
    },
    {
      'name': 'Cat Mood',
      'emojis': [
        'assets/emojis/Cat_Mood/Icon.svg',
        'assets/emojis/Cat_Mood/Icon_1.svg',
        'assets/emojis/Cat_Mood/Icon_2.svg',
        'assets/emojis/Cat_Mood/Icon_3.svg',
        'assets/emojis/Cat_Mood/Icon_4.svg',
        'assets/emojis/Cat_Mood/Icon_5.svg'
      ],
      'isIcon': false,
      'isSvg': true,
    },
    {
      'name': 'Pet Mood',
      'emojis': [
        'assets/emojis/Pet_Mood/1.webp',
        'assets/emojis/Pet_Mood/2.webp',
        'assets/emojis/Pet_Mood/3.webp',
        'assets/emojis/Pet_Mood/5.webp',
        'assets/emojis/Pet_Mood/6.webp',
        'assets/emojis/Pet_Mood/6_1.webp'
      ],
      'isIcon': false,
      'isImage': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedMood = StorageUtil.getString('mood_style') ?? 'Normal Mood Pack';
  }

  Alignment _getAlignmentForIndex(int index) {
    switch (index) {
      case 0:
        return Alignment.topLeft;
      case 1:
        return Alignment.topCenter;
      case 2:
        return Alignment.topRight;
      case 3:
        return Alignment.centerLeft;
      case 4:
        return Alignment.center;
      case 5:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
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
                                final emojis = (pack['emojis'] as List?);
                                final icons = (pack['icons'] as List?);
                                final isIcon = pack['isIcon'] as bool? ?? false;
                                final isSvg = pack['isSvg'] as bool? ?? false;
                                final isImage =
                                    pack['isImage'] as bool? ?? false;
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
                                        ? (icons != null && index < icons.length
                                            ? Icon(
                                                icons[index],
                                                color: const Color(0xFF3B9EFE),
                                                size: 36,
                                              )
                                            : const SizedBox.shrink())
                                        : isSvg
                                            ? (emojis != null &&
                                                    index < emojis.length
                                                ? SvgPicture.asset(
                                                    emojis[index],
                                                    fit: BoxFit.contain,
                                                    clipBehavior: Clip.none,
                                                    placeholderBuilder:
                                                        (context) =>
                                                            const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color:
                                                            Color(0xFF3B9EFE),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink())
                                            : isImage
                                                ? (emojis != null &&
                                                        index < emojis.length
                                                    ? Container(
                                                        width: 50,
                                                        height: 50,
                                                        child: ClipRect(
                                                          child: OverflowBox(
                                                            maxWidth: 150,
                                                            maxHeight: 150,
                                                            alignment:
                                                                _getAlignmentForIndex(
                                                                    index),
                                                            child: Image.asset(
                                                              emojis[index],
                                                              width: 150,
                                                              height: 150,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink())
                                                : (emojis != null &&
                                                        index < emojis.length
                                                    ? Text(
                                                        emojis[index],
                                                        style: TextStyle(
                                                          fontSize: 32,
                                                          color: isAqua
                                                              ? const Color(
                                                                  0xFF3B9EFE)
                                                              : null,
                                                        ),
                                                      )
                                                    : const SizedBox.shrink()),
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
