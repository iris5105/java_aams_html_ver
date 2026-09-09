import os
import glob
import re

srd_files = glob.glob('pb_recource/**/*.srd', recursive=True)
print(f'Total srd files: {len(srd_files)}')

matches = {}
for sf in srd_files:
    filename = os.path.basename(sf).lower()
    try:
        with open(sf, 'r', encoding='cp949', errors='ignore') as f:
            content = f.read()
    except Exception as e:
        continue
    
    pxx = list(set(re.findall(r'\b(p_xx_[a-zA-Z0-9_]+)\b', content, re.I)))
    pdd = list(set(re.findall(r'\b(p_dd_[a-zA-Z0-9_]+)\b', content, re.I)))
    
    if pxx or pdd:
        matches[filename] = {'path': sf, 'pxx': pxx, 'pdd': pdd}

print(f'Found {len(matches)} srd files with p_xx_ or p_dd_:')
for k in sorted(matches.keys()):
    v = matches[k]
    print(f"{k}: pxx={v['pxx']}, pdd={v['pdd']}")
