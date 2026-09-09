import os, glob, re

view_files = glob.glob('src/main/resources/templates/views/daily/*.html')

for vf in sorted(view_files):
    name = os.path.basename(vf)
    with open(vf, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    print(f"==================== {name} ====================")
    # search for any on(...) or select or click or fetch or detail bindings
    events = re.findall(r'(\w+)\.on\([^)]+\)', content)
    setups = re.findall(r'setupTabulatorRowSelection\([^)]+\)', content)
    click_listeners = re.findall(r'addEventListener\([\'"]click[\'"].*?\)', content)
    fetches = [line.strip() for line in content.split('\n') if 'fetch(' in line or 'fetch' in line and 'function' in line]
    
    print(f"Events: {events}")
    print(f"Setups: {setups}")
    if len(fetches) > 0:
        print(f"Fetches / Fetch funcs: {fetches[:5]}")
