#!/bin/sh
set -eu

# Setup.
. $MICROBIOME_ROOT/common.sh

# Visualization
# -------------

# Now run `guppy fat` to make a phyloXML "fat tree" visualization, and run
# archaeopteryx to look at it. Note that `fat` can be run without the reference
# package specification, e.g.:
#
#     guppy fat p4z1r36.jplace
#
# but in that case there won't be any taxonomic information in the
# visualizations.
# [Here](http://matsen.fhcrc.org/pplacer/demo/p4z1r36.html)
# is an online version.
guppy fat -c $SRC/vaginal_16s.refpkg $SRC/p1z1r34.jplace -o fat.xml
aptx fat.xml

# `guppy sing` and `guppy tog` are better for visualizing small numbers of
# placements, so the input file is cut down for ease of visualization.
guppy filter -Vr -Ir 'FUM0LCO01A01..' $SRC/p1z1r34.jplace -o filtered.jplace

# `guppy sing` generates a Newick tree file with one tree in it for each
# pquery, showing the location of each placement on the tree by adding leaves
# at each attachment.
guppy sing filtered.jplace
aptx filtered.sing.tre

# `guppy tog` also generates a Newick tree file, but containing only one tree.
# Leaves are added to the tree for the attachment location of the best
# placement in each pquery.
guppy tog filtered.jplace
aptx filtered.tog.tre
