import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diary_with_lock/core/theme/app_theme.dart';
import 'package:diary_with_lock/features/home/presentation/controllers/home_controller.dart';
import 'package:diary_with_lock/core/widgets/themed_background.dart';

class DeleteDatePage extends StatelessWidget {
  const DeleteDatePage({super.key});

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _DeleteWarningDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Delete Date'),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ThemedBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.delete_outline,
                              color: Colors.red, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Delete All Notes',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'This will delete all your saved diary entries,\nsettings, and media.',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showWarningDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Delete All Notes',
                            style: TextStyle(
                                fontWeight: FontWeight.w600)),
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
  }
}

class _DeleteWarningDialog extends StatelessWidget {
  const _DeleteWarningDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning illustration
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.sticky_note_2_outlined,
                      color: AppColors.primary, size: 48),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Warning !!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to delete All\nNotes?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textGrey),
            ),
            const SizedBox(height: 24),
            // Yes Sure button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final controller = Get.find<HomeController>();
                  await controller.deleteAllEntries();
                  Get.back();
                  // Show success snackbar
                  Get.snackbar(
                    'Success',
                    'All data has been deleted.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 10,
                    duration: const Duration(seconds: 3),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Yes, Sure',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 8),
            // Cancel text button
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
