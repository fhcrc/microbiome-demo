#!/bin/sh
set -eu

# Setup.
. $MICROBIOME_ROOT/common.sh

# Classification
# --------------

# Next we run guppy's `classify` subcommand to classify the reads. The columns
# are as follows: read name, attempted rank for classification, actual rank for
# classification, taxonomic identifier, and confidence.  We use `head` here
# just to get the first 30 lines so that you can look at them.
guppy classify --mrca-class -c $SRC/vaginal_16s.refpkg $SRC/p4z2r22.jplace
head -n 30 p4z2r22.class.tab
