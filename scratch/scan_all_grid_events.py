import os, glob, re

view_files = glob.glob('src/main/resources/templates/views/daily/*.html')
for vf in sorted(view_files):
    name = os.path.basename(vf)
    with open(vf, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    grids = re.findall(r'(\b\w+)\s*=\s*new Tabulator', content)
    has_setup = 'setupTabulatorRowSelection' in content
    row_clicks = re.findall(r'(\w+)\.on\([\'"]rowClick[\'"]', content)
    row_selected = re.findall(r'(\w+)\.on\([\'"]rowSelected[\'"]', content)
    print(f"=== {name} ===")
    print(f"  Grids: {grids}")
    print(f"  has setupTabulatorRowSelection: {has_setup}")
    print(f"  rowClick: {row_clicks}")
    print(f"  rowSelected: {row_selected}")
