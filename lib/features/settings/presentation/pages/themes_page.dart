import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/theme/theme_controller.dart';

class ThemesPage extends StatefulWidget {
  const ThemesPage({super.key});

  @override
  State<ThemesPage> createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    final tc = Get.find<ThemeController>();
    _currentPage = tc.themeIndex;
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.75,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (tc) {
        const themes = ThemeController.themes;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.black, size: 22),
              onPressed: () => Get.back(),
            ),
            title: Text(
              'Theme Preview',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            centerTitle: false,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE0F2FD),
                  Color(0xFFF9E8F5),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Theme Carousel
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: themes.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final theme = themes[index];
                        final isSelected = _currentPage == index;

                        return AnimatedScale(
                          scale: isSelected ? 1.0 : 0.85,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFF1A1A1A),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Stack(
                                children: [
                                  // Theme Background
                                  if (theme.backgroundImage != null)
                                    Image.asset(
                                      theme.backgroundImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                  else
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: theme.gradientColors,
                                        ),
                                      ),
                                    ),

                                  // Mock UI Elements
                                  _buildMockUI(theme),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Apply Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GestureDetector(
                      onTap: () {
                        tc.changeTheme(_currentPage);
                        Get.back();
                        Get.snackbar(
                          'Theme Applied',
                          '${themes[_currentPage].name} theme is now active!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.white.withValues(alpha: 0.8),
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4FC3F7), Color(0xFF2196F3)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2196F3).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'APPLY',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMockUI(AppThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return Column(
      children: [
        // Mock Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isDark ? 0.15 : 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.search,
                    color: textColor.withValues(alpha: 0.6), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Search notes..',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: textColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Mock List Items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0${3 - index} Feb',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 8,
                      decoration: BoxDecoration(
                        color: textColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 120,
                      height: 8,
                      decoration: BoxDecoration(
                        color: textColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Mock Bottom Nav
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isDark ? 0.95 : 1.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMockNavItem(Icons.book_outlined, 'Diary', false, textColor),
              _buildMockNavItem(
                  Icons.calendar_today_outlined, 'Calendar', false, textColor),
              _buildMockNavItem(
                  Icons.calendar_month_outlined, 'Photos', false, textColor),
              _buildMockNavItem(Icons.settings, 'Setting', true, textColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMockNavItem(
      IconData icon, String label, bool isSelected, Color baseColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            color: isSelected ? const Color(0xFF1A1A1A) : Colors.grey,
            size: 20),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 9,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFF1A1A1A) : Colors.grey,
          ),
        ),
      ],
    );
  }
}
