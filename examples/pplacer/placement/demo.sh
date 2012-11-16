#!/bin/sh
set -eu

# Setup.
. $MICROBIOME_ROOT/common.sh

# Phylogenetic placement
# ----------------------

# This makes p4z1r2.jplace, which is a "place" file in JSON format.  Place files
# contain information about collections of phylogenetic placements on a tree.
# You may notice that one of the arguments to this command is
# `vaginal_16s.refpkg`, which is a "reference package". Reference packages are
# simply an organized collection of files including a reference tree, reference
# alignment, and taxonomic information. We have the beginnings of a
# [database](http://microbiome.fhcrc.org/apps/refpkg/) of reference packages
# and some [software](http://github.com/fhcrc/taxtastic) for putting them
# together.
pplacer -c $SRC/vaginal_16s.refpkg $SRC/p4z1r36.fasta
