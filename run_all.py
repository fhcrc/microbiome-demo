#!/usr/bin/env python
import subprocess
import sys
import os

def main():
    source = os.environ.setdefault(
        'MICROBIOME_ROOT', os.path.abspath(os.path.dirname(sys.argv[0])))
    if len(sys.argv) > 1:
        source = os.path.join(source, sys.argv[1])
    for path, dirs, files in os.walk(source):
        if 'demo.sh' not in files:
            continue
        demo = os.path.join(path, 'demo.sh')
        inp = raw_input('\nRun %s ? [Y/n] ' % (demo,))
        if inp.lower().startswith('n'):
            continue
        subprocess.check_call([demo], cwd=path)

if __name__ == '__main__':
    main()
