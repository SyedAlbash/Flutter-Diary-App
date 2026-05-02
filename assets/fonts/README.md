# Font Installation Guide

To complete the migration from `google_fonts` package to bundled fonts, download these fonts from [Google Fonts](https://fonts.google.com):

## Required Fonts

### 1. Poppins (Primary Font)
- Download: https://fonts.google.com/download?family=Poppins
- Extract and copy these weights to this directory:
  - `Poppins-Regular.ttf` (Weight 400)
  - `Poppins-Medium.ttf` (Weight 500)
  - `Poppins-SemiBold.ttf` (Weight 600)
  - `Poppins-Bold.ttf` (Weight 700)
  - `Poppins-Light.ttf` (Weight 300) - Optional, if used in code

### 2. Pacifico (Decorative Font - Splash Screen)
- Download: https://fonts.google.com/download?family=Pacifico
- Extract and copy: `Pacifico-Regular.ttf`

### 3. Yellowtail (Decorative Font - Calendar Header)
- Download: https://fonts.google.com/download?family=Yellowtail
- Extract and copy: `Yellowtail-Regular.ttf`

## Size Comparison

### Before (with google_fonts package):
- ~7 MB added to APK (Dart AOT)

### After (with bundled fonts):
- ~2-3 MB for font files only
- **Savings: ~4-5 MB** ✅

## Notes

- Download only the weights you actually use (Regular, Medium, SemiBold, Bold)
- Modern format (ttf) is compatible with Flutter
- Fonts are compiled into the app, not fetched at runtime
- Consider removing unused font weights for further optimization
