#!/bin/sh
set -veu

# Setup.
. $MICROBIOME_ROOT/common.sh

# Clean up previous tests.
rm -f *.jplace

# Set some useful variables.
refpkg="-c $SRC/vaginal_16s.refpkg"

# Test pplacer flags.
pplacer -j 0 $refpkg $SRC/p4z1r36.fasta
pplacer -j 4 $refpkg $SRC/p4z1r36.fasta
pplacer -p $refpkg $SRC/p4z1r36.fasta
pplacer --fig-cutoff 0.01 $refpkg $SRC/p4z1r36.fasta
pplacer --fig-cutoff 0.05 $refpkg $SRC/p4z1r36.fasta
pplacer --pretend $refpkg $SRC/p4z1r36.fasta
pplacer --timing $refpkg $SRC/p4z1r36.fasta
pplacer --check-like $refpkg $SRC/p4z1r36.fasta
pplacer --no-pre-mask $refpkg $SRC/p4z1r36.fasta
pplacer --verbosity 0 $refpkg $SRC/p4z1r36.fasta
pplacer --verbosity 2 $refpkg $SRC/p4z1r36.fasta >/dev/null
pplacer --mmap-file pplacer.mmap $refpkg $SRC/p4z1r36.fasta
pplacer --mrca-class $refpkg $SRC/p4z1r36.fasta
pplacer --fantasy 0.1 $refpkg $SRC/p4z1r36.fasta
pplacer --fantasy 0.2 $refpkg $SRC/p4z1r36.fasta

# These tests can only be run without an $ALTSRC set.
if [ "x${ALTSRC:-}" = "x" ]; then
    refpkg_tree=$(taxit rp "$SRC/vaginal_16s.refpkg" tree)
    refpkg_stats=$(taxit rp "$SRC/vaginal_16s.refpkg" tree_stats)
    pplacer -t $refpkg_tree -s $refpkg_stats $SRC/p4z1r36.fasta
fi
