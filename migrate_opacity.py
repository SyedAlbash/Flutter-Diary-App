import os
import re

def migrate_opacity():
    path = 'lib'
    pattern = re.compile(r'withOpacity\((.*?)\)')
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    new_content = pattern.sub(r'withValues(alpha: \1)', content)
                    
                    if new_content != content:
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        print(f'Updated {file_path}')
                except Exception as e:
                    print(f'Error processing {file_path}: {e}')

if __name__ == '__main__':
    migrate_opacity()
