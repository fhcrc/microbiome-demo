#!/bin/sh
set -veu

# Setup.
. $MICROBIOME_ROOT/common.sh

# Clean up previous tests.
rm -rf test *.tab *.db test_*
rm -f *.jplace

# Set some useful variables.
all_placefiles="$SRC/*.jplace"
all_split="all.jplace:$SRC/specimen-split.csv"
two_placefiles="$SRC/p1z1r2.jplace $SRC/p1z1r34.jplace"
two_split="all.jplace:$SRC/two-split.csv"
p4z1r36_two="p4z1r36.jplace:$SRC/p4z1r36-two.csv"
p4z1r36_four="p4z1r36.jplace:$SRC/p4z1r36-four.csv"
p4z1r36_two_trimmed="p4z1r36-trimmed.jplace:$SRC/p4z1r36-two.csv"
p4z1r36_four_trimmed="p4z1r36-trimmed.jplace:$SRC/p4z1r36-four.csv"
refpkg="-c $SRC/vaginal_16s.refpkg"
aln="$SRC/p4z1r36.fasta"

# Prepare some useful things.
pplacer -j 4 -p $refpkg $aln
mkdir -p test

# Test `rppr prep_db` and prepare a test.db skeleton.
rppr prep_db $refpkg --sqlite test-skel.db

# Test `guppy classify`.
cp test-skel.db test.db && guppy classify $refpkg --sqlite test.db p4z1r36.jplace
cp test-skel.db test.db && guppy classify $refpkg --sqlite test.db --pp p4z1r36.jplace
cp test-skel.db test.db && guppy classify $refpkg --sqlite test.db --tax-median-identity-from $aln p4z1r36.jplace
