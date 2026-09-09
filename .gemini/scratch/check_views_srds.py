import os
import glob
import re

views = [
    'w_ja010a', 'w_ja010b', 'w_ja010d', 'w_ja010e', 'w_ja010f',
    'w_ja010h', 'w_ja010o', 'w_ja020n', 'w_ja030c', 'w_proposal',
    'w_shm0hj', 'w_sjt0tg', 'w_szx0se'
]

def find_srd(name):
    matches = glob.glob(f'pb_recource/**/{name}.srd', recursive=True)
    return matches

for v in views:
    print(f'=== {v} ===')
    # find srw to see exact dw dataobjects
    srw_matches = glob.glob(f'pb_recource/**/{v}.srw', recursive=True)
    dw_map = {}
    if srw_matches:
        with open(srw_matches[0], 'r', encoding='cp949', errors='ignore') as f:
            srw_txt = f.read()
        dws = re.findall(r'dataobject\s*=\s*"([^"]+)"', srw_txt, re.I)
        print(f'  SRW DataObjects: {set(dws)}')
        for dw in set(dws):
            sf = find_srd(dw)
            if sf:
                with open(sf[0], 'r', encoding='cp949', errors='ignore') as f:
                    srd_txt = f.read()
                pxx = list(set(re.findall(r'\b(p_xx_[a-zA-Z0-9_]+)\b', srd_txt, re.I)))
                pdd = list(set(re.findall(r'\b(p_dd_[a-zA-Z0-9_]+)\b', srd_txt, re.I)))
                print(f'    [{dw}.srd] pxx: {pxx}, pdd: {pdd}')
            else:
                print(f'    [{dw}.srd] Not found')
    else:
        print('  No SRW file found')
