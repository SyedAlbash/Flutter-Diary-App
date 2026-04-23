import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/core/utils/storage_util.dart';
import 'package:diary_with_lock/core/constants/app_constants.dart';
import 'package:diary_with_lock/core/widgets/themed_background.dart';

class PasscodeSettingsPage extends StatefulWidget {
  const PasscodeSettingsPage({super.key});

  @override
  State<PasscodeSettingsPage> createState() => _PasscodeSettingsPageState();
}

class _PasscodeSettingsPageState extends State<PasscodeSettingsPage> {
  bool _passcodeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final lockType = StorageUtil.getString(StorageUtil.keyLockType);
    setState(() {
      _passcodeEnabled = lockType != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Passcode Settings',
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
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              // Passcode Access Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F6FF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        color: Color(0xFF3B9EFE),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Passcode Access',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          Text(
                            'Enable / Disable',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF7F8C8D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _passcodeEnabled,
                      activeTrackColor: const Color(0xFF3B9EFE),
                      onChanged: (v) async {
                        if (v) {
                          // Default to PIN if enabling
                          Get.toNamed(AppRoutes.setPin);
                        } else {
                          await StorageUtil.remove(StorageUtil.keyLockType);
                          setState(() {
                            _passcodeEnabled = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // RELATED SETTINGS Header
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 16),
                child: Text(
                  'RELATED SETTINGS',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7F8C8D),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              // Settings Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
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
                    _buildSettingsRow(
                      icon: Icons.password_rounded,
                      iconBgColor: const Color(0xFFF1F6FF),
                      iconColor: const Color(0xFF2C3E50),
                      title: 'Change Password',
                      subtitle: 'Change Passcode with providing old Password.',
                      onTap: () {
                        final lockType =
                            StorageUtil.getString(StorageUtil.keyLockType);
                        if (lockType == 'pattern') {
                          Get.toNamed(AppRoutes.setPattern);
                        } else {
                          Get.toNamed(AppRoutes.setPin);
                        }
                      },
                    ),
                    const _Divider(),
                    _buildSettingsRow(
                      icon: Icons.help_outline_rounded,
                      iconBgColor: const Color(0xFFFFF1F1),
                      iconColor: const Color(0xFFFF7675),
                      title: 'Security Questions',
                      subtitle: 'Change questions, stay secure',
                      onTap: () => Get.toNamed(AppRoutes.securityQuestion),
                    ),
                    const _Divider(),
                    _buildSettingsRow(
                      icon: Icons.lock_open_rounded,
                      iconBgColor: const Color(0xFFF1F6FF),
                      iconColor: const Color(0xFF3B9EFE),
                      title: 'Forgot Your Passcode',
                      subtitle: 'Forgot passcode? Answer to reset.',
                      onTap: () => Get.toNamed(AppRoutes.recovery),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF7F8C8D),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: const Color(0xFF7F8C8D).withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
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
      color: Colors.grey.withValues(alpha: 0.08),
      indent: 76,
      endIndent: 16,
    );
  }
}
