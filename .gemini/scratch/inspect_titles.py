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
    
    # search for column titles
    titles = re.findall(r'title:\s*["\']([^"\']*)["\']', html)
    fields = re.findall(r'field:\s*["\']([^"\']*)["\']', html)
    print(f'=== {v} ===')
    print(f'  Total titles count: {len(titles)}')
    empty_titles = [t for t in titles if t.strip() == '']
    print(f'  Empty titles count: {len(empty_titles)}')
    
    # check occurrences of code search modal or dynamic search
    code_search = re.findall(r'(DynamicCodeSearch|codeSearch|openCodeSearch|f_dddwctl|koscom_cd|fund_cd|cj_cd)', html, re.I)
    print(f'  Related search keywords: {set(code_search)}')
