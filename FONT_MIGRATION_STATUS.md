# Google Fonts to Bundled Fonts Migration - Complete Guide

## ✅ What's Been Done

### 1. Created AppTextStyles Utility
- **File**: `lib/core/theme/app_text_styles.dart`
- Provides `AppTextStyles` class with methods for all fonts:
  - `AppTextStyles.poppins()` - primary font
  - `AppTextStyles.pacifico()` - decorative font (splash)
  - `AppTextStyles.yellowtail()` - decorative font (calendar)
  - Plus preset styles: `body`, `heading`, `bodySmall`, etc.

### 2. Updated pubspec.yaml
- ✅ Removed: `google_fonts: ^6.1.0`
- ✅ Added: Local font declarations for Poppins, Pacifico, Yellowtail
- ✅ Configured font weights and assets

### 3. Updated Files (So Far)
- ✅ `lib/features/splash/presentation/pages/splash_page.dart`
- ✅ `lib/features/calendar/presentation/pages/calendar_page.dart` (import only)

## 📋 Remaining Work

### Step 1: Download Font Files

Go to each link and download the font files:

1. **Poppins** (https://fonts.google.com/download?family=Poppins)
   - Extract and copy to `assets/fonts/`:
     - Poppins-Regular.ttf
     - Poppins-Medium.ttf
     - Poppins-SemiBold.ttf
     - Poppins-Bold.ttf
     - Poppins-Light.ttf

2. **Pacifico** (https://fonts.google.com/download?family=Pacifico)
   - Copy: Pacifico-Regular.ttf → `assets/fonts/`

3. **Yellowtail** (https://fonts.google.com/download?family=Yellowtail)
   - Copy: Yellowtail-Regular.ttf → `assets/fonts/`

### Step 2: Update Dart Files

Replace all `GoogleFonts` calls with `AppTextStyles`:

#### Quick Pattern Changes:
```
// Before
GoogleFonts.poppins(      →  AppTextStyles.poppins(
GoogleFonts.pacifico(     →  AppTextStyles.pacifico(
GoogleFonts.yellowtail(   →  AppTextStyles.yellowtail(

// Remove this import:
import 'package:google_fonts/google_fonts.dart';

// Add this import:
import 'package:diary_with_lock/core/theme/app_text_styles.dart';
```

### Files Requiring Updates:
1. `lib/features/home/presentation/pages/home_page.dart` (13 replacements)
2. `lib/features/compose/presentation/pages/compose_page.dart` (40+ replacements)
3. `lib/features/auth/presentation/pages/security_question_page.dart` (7 replacements)
4. `lib/features/auth/pin/presentation/pages/pin_pages.dart` (8 replacements)
5. `lib/features/auth/pin/presentation/pages/passcode_settings_page.dart` (6 replacements)
6. `lib/features/settings/presentation/pages/delete_date_page.dart` (4 replacements)
7. `lib/features/settings/presentation/pages/daily_reminders_page.dart` (9 replacements)
8. `lib/features/auth/pattern/presentation/pages/pattern_pages.dart` (2 replacements)
9. `lib/features/settings/presentation/pages/feedback_page.dart` (2 replacements)
10. `lib/features/settings/presentation/pages/themes_page.dart` (Need to check)

### Step 3: Use Migration Script (Optional)

Run the migration analysis script:
```bash
python migrate_fonts.py
```

This will show you exactly how many replacements are needed in each file.

### Step 4: Run Build

After all files are updated and fonts are downloaded:
```bash
flutter clean
flutter pub get
flutter pub build apk --analyze-size --release --target-platform android-arm64
```

## 🎯 Expected Results

### Size Reduction:
- **Before**: google_fonts adds ~7 MB to Dart AOT
- **After**: Bundled fonts add ~2-3 MB
- **Savings**: ~4-5 MB total APK reduction ✅

### Build Size Breakdown:
```
Before: ~XX MB (with google_fonts)
After:  ~XX MB (with bundled fonts)
Delta:  -4-5 MB ✅
```

## ⚠️ Important Notes

1. **Font Files Must Be Downloaded**
   - The migration won't work without actual `.ttf` files
   - Download from Google Fonts only
   - Place in `assets/fonts/` directory

2. **Verify Import Statements**
   - Each file MUST import `AppTextStyles`
   - Remove `google_fonts` import
   - Use exact import path: `import 'package:diary_with_lock/core/theme/app_text_styles.dart';`

3. **Font Family Names Are Case-Sensitive**
   - `fontFamily: 'Poppins'` ✓
   - `fontFamily: 'poppins'` ✗
   - These must match `pubspec.yaml` exactly

4. **Testing**
   - Run on a device/emulator to verify fonts load
   - Check splash screen appears with Pacifico font from start
   - Calendar header should use Yellowtail

## 🔍 Troubleshooting

**Fonts not loading?**
- Verify files are in `assets/fonts/` directory
- Run `flutter clean && flutter pub get`
- Check pubspec.yaml font paths are correct
- Rebuild: `flutter pub build apk`

**Compilation errors?**
- Search for remaining `GoogleFonts.` in the codebase
- Ensure all imports are updated
- Check file paths in imports

**Size not reduced?**
- Verify google_fonts dependency was removed from pubspec
- Run `flutter pub get` to update lock file
- Rebuild app

## 📝 Summary of Files Changed

| File | Changes |
|------|---------|
| pubspec.yaml | Removed google_fonts, added font declarations |
| lib/core/theme/app_text_styles.dart | Created (NEW) |
| assets/fonts/ | Directory created (fonts need to be added) |
| splash_page.dart | ✅ Updated |
| calendar_page.dart | ⚠️ Import updated, body needs updates |
| Other 8 files | ⏳ Need updating |

## Next Steps

1. Download font files from Google Fonts
2. Place `.ttf` files in `assets/fonts/`
3. Replace remaining GoogleFonts calls (use provided patterns)
4. Add AppTextStyles imports where needed
5. Run `flutter clean && flutter pub get`
6. Test build: `flutter build apk --analyze-size --release`
7. Verify size reduction of ~4-5 MB ✅
