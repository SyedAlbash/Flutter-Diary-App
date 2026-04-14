import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
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
        final currentTheme = tc.currentTheme;
        final isDark = currentTheme.brightness == Brightness.dark;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: currentTheme.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: currentTheme.bottomNavBg,
            systemNavigationBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
          ),
          child: Scaffold(
            extendBody: true,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: currentTheme.backgroundImage != null
                    ? null
                    : LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: currentTheme.gradientColors,
                      ),
                image: currentTheme.backgroundImage != null
                    ? DecorationImage(
                        image: AssetImage(currentTheme.backgroundImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Obx(() {
                    final tabs = [
                      _DiaryTab(controller: controller),
                      const CalendarPage(embedded: true),
                      PhotosPage(embedded: true),
                      const SettingsPage(),
                    ];
                    return tabs[controller.currentTab.value];
                  }),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 16),
                      child: _BottomNav(controller: controller),
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
        'icon': Icons.calendar_today_outlined,
        'activeIcon': Icons.calendar_today,
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
    return GetBuilder<ThemeController>(
      builder: (tc) {
        final selectedColor = tc.currentTheme.primary;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
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
                                  ? selectedColor.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              selected
                                  ? items[i]['activeIcon'] as IconData
                                  : items[i]['icon'] as IconData,
                              color: selected
                                  ? selectedColor
                                  : Colors.grey.withOpacity(0.6),
                              size: 24,
                            ),
                          ),
                          Text(
                            items[i]['label'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: selected
                                  ? selectedColor
                                  : Colors.grey.withOpacity(0.6),
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
      },
    );
  }
}

class _DiaryTab extends StatelessWidget {
  final HomeController controller;
  const _DiaryTab({required this.controller});

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
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Column(
          children: [
            // Header: Search bar and menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                children: [
                  Expanded(
                    child: GetBuilder<ThemeController>(
                      builder: (tc) => Container(
                        height: 54,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search,
                                color: tc.currentTheme.primary, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                onChanged: (v) =>
                                    controller.searchQuery.value = v,
                                decoration: InputDecoration(
                                  hintText: 'Search notes..',
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey.withOpacity(0.6),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GetBuilder<ThemeController>(
                    builder: (tc) => GestureDetector(
                      onTap: () => _showSortMenu(context),
                      child: Container(
                        height: 54,
                        width: 54,
                        decoration: BoxDecoration(
                          color: tc.currentTheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: tc.currentTheme.primary.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.tune_rounded,
                            color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Obx(() {
                if (controller.entries.isEmpty) {
                  return _EmptyState();
                }
                return _EntriesList(controller: controller);
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
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Use the full design card directly to avoid duplication
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.compose),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'assets/images/screens/Main Feature Card.png',
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Padding(
                        padding: EdgeInsets.all(40),
                        child: Icon(Icons.auto_stories,
                            size: 100, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
            ],
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
        // Flatten entries and add month headers as separate items
        final List<dynamic> items = [];
        final monthEntries = <String, List<DiaryEntry>>{};

        // Sort entries by date (newest first is preferred default)
        final sortedEntries = List<DiaryEntry>.from(controller.entries);
        sortedEntries.sort((a, b) => b.date.compareTo(a.date));

        for (final entry in sortedEntries) {
          final key = DateFormat('MMMM, yyyy').format(entry.date);
          if (!monthEntries.containsKey(key)) {
            monthEntries[key] = [];
            items.add(key); // Add header string
          }
          monthEntries[key]!.add(entry);
          items.add(entry); // Add entry object
        }

        return ListView.builder(
          padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 120), // Added bottom padding for floating nav
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            if (item is String) {
              return Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: tc.currentTheme.textDark,
                      ),
                    ),
                    Text(
                      '${monthEntries[item]!.length} entries',
                      style: TextStyle(
                        fontSize: 12,
                        color: tc.currentTheme.primary,
                        fontWeight: FontWeight.w500,
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

        Color contentColor;
        if (isAsset) {
          final name = entry.backgroundColor.toLowerCase();
          if (name.contains('dark') ||
              name.contains('sky') ||
              name.contains('night') ||
              name.contains('theme 1') ||
              name.contains('theme 3')) {
            contentColor = Colors.white;
          } else {
            contentColor = Colors.black;
          }
        } else if (bgColor != null) {
          contentColor =
              bgColor.computeLuminance() < 0.35 ? Colors.white : Colors.black;
        } else {
          // Default note (no custom background) - use theme's text color or black
          contentColor = tc.currentTheme.brightness == Brightness.dark
              ? Colors.white
              : Colors.black;
        }

        return GestureDetector(
          onTap: () => Get.to(() => ComposePage(entry: entry)),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: bgColor ?? tc.currentTheme.cardBg.withOpacity(0.85),
              image: isAsset
                  ? DecorationImage(
                      image: AssetImage(entry.backgroundColor),
                      fit: BoxFit.cover,
                    )
                  : null,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.3),
                        ],
                      )
                    : null,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date column
                  Container(
                    width: 48,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: contentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('dd').format(entry.date),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: contentColor,
                          ),
                        ),
                        Text(
                          DateFormat('MMM').format(entry.date),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: contentColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                entry.title.isEmpty ? 'Untitled' : entry.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: contentColor,
                                ),
                              ),
                            ),
                            if (entry.mood.isNotEmpty)
                              Text(
                                entry.mood,
                                style: const TextStyle(fontSize: 18),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.content.isEmpty
                              ? 'No content...'
                              : entry.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: contentColor.withOpacity(0.7),
                            height: 1.4,
                          ),
                        ),
                        if (entry.tags.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: entry.tags.take(3).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: contentColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: contentColor.withOpacity(0.8),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
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
