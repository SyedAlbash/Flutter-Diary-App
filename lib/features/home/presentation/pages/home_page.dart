import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/core/theme/theme_controller.dart';
import 'package:diary_with_lock/features/settings/presentation/pages/settings_page.dart';
import 'package:diary_with_lock/features/home/presentation/controllers/home_controller.dart';
import 'package:diary_with_lock/features/home/data/models/diary_entry.dart';
import 'package:diary_with_lock/features/calendar/presentation/pages/calendar_page.dart';
import 'package:diary_with_lock/features/photos/presentation/pages/photos_page.dart';
import 'package:diary_with_lock/features/compose/presentation/pages/compose_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return GetBuilder<ThemeController>(
      builder: (tc) {
        return Obx(() {
          final currentTheme = tc.getThemeFor(
            route: AppRoutes.home,
            tabIndex: controller.currentTab.value,
          );
          final isDark = currentTheme.brightness == Brightness.dark;
          final size = MediaQuery.of(context).size;

          return Theme(
            data: tc.getThemeDataFor(
              route: AppRoutes.home,
              tabIndex: controller.currentTab.value,
            ),
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: currentTheme.primary,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
                systemNavigationBarColor: currentTheme.bottomNavBg,
                systemNavigationBarIconBrightness:
                    isDark ? Brightness.light : Brightness.dark,
              ),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                extendBody: true,
                body: Stack(
                  children: [
                    // Fixed background
                    SizedBox(
                      width: size.width,
                      height: size.height,
                      child: Container(
                        decoration: BoxDecoration(
                          color: currentTheme.background,
                          gradient: currentTheme.backgroundImage != null
                              ? null
                              : LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: currentTheme.gradientColors,
                                ),
                          image: currentTheme.backgroundImage != null
                              ? DecorationImage(
                                  image:
                                      AssetImage(currentTheme.backgroundImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        [
                          _DiaryTab(controller: controller),
                          const CalendarPage(embedded: true),
                          PhotosPage(embedded: true),
                          const SettingsPage(),
                        ][controller.currentTab.value],

                        // Floating Action Button for adding new entry
                        // Only show when there are entries (not in empty state) and ONLY on the Diary tab (tab 0)
                        if (controller.entries.isNotEmpty &&
                            controller.currentTab.value == 0)
                          Positioned(
                            bottom: 110,
                            right: 24,
                            child: GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.compose),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: currentTheme.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 12,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),

                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, bottom: 16),
                            child: _BottomNav(controller: controller),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

class _BottomNav extends StatelessWidget {
  final HomeController controller;
  const _BottomNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.auto_stories_outlined,
        'activeIcon': Icons.auto_stories,
        'label': 'Diary'
      },
      {
        'icon': Icons.calendar_month_outlined,
        'activeIcon': Icons.calendar_month,
        'label': 'Calendar'
      },
      {
        'icon': Icons.photo_outlined,
        'activeIcon': Icons.photo,
        'label': 'Photo'
      },
      {
        'icon': Icons.settings_outlined,
        'activeIcon': Icons.settings,
        'label': 'Settings'
      },
    ];

    final theme = Theme.of(context);
    final selectedColor = theme.primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (i) {
              final selected = controller.currentTab.value == i;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.currentTab.value = i,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? selectedColor.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          selected
                              ? items[i]['activeIcon'] as IconData
                              : items[i]['icon'] as IconData,
                          color: selected
                              ? selectedColor
                              : Colors.grey.withValues(alpha: 0.6),
                          size: 24,
                        ),
                      ),
                      Text(
                        items[i]['label'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: selected
                              ? selectedColor
                              : Colors.grey.withValues(alpha: 0.6),
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          )),
    );
  }
}

class _DiaryTab extends StatefulWidget {
  final HomeController controller;
  const _DiaryTab({required this.controller});

  @override
  State<_DiaryTab> createState() => _DiaryTabState();
}

class _DiaryTabState extends State<_DiaryTab> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void _showSortMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => GetBuilder<ThemeController>(
        builder: (tc) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.circle,
                      size: 10, color: tc.currentTheme.primary),
                  title: const Text('Newest First',
                      style: TextStyle(fontSize: 14)),
                ),
                const ListTile(
                  leading: Icon(Icons.circle, size: 10, color: Colors.grey),
                  title: Text('Oldest First', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Column(
          children: [
            // Header: Search and more menu icons in the top right
            Padding(
              padding: const EdgeInsets.only(
                  right: 12, top: 12, bottom: 0, left: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_isSearching)
                    Expanded(
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          style: GoogleFonts.poppins(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search by title...',
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.grey),
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search,
                                size: 20, color: Colors.grey),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onChanged: (value) {
                            widget.controller.searchQuery.value = value;
                          },
                        ),
                      ),
                    ),
                  GetBuilder<ThemeController>(
                    builder: (tc) => IconButton(
                      icon: Icon(
                        _isSearching
                            ? Icons.close_rounded
                            : Icons.search_rounded,
                        color: tc.currentTheme.primary,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_isSearching) {
                            _isSearching = false;
                            _searchController.clear();
                            widget.controller.searchQuery.value = '';
                          } else {
                            _isSearching = true;
                          }
                        });
                      },
                    ),
                  ),
                  GetBuilder<ThemeController>(
                    builder: (tc) => IconButton(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: tc.currentTheme.primary,
                        size: 28,
                      ),
                      onPressed: () => _showSortMenu(context),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Obx(() {
                if (widget.controller.entries.isEmpty) {
                  return _EmptyState();
                }
                return _EntriesList(controller: widget.controller);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120), // Padding for floating nav
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.compose),
            child: Image.asset(
              'assets/screens/Main Feature Card.webp',
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.auto_stories,
                      size: 100, color: Colors.grey),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _EntriesList extends StatelessWidget {
  final HomeController controller;
  const _EntriesList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (tc) {
        return Obx(() {
          // Flatten entries and add month headers as separate items
          final List<dynamic> items = [];
          final monthEntries = <String, List<DiaryEntry>>{};

          // Filter entries by search query
          final query = controller.searchQuery.value.toLowerCase();
          final filteredEntries = controller.entries.where((e) {
            return e.title.toLowerCase().contains(query);
          }).toList();

          // Sort entries by date (newest first is preferred default)
          filteredEntries.sort((a, b) => b.date.compareTo(a.date));

          for (final entry in filteredEntries) {
            final key = DateFormat('MMMM, yyyy').format(entry.date);
            if (!monthEntries.containsKey(key)) {
              monthEntries[key] = [];
              items.add(key); // Add header string
            }
            monthEntries[key]!.add(entry);
            items.add(entry); // Add entry object
          }

          if (items.isEmpty && query.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded,
                      size: 64, color: Colors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No results found for "$query"',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 8,
                bottom: 120), // Added bottom padding for floating nav
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              if (item is String) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1C1E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${monthEntries[item]!.length} entries this month',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: const Color(0xFF3B9EFE),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return _EntryCard(entry: item as DiaryEntry);
              }
            },
          );
        });
      },
    );
  }
}

class _EntryCard extends StatelessWidget {
  final DiaryEntry entry;
  const _EntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (tc) {
        final bool isAsset = entry.backgroundColor.startsWith('assets/');
        final Color? bgColor = !isAsset && entry.backgroundColor.isNotEmpty
            ? Color(int.parse(entry.backgroundColor))
            : null;

        // Determine the content color based on background
        Color contentColor;
        if (isAsset) {
          final name = entry.backgroundColor.toLowerCase();
          contentColor = (name.contains('dark') ||
                  name.contains('sky') ||
                  name.contains('night') ||
                  name.contains('theme 1') ||
                  name.contains('theme 3'))
              ? Colors.white
              : Colors.black;
        } else if (bgColor != null) {
          contentColor =
              bgColor.computeLuminance() < 0.35 ? Colors.white : Colors.black;
        } else {
          contentColor = tc.currentTheme.brightness == Brightness.dark
              ? Colors.white
              : Colors.black;
        }

        return GestureDetector(
          onTap: () => Get.to(() => ComposePage(entry: entry)),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: bgColor ?? tc.currentTheme.cardBg.withValues(alpha: 0.85),
              image: isAsset
                  ? DecorationImage(
                      image: AssetImage(entry.backgroundColor),
                      fit: BoxFit.cover,
                    )
                  : null,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: isAsset ||
                        (bgColor != null && bgColor.computeLuminance() < 0.5)
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      )
                    : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date column
                  SizedBox(
                    width: 48,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('dd').format(entry.date),
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3B9EFE),
                          ),
                        ),
                        Text(
                          DateFormat('MMM').format(entry.date).toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFBDC3C7),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Vertical Divider
                  Container(
                    width: 1,
                    height: 40,
                    color: contentColor.withValues(alpha: 0.1),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1C1E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF7F8C8D),
                                height: 1.3,
                              ),
                            ),
                            if (entry.tags.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 6,
                                runSpacing: 2,
                                children: entry.tags.take(3).map((tag) {
                                  return Text(
                                    '#$tag',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF3B9EFE),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                DateFormat('h:mm a').format(entry.date),
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: const Color(0xFFBDC3C7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (entry.mood.isNotEmpty)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: entry.mood.isEmpty
                                  ? const SizedBox.shrink()
                                  : entry.mood.endsWith('.svg')
                                      ? SvgPicture.asset(
                                          entry.mood,
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.contain,
                                        )
                                      : entry.mood.endsWith('.png') ||
                                              entry.mood.endsWith('.webp')
                                          ? Image.asset(
                                              entry.mood,
                                              width: 24,
                                              height: 24,
                                              fit: BoxFit.contain,
                                            )
                                          : Text(
                                              entry.mood,
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
