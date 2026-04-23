import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/core/theme/theme_controller.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';
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
  String _selectedMoodStyle = 'Normal Mood Pack'; // Default to match image
  DateTime _selectedDate = DateTime.now();
  List<String> _tags = [];
  int _selectedBgIndex = -1;
  String? _selectedBgImage;

  // Font settings states
  TextAlign _textAlign = TextAlign.left;
  double _fontSize = 16;
  Color _textColor = Colors.black;
  String _fontFamily = 'Poppins';

  final List<String> _defaultTags = const [
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
  ];

  List<String> _allTags = [];

  void _loadTags() {
    final customTagsString = StorageUtil.getString(StorageUtil.keyCustomTags);
    if (customTagsString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(customTagsString);
        final List<String> customTags =
            decoded.map((e) => e.toString()).toList();
        setState(() {
          _allTags = {..._defaultTags, ...customTags}.toList();
        });
      } catch (e) {
        debugPrint('Error loading custom tags: $e');
        setState(() {
          _allTags = List.from(_defaultTags);
        });
      }
    } else {
      setState(() {
        _allTags = List.from(_defaultTags);
      });
    }
  }

  void _saveNewTag(String tag) {
    final customTagsString = StorageUtil.getString(StorageUtil.keyCustomTags);
    List<String> customTags = [];
    if (customTagsString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(customTagsString);
        customTags = decoded.map((e) => e.toString()).toList();
      } catch (e) {
        debugPrint('Error parsing custom tags for saving: $e');
      }
    }

    if (!customTags.contains(tag) && !_defaultTags.contains(tag)) {
      customTags.add(tag);
      StorageUtil.setString(StorageUtil.keyCustomTags, jsonEncode(customTags));
      _loadTags(); // Refresh local list
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTags();
    _selectedMoodStyle =
        StorageUtil.getString('mood_style') ?? 'Normal Mood Pack';
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
    'assets/note_themes/abstract_dark.webp',
    'assets/note_themes/digital_art_sky.webp',
    'assets/note_themes/note_theme_1.webp',
    'assets/note_themes/note_theme_2.webp',
    'assets/note_themes/note_theme_3.webp',
    'assets/note_themes/note_theme_6.webp',
    'assets/note_themes/note_theme_7.webp',
    'assets/note_themes/note_theme_9.webp',
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

    await showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B9EFE),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
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
                                    color: Colors.white.withValues(alpha: 0.8),
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
                              color: Colors.white.withValues(alpha: 0.15),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: focusedDay,
                        rowHeight: 42,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
              );
            },
          ),
        );
      },
    );
  }

  void _showFontSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Font',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle,
                          color: Color(0xFF2ECC71), size: 32),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Style & Layout
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader('STYLE & LAYOUT'),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F8FC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _alignmentButton(
                                    TextAlign.left, Icons.format_align_left,
                                    (val) {
                                  setState(() => _textAlign = val);
                                  setSheetState(() {});
                                }),
                                _alignmentButton(
                                    TextAlign.center, Icons.format_align_center,
                                    (val) {
                                  setState(() => _textAlign = val);
                                  setSheetState(() {});
                                }),
                                _alignmentButton(
                                    TextAlign.right, Icons.format_align_right,
                                    (val) {
                                  setState(() => _textAlign = val);
                                  setSheetState(() {});
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader('HEADINGS'),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _headingButton('H1', 24, (val) {
                                  setState(() => _fontSize = val);
                                  setSheetState(() {});
                                }),
                                const SizedBox(width: 8),
                                _headingButton('H2', 20, (val) {
                                  setState(() => _fontSize = val);
                                  setSheetState(() {});
                                }),
                                const SizedBox(width: 8),
                                _headingButton('H3', 16, (val) {
                                  setState(() => _fontSize = val);
                                  setSheetState(() {});
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                _sectionHeader('TEXT COLOR'),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _colorOption(Colors.black, (val) {
                        setState(() => _textColor = val);
                        setSheetState(() {});
                      }),
                      _colorOption(const Color(0xFF95A5A6), (val) {
                        setState(() => _textColor = val);
                        setSheetState(() {});
                      }),
                      _colorOption(const Color(0xFFFF5E5E), (val) {
                        setState(() => _textColor = val);
                        setSheetState(() {});
                      }),
                      _colorOption(const Color(0xFF00A86B), (val) {
                        setState(() => _textColor = val);
                        setSheetState(() {});
                      }),
                      _colorOption(const Color(0xFF8E44AD), (val) {
                        setState(() => _textColor = val);
                        setSheetState(() {});
                      }),
                      _colorOption(const Color(0xFFF1C40F), (val) {
                        setState(() => _textColor = val);
                        setSheetState(() {});
                      }),
                      _colorOption(const Color(0xFF5E5EFF), (val) {
                        setState(() => _textColor = val);
                        setSheetState(() {});
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                _sectionHeader('FONT FAMILY'),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _fontFamilyOption('Modern\nSans', 'Poppins', (val) {
                        setState(() => _fontFamily = val);
                        setSheetState(() {});
                      }),
                      const SizedBox(width: 12),
                      _fontFamilyOption('Editorial\nSerif', 'Playfair Display',
                          (val) {
                        setState(() => _fontFamily = val);
                        setSheetState(() {});
                      }, hasBadge: true),
                      const SizedBox(width: 12),
                      _fontFamilyOption('Handwritten', 'Dancing Script', (val) {
                        setState(() => _fontFamily = val);
                        setSheetState(() {});
                      }, hasBadge: true),
                      const SizedBox(width: 12),
                      _fontFamilyOption('Classic\nSerif', 'Merriweather',
                          (val) {
                        setState(() => _fontFamily = val);
                        setSheetState(() {});
                      }),
                      const SizedBox(width: 12),
                      _fontFamilyOption('Casual\nScript', 'Caveat', (val) {
                        setState(() => _fontFamily = val);
                        setSheetState(() {});
                      }),
                      const SizedBox(width: 12),
                      _fontFamilyOption('Fun\nScript', 'Pacifico', (val) {
                        setState(() => _fontFamily = val);
                        setSheetState(() {});
                      }),
                      const SizedBox(width: 12),
                      _fontFamilyOption('Clean\nSans', 'Roboto', (val) {
                        setState(() => _fontFamily = val);
                        setSheetState(() {});
                      }),
                      const SizedBox(width: 12),
                      _fontFamilyOption('Elegant\nSans', 'Montserrat', (val) {
                        setState(() => _fontFamily = val);
                        setSheetState(() {});
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFBDC3C7),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _alignmentButton(
      TextAlign align, IconData icon, Function(TextAlign) onTap) {
    final isSelected = _textAlign == align;
    return GestureDetector(
      onTap: () => onTap(align),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4)
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? const Color(0xFFFF5E5E) : const Color(0xFF95A5A6),
        ),
      ),
    );
  }

  Widget _headingButton(String label, double size, Function(double) onTap) {
    final isSelected = _fontSize == size;
    return GestureDetector(
      onTap: () => onTap(size),
      child: Container(
        width: 44,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1C1E) : const Color(0xFFF5F8FC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : const Color(0xFFBDC3C7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _colorOption(Color color, Function(Color) onTap) {
    final isSelected = _textColor == color;
    return GestureDetector(
      onTap: () => onTap(color),
      child: Container(
        margin: const EdgeInsets.only(right: 14),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: const Color(0xFFFF5E5E), width: 2)
              : null,
        ),
        child: Center(
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _fontFamilyOption(String label, String family, Function(String) onTap,
      {bool hasBadge = false}) {
    final isSelected = _fontFamily == family;
    return GestureDetector(
      onTap: () => onTap(family),
      child: Container(
        width: 100,
        height: 110,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF5F8FC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF5E5E) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5))
                ]
              : null,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Aa',
                  style: TextStyle(
                    fontFamily: family,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1C1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF1A1C1E)
                        : const Color(0xFF95A5A6),
                    height: 1.1,
                  ),
                ),
              ],
            ),
            if (hasBadge)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1C40F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.workspace_premium,
                      size: 10, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _insertEmoji(String emoji) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final start = selection.start;
    final end = selection.end;

    if (start == -1) {
      _contentController.text = text + emoji;
      return;
    }

    final newText = text.replaceRange(start, end, emoji);
    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
  }

  void _showEmojiLibrary() {
    final List<Map<String, dynamic>> emojiCategories = [
      {
        'title': 'Smileys',
        'emojis': [
          '😀',
          '😃',
          '😄',
          '😁',
          '😆',
          '😅',
          '😂',
          '🤣',
          '😊',
          '😇',
          '🙂',
          '🙃',
          '😉',
          '😌',
          '😍',
          '🥰',
          '😘',
          '😗',
          '😙',
          '😚',
          '😋',
          '😛',
          '😝',
          '😜',
          '🤪',
          '🤨',
          '🧐',
          '🤓',
          '😎',
          '🤩',
          '🥳',
          '😏',
          '😒',
          '😞',
          '😔',
          '😟',
          '😕',
          '🙁',
          '☹️',
          '😣',
          '😖',
          '😫',
          '😩',
          '🥺',
          '😢',
          '😭',
          '😤',
          '😠',
          '😡',
          '🤬',
          '🤯',
          '😳',
          '🥵',
          '🥶',
          '😱',
          '😨',
          '😰',
          '😥',
          '😓',
          '🤗',
        ]
      },
      {
        'title': 'Hearts & Love',
        'emojis': [
          '❤️',
          '🧡',
          '💛',
          '💚',
          '💙',
          '💜',
          '🖤',
          '🤍',
          '🤎',
          '💔',
          '❣️',
          '💕',
          '💞',
          '💓',
          '💗',
          '💖',
          '💘',
          '💝',
          '💟',
          '💌',
          '💋',
          '💏',
          '💑',
          '💍',
          '💎',
        ]
      },
      {
        'title': 'Hands & People',
        'emojis': [
          '👋',
          '🤚',
          '🖐️',
          '✋',
          '🖖',
          '👌',
          '🤏',
          '✌️',
          '🤞',
          '🤟',
          '🤘',
          '🤙',
          '👈',
          '👉',
          '👆',
          '🖕',
          '👇',
          '☝️',
          '👍',
          '👎',
          '✊',
          '👊',
          '🤛',
          '🤜',
          '👏',
          '🙌',
          '👐',
          '🤲',
          '🤝',
          '🙏',
          '✍️',
          '💅',
          '🤳',
          '💪',
          '🦾',
          '🦵',
          '🦿',
          '🦶',
          '👂',
          '🦻',
        ]
      },
      {
        'title': 'Animals & Nature',
        'emojis': [
          '🐶',
          '🐱',
          '🐭',
          '🐹',
          '🐰',
          '🦊',
          '🐻',
          '🐼',
          '🐻‍❄️',
          '🐨',
          '🐯',
          '🦁',
          '🐮',
          '🐷',
          '🐽',
          '🐸',
          '🐵',
          '🙈',
          '🙉',
          '🙊',
          '🐒',
          '🐔',
          '🐧',
          '🐦',
          '🐤',
          '🐣',
          '🐥',
          '🦆',
          '🦢',
          '🦉',
          '🦚',
          '🦜',
          '🐺',
          '🐗',
          '🐴',
          '🦄',
          '🐝',
          '🪱',
          '🐛',
          '🦋',
          '🐌',
          '🐞',
          '🐜',
          '🦟',
          '🦗',
          '🕷️',
          '🕸️',
          '🦂',
          '🐢',
          '🐍',
        ]
      },
      {
        'title': 'Food & Drink',
        'emojis': [
          '🍏',
          '🍎',
          '🍐',
          '🍊',
          '🍋',
          '🍌',
          '🍉',
          '🍇',
          '🍓',
          '🫐',
          '🍈',
          '🍒',
          '🍑',
          '🥭',
          '🍍',
          '🥥',
          '🥝',
          '🍅',
          '🍆',
          '🥑',
          '🥦',
          '🥬',
          '🥒',
          '🌽',
          '🥕',
          '🫑',
          '🥔',
          '🍠',
          '🥐',
          '🥯',
          '🍞',
          '🥖',
          '🥨',
          '🧀',
          '🥚',
          '🍳',
          '🧈',
          '🥞',
          '🧇',
          '🥓',
          '🥩',
          '🍗',
          '🍖',
          '🌭',
          '🍔',
          '🍟',
          '🍕',
          '🥘',
          '🍲',
          '🥣',
        ]
      }
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
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
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 24),
                Text(
                  'Emoji Library',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: emojiCategories.length,
                itemBuilder: (context, index) {
                  final category = emojiCategories[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 12),
                        child: Text(
                          category['title'].toString().toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[400],
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemCount: (category['emojis'] as List).length,
                        itemBuilder: (context, i) {
                          final emoji = category['emojis'][i];
                          return GestureDetector(
                            onTap: () {
                              _insertEmoji(emoji);
                              HapticFeedback.lightImpact();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F8FC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoodPicker({bool isFromToolbar = false}) {
    final Map<String, List<String>> moodStyles = {
      'Normal Mood Pack': ['😊', '😔', '😡', '😴', '🤔', '🥳'],
      'Animals Mood': [
        'assets/emojis/Animals_Mood/1.webp',
        'assets/emojis/Animals_Mood/2.webp',
        'assets/emojis/Animals_Mood/3.webp',
        'assets/emojis/Animals_Mood/4.webp',
        'assets/emojis/Animals_Mood/5.webp',
        'assets/emojis/Animals_Mood/6.webp'
      ],
      'Aqua Mood': [
        'assets/emojis/Aqua_Mood/1.webp',
        'assets/emojis/Aqua_Mood/2.webp',
        'assets/emojis/Aqua_Mood/3.webp',
        'assets/emojis/Aqua_Mood/4.webp',
        'assets/emojis/Aqua_Mood/5.webp',
        'assets/emojis/Aqua_Mood/6.webp'
      ],
      'Cat Mood': [
        'assets/emojis/Cat_Mood/Icon.svg',
        'assets/emojis/Cat_Mood/Icon_1.svg',
        'assets/emojis/Cat_Mood/Icon_2.svg',
        'assets/emojis/Cat_Mood/Icon_3.svg',
        'assets/emojis/Cat_Mood/Icon_4.svg',
        'assets/emojis/Cat_Mood/Icon_5.svg'
      ],
      'Pet Mood': [
        'assets/emojis/Pet_Mood/1.webp',
        'assets/emojis/Pet_Mood/2.webp',
        'assets/emojis/Pet_Mood/3.webp',
        'assets/emojis/Pet_Mood/5.webp',
        'assets/emojis/Pet_Mood/6.webp',
        'assets/emojis/Pet_Mood/6_1.webp'
      ],
    };

    showDialog(
      context: context,
      barrierColor: Colors.black12,
      builder: (_) => StatefulBuilder(builder: (context, setDialogState) {
        final currentMoods =
            moodStyles[_selectedMoodStyle] ?? moodStyles['Normal Mood Pack']!;
        return Stack(
          children: [
            Positioned(
              top: isFromToolbar ? null : 155,
              bottom: isFromToolbar ? 100 : null,
              right: isFromToolbar ? null : 24,
              left: isFromToolbar ? (isFromToolbar ? 80 : 100) : null,
              child: Material(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: isFromToolbar
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.end,
                  children: [
                    if (!isFromToolbar)
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
                            color: Colors.black.withValues(alpha: 0.08),
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
                            itemCount: currentMoods.length,
                            itemBuilder: (ctx, i) {
                              final moodValue = currentMoods[i];
                              final bool isSvg = moodValue.endsWith('.svg');
                              final bool isImage = moodValue.endsWith('.png') ||
                                  moodValue.endsWith('.webp');

                              return GestureDetector(
                                onTap: () {
                                  setState(() => _selectedMood = moodValue);
                                  Get.back();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: isSvg
                                        ? SvgPicture.asset(
                                            moodValue,
                                            width: 44,
                                            height: 44,
                                            fit: BoxFit.contain,
                                          )
                                        : isImage
                                            ? Image.asset(
                                                moodValue,
                                                width: 44,
                                                height: 44,
                                                fit: BoxFit.contain,
                                              )
                                            : Text(
                                                moodValue,
                                                style: const TextStyle(
                                                    fontSize: 32),
                                              ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              Get.back(); // Close mood picker
                              Get.toNamed(AppRoutes.moodStyle);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('👉 ',
                                    style: TextStyle(fontSize: 14)),
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
                    if (isFromToolbar)
                      Padding(
                        padding: const EdgeInsets.only(top: 2, right: 10),
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: CustomPaint(
                            size: const Size(20, 10),
                            painter: _TrianglePainter(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showTagsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TagsSheet(
        selectedTags: _tags,
        allTags: _allTags,
        onTagsChanged: (tags) {
          setState(() => _tags = tags);
        },
        onNewTagAdded: _saveNewTag,
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
                      'Background',
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
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: 1 + _noteThemeAssets.length + _bgColors.length,
                  itemBuilder: (ctx, i) {
                    if (i == 0) {
                      // Default option
                      final isSelected =
                          _selectedBgImage == null && _selectedBgIndex == -1;
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
                            color: const Color(0xFFF5F8FC),
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(
                                    color: const Color(0xFF3B9EFE), width: 2)
                                : Border.all(color: Colors.transparent),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.block_rounded,
                              color: const Color(0xFF3B9EFE)
                                  .withValues(alpha: 0.6),
                              size: 32,
                            ),
                          ),
                        ),
                      );
                    }

                    if (i <= _noteThemeAssets.length) {
                      // Asset backgrounds
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
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(
                                    color: const Color(0xFF3B9EFE), width: 2)
                                : Border.all(color: Colors.transparent),
                            image: DecorationImage(
                              image: AssetImage(asset),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: isSelected ? _buildSelectionOverlay(tc) : null,
                        ),
                      );
                    }

                    // Solid colors
                    final colorIndex = i - 1 - _noteThemeAssets.length;
                    final color = _bgColors[colorIndex];
                    final isSelected = _selectedBgIndex == colorIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedBgIndex = colorIndex;
                          _selectedBgImage = null;
                        });
                        Get.back();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected
                              ? Border.all(
                                  color: const Color(0xFF3B9EFE), width: 2)
                              : Border.all(color: Colors.transparent),
                        ),
                        child: isSelected ? _buildSelectionOverlay(tc) : null,
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

  Widget _buildSelectionOverlay(ThemeController tc) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check_circle,
            color: ThemeController.themes[0].primary, size: 18),
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
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Not saved yet',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1C1E),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Would you like to keep it as a\ndraft?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: const Color(0xFF7F8C8D),
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFF3B9EFE), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          'Discard',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF3B9EFE),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _save();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B9EFE),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Save Draft',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
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
                          gradient: ThemeController.themes[0].backgroundImage !=
                                  null
                              ? null
                              : LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors:
                                      ThemeController.themes[0].gradientColors,
                                ),
                          image:
                              ThemeController.themes[0].backgroundImage != null
                                  ? DecorationImage(
                                      image: AssetImage(ThemeController
                                          .themes[0].backgroundImage!),
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
                                            .withValues(alpha: 0.3),
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
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: _pickDate,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
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
                                            Flexible(
                                              child: Text(
                                                DateFormat('MMM, yyyy')
                                                    .format(_selectedDate),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: contentColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Icon(Icons.arrow_drop_down,
                                                color: contentColor, size: 24),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    GestureDetector(
                                      onTap: _showMoodPicker,
                                      child: CustomPaint(
                                        painter: _DashedCirclePainter(
                                            color: Colors.black
                                                .withValues(alpha: 0.2)),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: _selectedMood.isEmpty
                                              ? const Icon(
                                                  Icons
                                                      .sentiment_satisfied_alt_rounded,
                                                  color: Colors.black26,
                                                  size: 28,
                                                )
                                              : _selectedMood.endsWith('.svg')
                                                  ? SvgPicture.asset(
                                                      _selectedMood,
                                                      width: 28,
                                                      height: 28,
                                                    )
                                                  : _selectedMood.endsWith(
                                                              '.png') ||
                                                          _selectedMood
                                                              .endsWith('.webp')
                                                      ? Image.asset(
                                                          _selectedMood,
                                                          width: 28,
                                                          height: 28,
                                                        )
                                                      : Text(
                                                          _selectedMood,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 28),
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
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: contentColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Title',
                                    hintStyle: GoogleFonts.poppins(
                                      color:
                                          contentColor.withValues(alpha: 0.6),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                                // Tags display
                                if (_tags.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _tags.map((tag) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _tags.remove(tag);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: (isDarkBg
                                                    ? Colors.white
                                                    : const Color(0xFF3B9EFE))
                                                .withValues(alpha: 0.15),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: (isDarkBg
                                                      ? Colors.white
                                                      : const Color(0xFF3B9EFE))
                                                  .withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '#$tag',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: isDarkBg
                                                      ? Colors.white
                                                      : const Color(0xFF3B9EFE),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Icon(
                                                Icons.close_rounded,
                                                size: 14,
                                                color: isDarkBg
                                                    ? Colors.white
                                                    : const Color(0xFF3B9EFE),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                // Content field
                                TextField(
                                  controller: _contentController,
                                  maxLines: null,
                                  textAlign: _textAlign,
                                  style: GoogleFonts.getFont(
                                    _fontFamily,
                                    fontSize: _fontSize,
                                    color: _textColor == Colors.black &&
                                            isDarkBg
                                        ? Colors.white.withValues(alpha: 0.9)
                                        : _textColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Start typing here...',
                                    hintStyle: GoogleFonts.getFont(
                                      _fontFamily,
                                      color:
                                          contentColor.withValues(alpha: 0.6),
                                      fontSize: _fontSize,
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
                                                    .withValues(alpha: 0.05),
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
                              color: Colors.black.withValues(alpha: 0.06),
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
                              onTap: _showFontSettings,
                            ),
                            _ToolbarIcon(
                              icon: Icons.image_outlined,
                              color: const Color(0xFF3B9EFE),
                              onTap: _pickImage,
                            ),
                            _ToolbarIcon(
                              icon: Icons.sentiment_satisfied_alt_rounded,
                              color: const Color(0xFF3B9EFE),
                              onTap: _showEmojiLibrary,
                            ),
                            _ToolbarIcon(
                              icon: Icons.local_offer_outlined,
                              color: const Color(0xFF3B9EFE),
                              onTap: _showTagsSheet,
                            ),
                            _ToolbarIcon(
                              icon: Icons.draw_rounded,
                              color: const Color(0xFF3B9EFE),
                              onTap: () => Get.to(() => const DrawingPage()),
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
      {required this.icon, required this.color, required this.onTap});

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
  final List<String> allTags;
  final Function(List<String>) onTagsChanged;
  final Function(String) onNewTagAdded;

  const _TagsSheet({
    required this.selectedTags,
    required this.allTags,
    required this.onTagsChanged,
    required this.onNewTagAdded,
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
      widget.onNewTagAdded(tag);
      _tagController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      'Tags',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1C1E),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF3B9EFE), size: 32),
                      onPressed: () {
                        widget.onTagsChanged(_selected);
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Add tag input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F8FC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _tagController,
                          style: GoogleFonts.poppins(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Enter Tag Name',
                            hintStyle: GoogleFonts.poppins(
                                color: const Color(0xFFBDC3C7), fontSize: 13),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          onSubmitted: (_) => _addTag(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _addTag,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B9EFE),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                      ),
                      child: Text(
                        'Add',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Tags grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: widget.allTags.map((tag) {
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF3B9EFE).withValues(alpha: 0.1)
                              : const Color(0xFFF5F8FC),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF3B9EFE)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '#$tag',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: isSelected
                                    ? const Color(0xFF3B9EFE)
                                    : const Color(0xFF7F8C8D),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.close_rounded,
                                  size: 14, color: Color(0xFF3B9EFE)),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
