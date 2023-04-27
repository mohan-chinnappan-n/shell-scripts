import os
import sys

"""
 change_extn.py
  - changes the extension of the given file into  required extension
    - For example:
        from: xmd 
        to:  xmd-meta.xml  
- mchinnappan
"""
usage = """
-------------------------------------------------------
Usage: python3 change_extn.py <from_extn> <to_extn>

Examples: python3 change_extn.py xmd  xmd-meta.xml 
        : python3 change_extn.py xds  xds-meta.xml 
-------------------------------------------------------
"""

if len(sys.argv) < 3:
    print (f'{usage}')
    exit(0)

inext =  sys.argv[1]
outext = sys.argv[2]


for filename in os.listdir('.'):
    if filename.endswith(f'.{inext}'):
        os.rename(filename, filename[:-len(inext)] + outext)
