import os
import glob
import re

files_to_check = [
    'src/main/resources/templates/views/daily/w_ja010b.html',
    'src/main/resources/templates/views/daily/w_ja010d.html',
    'src/main/resources/templates/views/daily/w_ja010e.html',
    'src/main/resources/templates/views/daily/w_ja010o.html',
    'src/main/resources/templates/views/daily/w_ja030c.html',
    'src/main/resources/templates/views/daily/w_shm0hj.html',
    'src/main/resources/templates/views/daily/w_sjt0tg.html'
]

print("=== Checking Modified Views ===")
for fpath in files_to_check:
    name = os.path.basename(fpath)
    with open(fpath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    empty_titles = re.findall(r'title:\s*["\']\s*["\']', content)
    addons = re.findall(r'btn-grid-addon', content)
    print(f"[{name}] Empty title cols: {len(empty_titles)}, btn-grid-addon occurrences: {len(addons)}")
