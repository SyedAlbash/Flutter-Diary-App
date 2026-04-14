import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';
import 'package:diary_with_lock/core/services/notification_service.dart';

class DailyRemindersPage extends StatefulWidget {
  const DailyRemindersPage({super.key});

  @override
  State<DailyRemindersPage> createState() => _DailyRemindersPageState();
}

class _DailyRemindersPageState extends State<DailyRemindersPage> {
  bool _reminderEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 19, minute: 47);
  final List<bool> _days = [false, true, false, true, false, false, true];
  final List<String> _dayLabels = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    _reminderEnabled =
        StorageUtil.getBool(StorageUtil.keyReminderEnabled, defaultValue: true);
    final savedTime =
        StorageUtil.getString(StorageUtil.keyReminderTime) ?? "19:47";
    final parts = savedTime.split(':');
    _reminderTime =
        TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    setState(() {});
  }

  Future<void> _saveSettings() async {
    await StorageUtil.setBool(StorageUtil.keyReminderEnabled, _reminderEnabled);
    await StorageUtil.setString(StorageUtil.keyReminderTime,
        "${_reminderTime.hour}:${_reminderTime.minute}");

    if (_reminderEnabled) {
      final granted = await NotificationService().requestPermissions();
      if (!granted) {
        setState(() => _reminderEnabled = false);
        await StorageUtil.setBool(StorageUtil.keyReminderEnabled, false);
        Get.snackbar(
          'Permission Needed',
          'Please enable notifications to receive reminders.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
        );
        return;
      }
      await NotificationService().scheduleDailyNotification(
        id: 1,
        title: 'Time to write! ✍️',
        body: 'Every day is a story. What\'s yours today?',
        hour: _reminderTime.hour,
        minute: _reminderTime.minute,
      );
    } else {
      await NotificationService().cancelNotification(1);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3B9EFE),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
      _saveSettings();
    }
  }

  String get _formattedHour {
    final h = _reminderTime.hourOfPeriod == 0 ? 12 : _reminderTime.hourOfPeriod;
    return h.toString().padLeft(2, '0');
  }

  String get _formattedMinute {
    return _reminderTime.minute.toString().padLeft(2, '0');
  }

  String get _period {
    return _reminderTime.period == DayPeriod.am ? 'AM' : 'PM';
  }

  int get _selectedDaysCount => _days.where((d) => d).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          'Daily Reminder',
          style: GoogleFonts.poppins(
            fontSize: 18,
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
              Color(0xFFE0F2FD), // Light blue top
              Color(0xFFF9E8F5), // Light pink bottom
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                // Daily Reminders Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Reminders',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'STAY CONSISTENT WITH YOUR\nDIARY',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7F8C8D),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: _reminderEnabled,
                        activeColor:
                            const Color(0xFF76FF03), // Vibrant green switch
                        onChanged: (v) {
                          setState(() => _reminderEnabled = v);
                          _saveSettings();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Scheduled For Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: const Color(0xFF3B9EFE).withOpacity(0.3),
                        width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'SCHEDULED FOR',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF7F8C8D),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _pickTime,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '$_formattedHour:$_formattedMinute',
                              style: GoogleFonts.poppins(
                                fontSize: 72,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF3B9EFE),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _period,
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF3B9EFE)
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.black,
                                        size: 28),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Tap to change',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7F8C8D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Repeat Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B9EFE).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                                Icons.notifications_active_outlined,
                                color: Color(0xFF3B9EFE),
                                size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Repeat',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2C3E50),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$_selectedDaysCount days selected',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3B9EFE),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (i) {
                          final isSelected = _days[i];
                          return GestureDetector(
                            onTap: () => setState(() => _days[i] = !_days[i]),
                            child: Container(
                              width: 42,
                              height: 70,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF3B9EFE)
                                    : const Color(0xFFF1F6FF),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  _dayLabels[i],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF7F8C8D),
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Save/Check button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      _saveSettings();
                      Get.back();
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B9EFE),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B9EFE).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 32),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
