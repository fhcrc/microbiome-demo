#!/bin/sh
set -eu

# Setup.
. $MICROBIOME_ROOT/common.sh

# Splitting placefiles
# --------------------

# Any guppy or rppr command that takes multiple placefiles can also be given
# both a placefile and a csv file indicating how to partition the reads in that
# placefile. The csv file must have two columns, where the first column is the
# name of the read and the second column is the name of the placefile to
# partition that read into.

# To demonstrate, the sample placefiles must first be merged together to create
# a placefile that contains all of their placements.
guppy merge $SRC/*.jplace -o merged.jplace

# With this merged placefile, the placements can be split back into their
# original groupings using a csv file.
guppy info merged.jplace:$SRC/specimen-split.csv

# This will produce the same results (though maybe in a different order) as
# invoking the same command with each placefile specified separately.
guppy info $SRC/*.jplace
