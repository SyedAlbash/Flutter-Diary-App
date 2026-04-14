import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diary_with_lock/features/home/presentation/controllers/home_controller.dart';

class PhotosPage extends StatelessWidget {
  final bool embedded;
  const PhotosPage({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
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
              child: Obx(() {
                final photos = controller.entriesForPhotos;
                if (photos.isEmpty) {
                  return _EmptyGallery();
                }
                final allImages = photos.expand((e) => e.imagePaths).toList();
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: allImages.length,
                  itemBuilder: (ctx, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(allImages[i]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
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
