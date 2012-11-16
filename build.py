import collections
import subprocess
import codecs
import os

import jinja2

def main():
    env = jinja2.Environment(
        loader=jinja2.FileSystemLoader('.'),
        undefined=jinja2.StrictUndefined)
    tmpl = env.get_template('index_tmpl.html')
    contents = collections.defaultdict(list)
    for path, dirs, files in os.walk('.', topdown=False):
        meaningful = False
        if 'demo.sh' in files:
            subprocess.check_call(
                ['shocco', '-t', path, os.path.join(path, 'demo.sh')],
                stdout=open(os.path.join(path, 'index.html'), 'wb'))
            meaningful = True
        elif contents[path]:
            contents[path].sort()
            rendered = tmpl.render(title=path, subdirs=contents[path])
            with codecs.open(os.path.join(path, 'index.html'), 'wb', 'utf-8') as fobj:
                fobj.write(rendered)
            meaningful = True

        if meaningful:
            contents[os.path.dirname(path)].append(os.path.basename(path))

if __name__ == '__main__':
    main()
