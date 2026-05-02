# Font Bundle Migration Guide

## Step 1: Download Fonts ✅
Follow the instructions in `assets/fonts/README.md` to download the required fonts from Google Fonts.

## Step 2: Update Code
Replace all `GoogleFonts` calls with `AppTextStyles`:

### Example Conversions:

#### Splash Screen
```dart
// BEFORE
style: GoogleFonts.pacifico(
  fontSize: 28,
  color: Color(0xFF1A1A1A),
  fontWeight: FontWeight.bold,
)

// AFTER
style: AppTextStyles.pacifico(
  fontSize: 28,
  color: Color(0xFF1A1A1A),
  fontWeight: FontWeight.bold,
)
```

#### Body Text
```dart
// BEFORE
style: GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Colors.black,
)

// AFTER
style: AppTextStyles.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Colors.black,
)
```

#### Calendar Header
```dart
// BEFORE
style: GoogleFonts.yellowtail(
  fontSize: 20,
  color: Colors.black,
)

// AFTER
style: AppTextStyles.yellowtail(
  fontSize: 20,
  color: Colors.black,
)
```

## Step 3: Remove google_fonts Import
After all files are updated, remove:
```dart
import 'package:google_fonts/google_fonts.dart';
```

## Step 4: Add AppTextStyles Import
Add this import to files that need text styling:
```dart
import 'package:diary_with_lock/core/theme/app_text_styles.dart';
```

## Step 5: Run Pub Get
```bash
flutter pub get
```

## Expected Size Reduction
- **Before**: google_fonts adds ~7MB to Dart AOT
- **After**: Bundled fonts add ~2-3MB
- **Savings**: ~4-5 MB total APK reduction ✅

## Files Affected
These files use GoogleFonts and need to be updated:
- lib/features/splash/presentation/pages/splash_page.dart
- lib/features/compose/presentation/pages/compose_page.dart
- lib/features/calendar/presentation/pages/calendar_page.dart
- lib/features/home/presentation/pages/home_page.dart
- lib/features/auth/presentation/pages/security_question_page.dart
- lib/features/auth/pin/presentation/pages/pin_pages.dart
- lib/features/auth/pin/presentation/pages/passcode_settings_page.dart
- lib/features/settings/presentation/pages/delete_date_page.dart
- lib/features/settings/presentation/pages/daily_reminders_page.dart
- lib/features/auth/pattern/presentation/pages/pattern_pages.dart
- lib/features/settings/presentation/pages/feedback_page.dart
- lib/features/settings/presentation/pages/themes_page.dart
- Plus any other files using GoogleFonts

## Troubleshooting

If fonts don't load:
1. Ensure `.ttf` files are in `assets/fonts/`
2. Run `flutter pub get`
3. Do a clean build: `flutter clean && flutter pub get`
4. Check that pubspec.yaml has correct font paths
5. Verify font family names match exactly (case-sensitive)
