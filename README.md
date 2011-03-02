# Phylogenetic placement workflow demonstration files

## Introduction

This is a collection of files used to demonstrate the use of a phylogenetic
placement-based workflow. It can be used on the linux or OS X platforms, and
for windows users it works great on the 
[QIIME virtual box](http://qiime.sourceforge.net/install/virtual_box.html).
A reasonably recent laptop with 2GB of memory should be able to run this code
just fine if you don't have too many other things open.


## Setup

This demo can be downloaded
[here](http://github.com/fhcrc/microbiome-demo/zipball/master). 
You will need to download pplacer as well. There is a `download.sh` script in
the bin directory which will get it, or you can visit the 
[download page](http://matsen.fhcrc.org/pplacer/download.html).

You will then need to put pplacer in your 
[path](http://www.linuxheadquarters.com/howto/basic/path.shtml).


### [SQLite](http://www.sqlite.org/)

[SQLite3](http://www.sqlite.org/) is only necessary for one part of the demo.
It is already installed on recent OS X macs. If you want to install it on an
Debian/Ubuntu system (e.g. the QIIME virtual box) just run an

    sudo apt-get install sqlite3

QIIME users: the password is `qiime`. 


## Running

Simply execute the script `pplacer_demo.sh`. This script was meant to be read,
and `pplacer_demo.html` is a marked up version of it. You can also read it
[online](http://fhcrc.github.com/microbiome-demo/).


## Authors

Noah Hoffman, Aaron Gallagher and Erick Matsen.


## Acknowledgements

We would like to thank Martin Morgan, Sujatha Srinivasan and David Fredricks for their work in making this possible.
