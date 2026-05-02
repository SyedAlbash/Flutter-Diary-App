#!/usr/bin/env python3
"""
Font Migration Script
Generates multi_replace_string_in_file replacements for all GoogleFonts to AppTextStyles conversions
"""

import re
import os

# Files that need updating
FILES_TO_UPDATE = [
    'lib/features/calendar/presentation/pages/calendar_page.dart',
    'lib/features/home/presentation/pages/home_page.dart',
    'lib/features/auth/presentation/pages/security_question_page.dart',
    'lib/features/auth/pin/presentation/pages/pin_pages.dart',
    'lib/features/auth/pin/presentation/pages/passcode_settings_page.dart',
    'lib/features/settings/presentation/pages/delete_date_page.dart',
    'lib/features/settings/presentation/pages/daily_reminders_page.dart',
    'lib/features/auth/pattern/presentation/pages/pattern_pages.dart',
    'lib/features/compose/presentation/pages/compose_page.dart',
    'lib/features/settings/presentation/pages/feedback_page.dart',
    'lib/features/settings/presentation/pages/themes_page.dart',
]

def extract_googlefonts_calls(content):
    """Extract all GoogleFonts.method() calls from content"""
    pattern = r'GoogleFonts\.\w+\([^)]*(?:\([^)]*\)[^)]*)*\)'
    return re.finditer(pattern, content, re.MULTILINE | re.DOTALL)

def convert_googlefonts_to_appstyles(match_text):
    """Convert GoogleFonts call to AppTextStyles"""
    # Replace GoogleFonts. with AppTextStyles.
    result = match_text.replace('GoogleFonts.', 'AppTextStyles.')
    return result

def generate_import_replacement():
    """Generate the import statement replacement"""
    old = "import 'package:google_fonts/google_fonts.dart';"
    new = "import 'package:diary_with_lock/core/theme/app_text_styles.dart';"
    return old, new

def process_file(file_path, root_dir):
    """Process a single file and return the replacements needed"""
    full_path = os.path.join(root_dir, file_path)
    
    try:
        with open(full_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return None
    
    replacements = []
    
    # Check if file imports google_fonts
    if 'import \'package:google_fonts/google_fonts.dart\';' in content:
        old_import = 'import \'package:google_fonts/google_fonts.dart\';'
        
        # Check if AppTextStyles import already exists
        if 'import \'package:diary_with_lock/core/theme/app_text_styles.dart\';' not in content:
            new_import = 'import \'package:diary_with_lock/core/theme/app_text_styles.dart\';'
            replacements.append({
                'file': file_path,
                'old': old_import,
                'new': new_import,
                'type': 'import'
            })
    
    # Find all GoogleFonts calls and replace them
    pattern = r'GoogleFonts\.(\w+)\('
    for match in re.finditer(pattern, content):
        old_call = match.group(0)  # e.g., "GoogleFonts.poppins("
        new_call = old_call.replace('GoogleFonts.', 'AppTextStyles.')  # "AppTextStyles.poppins("
        
        replacements.append({
            'file': file_path,
            'old': old_call,
            'new': new_call,
            'type': 'function_call'
        })
    
    return replacements

def main():
    root_dir = '.'
    all_replacements = []
    
    for file_path in FILES_TO_UPDATE:
        print(f"Processing {file_path}...")
        replacements = process_file(file_path, root_dir)
        if replacements:
            all_replacements.extend(replacements)
            print(f"  Found {len(replacements)} replacements")
    
    # Generate summary
    print(f"\n=== MIGRATION SUMMARY ===")
    print(f"Total files: {len(FILES_TO_UPDATE)}")
    print(f"Total replacements: {len(all_replacements)}")
    
    # Group by type
    imports = [r for r in all_replacements if r['type'] == 'import']
    calls = [r for r in all_replacements if r['type'] == 'function_call']
    
    print(f"Import replacements: {len(imports)}")
    print(f"Function call replacements: {len(calls)}")
    
    # Generate a migration checklist
    print(f"\n=== FILES TO UPDATE ===")
    files_set = set(r['file'] for r in all_replacements)
    for f in sorted(files_set):
        count = len([r for r in all_replacements if r['file'] == f])
        print(f"✓ {f} ({count} replacements)")

if __name__ == '__main__':
    main()
