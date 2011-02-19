
build() {
  shocco $1.sh | sed -e "s#http://jashkenas.github.com/docco/resources/docco.css#src/docco.css#" > $1.html
}

build pplacer_demo
