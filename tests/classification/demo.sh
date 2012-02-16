#!/bin/sh
set -veu

# Setup.
. $MICROBIOME_ROOT/common.sh

# Clean up previous tests.
rm -rf test *.tab *.db test_*
rm -f *.jplace

# Prepare some useful things.
pplacer -j 4 -p -c $SRC/vaginal_16s.refpkg $SRC/p4z1r36.fasta
mkdir -p test

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

# Test `rppr prep_db`.
rppr prep_db $refpkg --sqlite test.db --default-cutoff 0.80 && rm test.db
rppr prep_db $refpkg --sqlite test.db --default-bayes-cutoff 2 && rm test.db
rppr prep_db $refpkg --sqlite test.db --default-multiclass-min 0.3 && rm test.db
rppr prep_db $refpkg --sqlite test.db --default-multiclass-sum 0.7 && rm test.db
rppr prep_db $refpkg --sqlite test.db --best-as-bayes && rm test.db
rppr prep_db $refpkg --sqlite test.db && rm test.db

# Test `guppy classify`.
guppy classify $refpkg p4z1r36.jplace
guppy classify $refpkg p4z1r36.jplace -o p4z1r36.tab
guppy classify $refpkg p4z1r36.jplace --prefix test_ -o p4z1r36.tab
guppy classify $refpkg p4z1r36.jplace --out-dir test -o p4z1r36.tab
guppy classify $refpkg p4z1r36.jplace --prefix test_ --out-dir test -o p4z1r36.tab
guppy classify $refpkg --csv p4z1r36.jplace
guppy classify $refpkg --pp p4z1r36.jplace

rm -f test.db && rppr prep_db $refpkg --sqlite test.db
guppy classify $refpkg --sqlite test.db p4z1r36.jplace

rm -f test.db && rppr prep_db $refpkg --sqlite test.db
guppy classify $refpkg --tax-median-identity-from $SRC/p4z1r36.fasta --sqlite test.db p4z1r36.jplace

pplacer -j 4 -p --mrca-class -c $SRC/vaginal_16s.refpkg $SRC/p4z1r36.fasta
rm -f test.db && rppr prep_db $refpkg --sqlite test.db
guppy classify $refpkg --mrca-class --sqlite test.db p4z1r36.jplace
