import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/features/home/presentation/controllers/home_controller.dart';
import 'package:diary_with_lock/features/compose/presentation/pages/compose_page.dart';

class PhotosPage extends StatelessWidget {
  final bool embedded;
  const PhotosPage({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(() {
      final photos = controller.entriesForPhotos;
      final bool isEmpty = photos.isEmpty;

      return Container(
        color: Colors.transparent,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title - Yellowtail font like Settings
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 16, bottom: 24),
                child: Text(
                  'Gallery',
                  style: GoogleFonts.yellowtail(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              Expanded(
                child: isEmpty ? _EmptyGallery() : _buildGallery(controller),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildGallery(HomeController controller) {
    final photos = controller.entriesForPhotos;
    final List<Map<String, dynamic>> photoItems = [];
    for (var entry in photos) {
      for (var path in entry.imagePaths) {
        photoItems.add({
          'path': path,
          'entry': entry,
        });
      }
    }

    return GridView.builder(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 8,
        bottom: 120, // Bottom padding to avoid overlap with floating navbar
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: photoItems.length,
      itemBuilder: (ctx, i) {
        final item = photoItems[i];
        final String path = item['path'];
        final entry = item['entry'];

        return GestureDetector(
          onTap: () => Get.to(() => ComposePage(entry: entry)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration of scattered photo collage
          SizedBox(
            width: 300,
            child: Image.asset(
              'assets/images/screens/Margin.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.photo_library_outlined,
                    size: 100, color: Colors.grey);
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No photos yet',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All photos in your diary will be\nshown here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF7F8C8D),
            ),
          ),
        ],
      ),
    );
  }
}
