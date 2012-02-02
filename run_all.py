#!/usr/bin/env python
import subprocess
import sys
import os

def main():
    os.environ.setdefault('MICROBIOME_ROOT',
                          os.path.abspath(os.path.dirname(sys.argv[0])))
    for path, dirs, files in os.walk(os.environ['MICROBIOME_ROOT']):
        if 'demo.sh' not in files:
            continue
        demo = os.path.join(path, 'demo.sh')
        inp = raw_input('\nRun %s ? [Y/n] ' % (demo,))
        if inp.lower().startswith('n'):
            continue
        subprocess.check_call([demo], cwd=path)

if __name__ == '__main__':
    main()
