import os
import subprocess

orc_content = """start session
set liblist "D:\\work\\KFP\\01.AAMS\\AAMS\\kernel\\AAMS.pbl"
set application "D:\\work\\KFP\\01.AAMS\\AAMS\\kernel\\AAMS.pbl" "aams"
PBEXPORT LIBRARY "D:\\work\\KFP\\01.AAMS\\AAMS\\kernel\\SUB.pbl" "D:\\work\\java_full_auto_aams\\recource\\test" 32
end session"""

orc_file = r"D:\work\java_full_auto_aams\recource\test.orc"
os.makedirs(r"D:\work\java_full_auto_aams\recource\test", exist_ok=True)
with open(orc_file, "w", encoding="ansi") as f:
    f.write(orc_content)

orca_exe = r"C:\Program Files (x86)\Sybase\Shared\PowerBuilder\orcascr126.exe"
res = subprocess.run([orca_exe, orc_file], capture_output=True, text=True, errors="replace")
print("STDOUT:\n", res.stdout)
print("STDERR:\n", res.stderr)
