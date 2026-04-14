import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:diary_with_lock/core/services/notification_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/core/theme/app_theme.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';
import 'package:diary_with_lock/core/utils/email_util.dart';
import 'feedback_page.dart';
import '../controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showRateUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _RateUsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    // Refresh settings when returning to this page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadSettings();
    });

    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 16, bottom: 24),
              child: Text(
                'Settings',
                style: GoogleFonts.yellowtail(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // PERSONALIZE section
                  const _SectionHeader(label: 'PERSONALIZE'),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    children: [
                      _SettingsRow(
                        icon: Icons.lock_outline_rounded,
                        label: 'Passcode Settings',
                        trailing: const _PasscodeStatus(),
                        onTap: () => Get.toNamed('/passcode-settings'),
                      ),
                      const _Divider(),
                      _SettingsRow(
                        icon: Icons.brush_outlined,
                        label: 'Themes',
                        onTap: () => Get.toNamed(AppRoutes.themes),
                      ),
                      const _Divider(),
                      _SettingsRow(
                        icon: Icons.sentiment_satisfied_outlined,
                        label: 'Mood',
                        onTap: () => Get.toNamed(AppRoutes.moodStyle),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Daily Reminders card
                  _SettingsCard(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F6FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Color(0xFF3B9EFE),
                                  size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Daily Reminders',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                             _ReminderToggle(),
                          ],
                        ),
                      ),
                      const _Divider(),
                      Obx(() => InkWell(
                            onTap: () async {
                              await Get.toNamed(AppRoutes.dailyReminders);
                              controller.loadSettings();
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.formattedReminderTime,
                                    style: GoogleFonts.poppins(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF2C3E50),
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right_rounded,
                                      color: Colors.grey, size: 28),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // OTHER section
                  const _SectionHeader(label: 'OTHER'),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    children: [
                      _SettingsRow(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        onTap: () {},
                      ),
                      const _Divider(),
                      _SettingsRow(
                        icon: Icons.star_outline_rounded,
                        label: 'Rate us',
                        onTap: () => _showRateUsDialog(context),
                      ),
                      const _Divider(),
                      _SettingsRow(
                        icon: Icons.shield_outlined,
                        label: 'Privacy Policy',
                        onTap: () {},
                      ),
                      const _Divider(),
                      _SettingsRow(
                        icon: Icons.chat_bubble_outline_rounded,
                        label: 'Feedback',
                        onTap: () => Get.to(() => const FeedbackPage()),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Delete data (keep but style to match)
                  _SettingsCard(
                    children: [
                      _SettingsRow(
                        icon: Icons.delete_outline_rounded,
                        label: 'Delete All Data',
                        iconColor: Colors.redAccent,
                        labelColor: Colors.redAccent,
                        onTap: () => Get.toNamed(AppRoutes.deleteDate),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderToggle extends StatefulWidget {
  @override
  State<_ReminderToggle> createState() => _ReminderToggleState();
}

class _ReminderToggleState extends State<_ReminderToggle> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    _enabled =
        StorageUtil.getBool(StorageUtil.keyReminderEnabled, defaultValue: true);
  }

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: _enabled,
      activeColor: const Color(0xFF3B9EFE),
      onChanged: (v) async {
        setState(() => _enabled = v);
        await StorageUtil.setBool(StorageUtil.keyReminderEnabled, v);

        final controller = Get.find<SettingsController>();
        controller.reminderEnabled.value = v;

        if (v) {
          final granted = await NotificationService().requestPermissions();
          if (!granted) {
            setState(() => _enabled = false);
            await StorageUtil.setBool(StorageUtil.keyReminderEnabled, false);
            controller.reminderEnabled.value = false;
            Get.snackbar(
              'Permission Needed',
              'Please enable notifications to receive reminders.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.withValues(alpha: 0.1),
            );
            return;
          }
          final savedTime =
              StorageUtil.getString(StorageUtil.keyReminderTime) ?? "10:41";
          final parts = savedTime.split(':');
          await NotificationService().scheduleDailyNotification(
            id: 1,
            title: 'Time to write! ✍️',
            body: 'Every day is a story. What\'s yours today?',
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        } else {
          await NotificationService().cancelNotification(1);
        }
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF7F8C8D),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withOpacity(0.1),
      indent: 76,
      endIndent: 16,
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (iconColor ?? const Color(0xFF3B9EFE)).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? const Color(0xFF3B9EFE),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: labelColor ?? const Color(0xFF2C3E50),
                ),
              ),
            ),
            if (trailing != null) trailing!,
            if (trailing == null)
              const Icon(Icons.chevron_right_rounded,
                  color: Color(0xFFBDC3C7), size: 24),
          ],
        ),
      ),
    );
  }
}

// Rate Us Dialog matching Figma design
class _RateUsDialog extends StatefulWidget {
  const _RateUsDialog();

  @override
  State<_RateUsDialog> createState() => _RateUsDialogState();
}

class _RateUsDialogState extends State<_RateUsDialog> {
  int _rating = 4;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.close, color: AppColors.textGrey),
              ),
            ),
            // Star emoji
            const Text('⭐', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              'Enjoying My Diary App?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Would you mind taking a moment to rate it?\nIt won\'t take more than a minute.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
            const SizedBox(height: 16),
            // Star rating row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      i < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 36,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 6),
            Text(
              'THE BEST WE CAN GET 🚀',
              style: TextStyle(fontSize: 10, color: AppColors.textGrey),
            ),
            const SizedBox(height: 16),
            // Rate Now button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Get.back();

                  try {
                    // Forward rating to email as requested
                    await EmailUtil.sendFeedbackEmail(
                      rating: _rating,
                      feedback: "Rating from Rate Us dialog.",
                    );

                    // Also try in-app review if it's a high rating (optional but good for UX)
                    if (_rating >= 4) {
                      final InAppReview inAppReview = InAppReview.instance;
                      if (await inAppReview.isAvailable()) {
                        inAppReview.requestReview();
                      }
                    }

                    Get.snackbar('Thank you!',
                        'Opening your email app to send your rating...',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1));
                  } catch (e) {
                    Get.snackbar('Error', 'Could not open email app.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.withValues(alpha: 0.1));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Rate Now',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasscodeStatus extends StatelessWidget {
  const _PasscodeStatus();

  @override
  Widget build(BuildContext context) {
    final lockType = StorageUtil.getString(StorageUtil.keyLockType);
    final statusText = lockType != null ? lockType.toUpperCase() : 'OFF';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          statusText,
          style: GoogleFonts.poppins(
            color: const Color(0xFFBDC3C7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right_rounded,
            color: Color(0xFFBDC3C7), size: 24),
      ],
    );
  }
}
