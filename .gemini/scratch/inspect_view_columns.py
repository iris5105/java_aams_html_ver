import os
import glob
import re

views = [
    'w_ja010a', 'w_ja010b', 'w_ja010d', 'w_ja010e', 'w_ja010f',
    'w_ja010h', 'w_ja010o', 'w_ja020n', 'w_ja030c', 'w_proposal',
    'w_shm0hj', 'w_sjt0tg', 'w_szx0se'
]

html_dir = 'src/main/resources/templates/views/daily'

for v in views:
    path = os.path.join(html_dir, f'{v}.html')
    if not os.path.exists(path):
        continue
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        html = f.read()
    
    print(f'==============================')
    print(f'VIEW: {v}')
    
    # Check if empty title columns exist
    # title: "" or title: '' or title: " "
    empty_title_cols = re.findall(r'title:\s*["\']\s*["\']', html)
    
    # Check search button occurrences
    search_btns = re.findall(r'(openCodeSearchModal|openDynamicSearch|btn-search|돋보기|fa-search)', html)
    
    # Check calendar button occurrences in grid
    cal_btns = re.findall(r'(openCalendar|btn-calendar|달력|fa-calendar)', html)
    
    print(f'  Empty title columns count: {len(empty_title_cols)}')
    print(f'  Search triggers/icons count: {len(search_btns)}')
    print(f'  Calendar triggers/icons count: {len(cal_btns)}')
    
    # Extract columns array definitions roughly
    col_blocks = re.findall(r'columns:\s*\[(.*?)\]\s*,', html, re.DOTALL)
    print(f'  Found {len(col_blocks)} Tabulator columns definitions.')
    for idx, cb in enumerate(col_blocks):
        # find title and field
        fields = re.findall(r'(?:title:\s*["\']([^"\']*)["\']\s*,\s*)?field:\s*["\']([^"\']+)["\']', cb)
        # also find columns with no field but title: ""
        all_cols = re.findall(r'\{\s*(?:title:\s*["\']([^"\']*)["\']\s*,\s*)?(?:field:\s*["\']([^"\']*)["\']\s*)?[^}]*\}', cb)
        # let's look for empty titles
        empty_in_grid = [c for c in all_cols if c[0] == '']
        print(f'    Grid #{idx+1}: total cols={len(all_cols)}, empty-title cols={len(empty_in_grid)}')
        if empty_in_grid:
            print(f'      Empty cols details: {empty_in_grid}')
