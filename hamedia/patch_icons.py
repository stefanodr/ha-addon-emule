#!/usr/bin/env python3
"""Replace the four icons embedded in MiniDLNA's icons.c.

usage: patch_icons.py icons.c icons_dir
Rewrites png_sm, png_lrg, jpeg_sm and jpeg_lrg with sm.png, lrg.png,
sm.jpg and lrg.jpg found in icons_dir. Fails loudly if anything is missing.
"""
import re
import sys

src, folder = sys.argv[1], sys.argv[2]
text = open(src, encoding="latin-1").read()
files = {"png_sm": "sm.png", "png_lrg": "lrg.png", "jpeg_sm": "sm.jpg", "jpeg_lrg": "lrg.jpg"}

for var, fname in files.items():
    data = open(f"{folder}/{fname}", "rb").read()
    lines = []
    for i in range(0, len(data), 24):
        lines.append('"' + "".join("\\x%02x" % b for b in data[i:i + 24]) + '"')
    body = "\n             ".join(lines)
    pat = re.compile(r"(unsigned\s+char\s+" + var + r"\[\]\s*=\s*)(?:\"[^\"]*\"\s*)+;")
    text, n = pat.subn(lambda m: m.group(1) + body + ";", text)
    if n != 1:
        sys.exit(f"patch_icons: {var} not found in {src}")
open(src, "w", encoding="latin-1").write(text)
print("patch_icons: 4 icons replaced")
