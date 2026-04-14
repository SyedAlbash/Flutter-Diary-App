import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/theme/app_theme.dart';
import 'package:diary_with_lock/core/theme/theme_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:diary_with_lock/features/home/data/models/diary_entry.dart';
import 'package:diary_with_lock/features/home/presentation/controllers/home_controller.dart';
import 'drawing_page.dart';

class ComposePage extends StatefulWidget {
  final DiaryEntry? entry;
  const ComposePage({super.key, this.entry});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _imagePaths = [];
  String _selectedMood = '';
  DateTime _selectedDate = DateTime.now();
  List<String> _tags = [];
  int _selectedBgIndex = -1;
  String? _selectedBgImage;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;
      _imagePaths.addAll(widget.entry!.imagePaths);
      _selectedMood = widget.entry!.mood;
      _selectedDate = widget.entry!.date;
      _tags = List.from(widget.entry!.tags);
      if (widget.entry!.backgroundColor.isNotEmpty) {
        if (widget.entry!.backgroundColor.startsWith('assets/')) {
          _selectedBgImage = widget.entry!.backgroundColor;
        } else {
          final val = int.parse(widget.entry!.backgroundColor);
          _selectedBgIndex = _bgColors.indexWhere((c) => c.toARGB32() == val);
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  final List<String> _noteThemeAssets = [
    'assets/images/note themes/abstract-dark-background-with-some-smooth-lines-it-some-spots-it 1.png',
    'assets/images/note themes/digital-art-style-sky-landscape-with-moon.png',
    'assets/images/note themes/note theme 1.png',
    'assets/images/note themes/note theme 2.png',
    'assets/images/note themes/note theme 3.png',
    'assets/images/note themes/note theme 6.png',
    'assets/images/note themes/note theme 7.png',
    'assets/images/note themes/note theme 9.png',
  ];

  final List<Color> _bgColors = [
    const Color(0xFFF5F5DC), // Cream
    const Color(0xFF0D47A1), // Dark Blue
    const Color(0xFF1B5E20), // Dark Green
    const Color(0xFF4A148C), // Burgundy
    const Color(0xFF9575CD), // Lavender
    const Color(0xFFFFAB91), // Peach
    const Color(0xFF2196F3), // Medium Blue
    const Color(0xFF81D4FA), // Light Blue
    const Color(0xFFF8BBD0), // Light Pink
    const Color(0xFF37474F), // Dark Grey
  ];

  final List<String> _defaultTags = [
    'Love',
    'Family',
    'DailyLife',
    'Smile',
    'DailyLog',
    'Work',
    'Creative',
    'Sad',
    'Motivation',
    'Pet',
    'Health',
    'Fitness',
    'Parent',
    'Food',
    'Love',
    'Mode',
    'Happy',
    'Dream',
    'Gratitude',
    'Angry',
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => _imagePaths.add(file.path));
    }
  }

  Future<void> _pickDate() async {
    DateTime tempSelected = _selectedDate;
    DateTime focusedDay = _selectedDate;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B9EFE),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SELECT DATE',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.3,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  DateFormat('EEE, MMM d').format(tempSelected),
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.edit_calendar_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: TableCalendar(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: focusedDay,
                            selectedDayPredicate: (day) =>
                                isSameDay(tempSelected, day),
                            onDaySelected: (selectedDay, newFocused) {
                              setSheetState(() {
                                tempSelected = selectedDay;
                                focusedDay = newFocused;
                              });
                            },
                            headerStyle: HeaderStyle(
                              titleCentered: false,
                              formatButtonVisible: false,
                              titleTextFormatter: (date, locale) =>
                                  DateFormat('MMMM yyyy').format(date),
                              titleTextStyle: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A1A),
                              ),
                              leftChevronIcon: const Icon(
                                Icons.chevron_left_rounded,
                                color: Color(0xFF3B9EFE),
                              ),
                              rightChevronIcon: const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF3B9EFE),
                              ),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF95A5A6),
                              ),
                              weekendStyle: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF95A5A6),
                              ),
                            ),
                            calendarStyle: CalendarStyle(
                              outsideDaysVisible: false,
                              isTodayHighlighted: true,
                              selectedDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF3B9EFE),
                                  width: 2,
                                ),
                              ),
                              selectedTextStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3B9EFE),
                              ),
                              todayDecoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              todayTextStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3B9EFE),
                              ),
                              defaultTextStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                              weekendTextStyle: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF2C3E50),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7F8C8D),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() => _selectedDate = tempSelected);
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B9EFE),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'OK',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showMoodPicker() {
    final List<String> moods = ['😊', '😔', '😠', '😴', '🤔', '🥳'];
    showDialog(
      context: context,
      barrierColor: Colors.black12,
      builder: (_) => Stack(
        children: [
          Positioned(
            top: 155, // Approximate position below the mood icon
            right: 24,
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: CustomPaint(
                      size: const Size(20, 10),
                      painter: _TrianglePainter(color: Colors.white),
                    ),
                  ),
                  Container(
                    width: 250,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'How are you feeling?',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: moods.length,
                          itemBuilder: (ctx, i) {
                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedMood = moods[i]);
                                Get.back();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    moods[i],
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            // Handle see more
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('👉 ', style: TextStyle(fontSize: 14)),
                              Text(
                                'See more styles',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTagsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _TagsSheet(
        selectedTags: _tags,
        defaultTags: _defaultTags,
        onTagsChanged: (tags) {
          setState(() => _tags = tags);
        },
      ),
    );
  }

  void _showBackgroundPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GetBuilder<ThemeController>(
        builder: (tc) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      'Note Backgrounds',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: tc.currentTheme.textDark,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Get.back(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _noteThemeAssets.length + 1,
                  itemBuilder: (ctx, i) {
                    if (i == 0) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedBgImage = null;
                            _selectedBgIndex = -1;
                          });
                          Get.back();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(24),
                            border: _selectedBgImage == null &&
                                    _selectedBgIndex == -1
                                ? Border.all(
                                    color: tc.currentTheme.primary, width: 2.5)
                                : Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Icon(Icons.block_rounded,
                                    color: Colors.grey[400], size: 32),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Default',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    final asset = _noteThemeAssets[i - 1];
                    final isSelected = _selectedBgImage == asset;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedBgImage = asset;
                          _selectedBgIndex = -1;
                        });
                        Get.back();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: isSelected
                              ? Border.all(
                                  color: tc.currentTheme.primary, width: 3)
                              : Border.all(color: Colors.transparent),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(asset),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: isSelected
                            ? Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  margin: const EdgeInsets.all(12),
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.check_rounded,
                                      color: tc.currentTheme.primary, size: 20),
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Solid Colors Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'SOLID COLORS',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.withOpacity(0.6),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: _bgColors.length,
                  itemBuilder: (ctx, i) {
                    final isSelected = _selectedBgIndex == i;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedBgIndex = i;
                          _selectedBgImage = null;
                        });
                        Get.back();
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        margin: const EdgeInsets.only(right: 12, bottom: 12),
                        decoration: BoxDecoration(
                          color: _bgColors[i],
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: tc.currentTheme.primary, width: 3)
                              : Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: isSelected
                            ? const Icon(Icons.check_rounded,
                                color: Colors.white, size: 20)
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showDiscardDialog() {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      Get.back();
      return;
    }
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Not saved yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Would you like to keep it as a draft?',
                style: TextStyle(fontSize: 13, color: AppColors.textGrey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Discard',
                          style: TextStyle(color: AppColors.primary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _save();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Save Draft'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThreeDotMenu() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Preview', style: TextStyle(fontSize: 14)),
                onTap: () {
                  Get.back();
                  // Preview functionality
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Character:', style: TextStyle(fontSize: 14)),
                    Text('${_contentController.text.length}',
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                onTap: () {},
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Word:', style: TextStyle(fontSize: 14)),
                    Text(
                        '${_contentController.text.isEmpty ? 0 : _contentController.text.trim().split(RegExp(r'\s+')).length}',
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final controller = Get.find<HomeController>();
    final entry = DiaryEntry(
      id: widget.entry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: _contentController.text,
      date: _selectedDate,
      imagePaths: _imagePaths,
      mood: _selectedMood,
      tags: _tags,
      backgroundColor: _selectedBgImage ??
          (_selectedBgIndex >= 0
              ? _bgColors[_selectedBgIndex].toARGB32().toString()
              : ''),
    );
    if (widget.entry != null) {
      await controller.updateEntry(entry);
    } else {
      await controller.addEntry(entry);
    }
    Get.back();
  }

  Color get _getContentColor {
    // If we have a background image, determine if it's generally dark or light
    if (_selectedBgImage != null) {
      if (_selectedBgImage!.contains('dark') ||
          _selectedBgImage!.contains('sky') ||
          _selectedBgImage!.contains('night') ||
          _selectedBgImage!.contains('theme 1') ||
          _selectedBgImage!.contains('theme 3')) {
        return Colors.white;
      }
      // For images that are known to be light or are default, return solid black
      return Colors.black;
    }

    // If we have a solid color background, check its luminance
    if (_selectedBgIndex >= 0) {
      final color = _bgColors[_selectedBgIndex];
      // If the color is dark (low luminance), use white text
      // Otherwise use solid black text
      return color.computeLuminance() < 0.35 ? Colors.white : Colors.black;
    }

    // Default fallback: if no note theme is selected, use black text on the (presumably light) default background
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (tc) {
        final contentColor = _getContentColor;
        final isDarkBg = contentColor == Colors.white;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                isDarkBg ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDarkBg ? Brightness.dark : Brightness.light,
          ),
          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: _selectedBgImage != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(_selectedBgImage!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : _selectedBgIndex >= 0
                      ? BoxDecoration(color: _bgColors[_selectedBgIndex])
                      : BoxDecoration(
                          gradient: tc.currentTheme.backgroundImage != null
                              ? null
                              : LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: tc.currentTheme.gradientColors,
                                ),
                          image: tc.currentTheme.backgroundImage != null
                              ? DecorationImage(
                                  image: AssetImage(
                                      tc.currentTheme.backgroundImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // Top bar
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios_new,
                                    color: contentColor, size: 24),
                                onPressed: _showDiscardDialog,
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(Icons.more_horiz,
                                    color: contentColor, size: 28),
                                onPressed: _showThreeDotMenu,
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _save,
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B9EFE),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF3B9EFE)
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                // Date and mood row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: _pickDate,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            DateFormat('dd')
                                                .format(_selectedDate),
                                            style: GoogleFonts.poppins(
                                              fontSize: 32,
                                              fontWeight: FontWeight.w800,
                                              color: contentColor,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            DateFormat('MMM, yyyy')
                                                .format(_selectedDate),
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: contentColor,
                                            ),
                                          ),
                                          Icon(Icons.arrow_drop_down,
                                              color: contentColor, size: 24),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _showMoodPicker,
                                      child: CustomPaint(
                                        painter: _DashedCirclePainter(
                                            color:
                                                Colors.black.withOpacity(0.2)),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            _selectedMood.isEmpty
                                                ? '😊'
                                                : _selectedMood,
                                            style:
                                                const TextStyle(fontSize: 28),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Title field
                                TextField(
                                  controller: _titleController,
                                  style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: contentColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Title',
                                    hintStyle: GoogleFonts.poppins(
                                      color: contentColor.withOpacity(0.6),
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                                // Content field
                                TextField(
                                  controller: _contentController,
                                  maxLines: null,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: isDarkBg
                                        ? Colors.white.withOpacity(0.9)
                                        : Colors.grey[700],
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Start typing here...',
                                    hintStyle: GoogleFonts.poppins(
                                      color: contentColor.withOpacity(0.6),
                                      fontSize: 18,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Selected Images Preview
                                if (_imagePaths.isNotEmpty) ...[
                                  SizedBox(
                                    height: 100,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _imagePaths.length,
                                      itemBuilder: (ctx, i) {
                                        final path = _imagePaths[i];
                                        final isAsset =
                                            path.startsWith('assets/');
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(right: 12),
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                blurRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: isAsset
                                                    ? Image.asset(path,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover)
                                                    : Image.file(File(path),
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover),
                                              ),
                                              Positioned(
                                                top: 4,
                                                right: 4,
                                                child: GestureDetector(
                                                  onTap: () => setState(() =>
                                                      _imagePaths.removeAt(i)),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.black54,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 16),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                                const SizedBox(
                                    height: 100), // Space for toolbar
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Bottom Toolbar
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 24,
                      child: Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ToolbarIcon(
                              icon: Icons.texture_rounded,
                              color: const Color(0xFF3B9EFE),
                              onTap: _showBackgroundPicker,
                            ),
                            _ToolbarIcon(
                              icon: Icons.text_format_rounded,
                              color: const Color(0xFF3B9EFE),
                              onTap: () {}, // Font settings
                            ),
                            _ToolbarIcon(
                              icon: Icons.image_outlined,
                              color: const Color(0xFF3B9EFE),
                              onTap: _pickImage,
                            ),
                            _ToolbarIcon(
                              icon: Icons.sentiment_satisfied_alt_rounded,
                              color: const Color(0xFF3B9EFE),
                              onTap: _showMoodPicker,
                            ),
                            GestureDetector(
                              onTap: _showTagsSheet,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE3F2FD),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.local_offer_outlined,
                                    color: Color(0xFF3B9EFE), size: 28),
                              ),
                            ),
                            _ToolbarIcon(
                              icon: Icons.draw_rounded,
                              color: const Color(0xFF3B9EFE),
                              onTap: () => Get.to(() => const DrawingPage()),
                            ),
                            _ToolbarIcon(
                              icon: Icons.notifications_none_rounded,
                              color: const Color(0xFF3B9EFE),
                              onTap: () {}, // Notifications
                            ),
                          ],
                        ),
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

class _ToolbarIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ToolbarIcon(
      {super.key,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}

class _TagsSheet extends StatefulWidget {
  final List<String> selectedTags;
  final List<String> defaultTags;
  final Function(List<String>) onTagsChanged;

  const _TagsSheet({
    required this.selectedTags,
    required this.defaultTags,
    required this.onTagsChanged,
  });

  @override
  State<_TagsSheet> createState() => _TagsSheetState();
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dashWidth = 4;
    const double dashSpace = 3;
    final double radius = size.width / 2;
    final double circumference = 2 * 3.1415926535 * radius;
    final int dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = (i * (dashWidth + dashSpace)) / radius;
      final double endAngle = startAngle + (dashWidth / radius);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        endAngle - startAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TagsSheetState extends State<_TagsSheet> {
  late List<String> _selected;
  final TextEditingController _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedTags);
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_selected.contains(tag)) {
      setState(() => _selected.add(tag));
      _tagController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Text('Tags',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    widget.onTagsChanged(_selected);
                    Get.back();
                  },
                  child: Icon(Icons.check_circle,
                      color: AppColors.primary, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Add tag input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      hintText: 'Enter Tag Name',
                      hintStyle:
                          TextStyle(color: AppColors.textGrey, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFFF5F8FC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTag,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Tags grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.defaultTags.map((tag) {
                final isSelected = _selected.contains(tag);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selected.remove(tag);
                      } else {
                        _selected.add(tag);
                      }
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : const Color(0xFFF5F8FC),
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: AppColors.primary)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '# $tag',
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.close, size: 14, color: AppColors.primary),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
