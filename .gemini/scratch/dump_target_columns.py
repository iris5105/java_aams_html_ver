import re

target_views = ['w_ja010b', 'w_ja010d', 'w_ja010e', 'w_ja010o', 'w_ja030c', 'w_shm0hj']

for v in target_views:
    fn = f'src/main/resources/templates/views/daily/{v}.html'
    with open(fn, 'r', encoding='utf-8', errors='ignore') as f:
        txt = f.read()
    
    print(f'==============================')
    print(f'VIEW: {v}')
    # find columns definition
    m = re.search(r'const columns\s*=\s*\[(.*?)\];', txt, re.DOTALL)
    if not m:
        m = re.search(r'columns:\s*\[(.*?)\]\s*,', txt, re.DOTALL)
    
    if m:
        cols_text = m.group(1)
        # extract title and field
        items = re.findall(r'\{\s*([^}]+)\s*\}', cols_text, re.DOTALL)
        for i, item in enumerate(items):
            title = re.search(r'title:\s*["\']([^"\']*)["\']', item)
            field = re.search(r'field:\s*["\']([^"\']*)["\']', item)
            t_str = title.group(1) if title else '(no title)'
            f_str = field.group(1) if field else '(no field)'
            if t_str == '' or 'search' in item.lower() or 'calendar' in item.lower() or '돋보기' in item or '달력' in item:
                print(f'  Col {i}: title="{t_str}", field="{f_str}" -> SPECIAL/EMPTY')
            else:
                print(f'  Col {i}: title="{t_str}", field="{f_str}"')
    else:
        print('  columns definition not found via regex')
