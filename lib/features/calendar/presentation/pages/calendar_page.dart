import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:diary_with_lock/core/theme/app_theme.dart';
import 'package:diary_with_lock/features/home/presentation/controllers/home_controller.dart';
import 'package:diary_with_lock/features/home/data/models/diary_entry.dart';
import 'package:diary_with_lock/features/compose/presentation/pages/compose_page.dart';

class CalendarPage extends StatefulWidget {
  final bool embedded;
  const CalendarPage({super.key, this.embedded = false});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final DateTime today = DateTime.now();
    final DateTime effectiveSelectedDay = _selectedDay ?? today;

    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 16, bottom: 24),
              child: Text(
                'Calendar',
                style: GoogleFonts.yellowtail(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: TableCalendar<DiaryEntry>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                },
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: false,
                  titleTextFormatter: (date, locale) =>
                      DateFormat('MMMM yyyy').format(date),
                  titleTextStyle: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                  headerPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leftChevronPadding: const EdgeInsets.only(right: 8),
                  rightChevronPadding: const EdgeInsets.only(left: 8),
                  leftChevronIcon: const Icon(Icons.chevron_left_rounded,
                      color: Color(0xFF3B9EFE)),
                  rightChevronIcon: const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFF3B9EFE)),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF95A5A6),
                  ),
                  weekendStyle: GoogleFonts.poppins(
                    fontSize: 12,
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
                  selectedTextStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B9EFE),
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Color(0xFFFFC107),
                    shape: BoxShape.circle,
                  ),
                  markersOffset: const PositionedOffset(bottom: 6, end: 6),
                  markersAlignment: Alignment.bottomRight,
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    final moodEntry = controller.entries.firstWhereOrNull(
                      (e) => isSameDay(e.date, day) && e.mood.isNotEmpty,
                    );
                    if (moodEntry == null) {
                      return null;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4, right: 2),
                      child: Text(
                        moodEntry.mood,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                final DateTime day = effectiveSelectedDay;
                final dayEntries = controller.entries
                    .where((e) => isSameDay(e.date, day))
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        DateFormat('EEEE, MMM d, yyyy').format(day),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF3B9EFE),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (dayEntries.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            'No Notes Found',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF7F8C8D),
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: dayEntries.length,
                          itemBuilder: (ctx, i) =>
                              _CalendarEntryTile(entry: dayEntries[i]),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarEntryTile extends StatelessWidget {
  final DiaryEntry entry;
  const _CalendarEntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final String displayTitle =
        entry.title.isNotEmpty ? entry.title : 'Untitled';
    final String displayMood = entry.mood.isNotEmpty ? entry.mood : '😊';
    final String displayTime = DateFormat('h:mm a').format(entry.date);

    return GestureDetector(
      onTap: () => Get.to(() => ComposePage(entry: entry)),
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Text(
                  displayMood,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displayTime,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF95A5A6),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFB0BEC5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
