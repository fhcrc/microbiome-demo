#!/bin/sh
set -veu

# Setup.
. $MICROBIOME_ROOT/common.sh

# Clean up previous tests.
rm -rf test *.tre *.xml *.tab *.csv
rm -rf test_* prepsim_*
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
tree="$SRC/vaginal_16s.tre"

# Test `rppr check`.
rppr check $refpkg

# Test `rppr convexify`.
rppr convexify $refpkg
rppr convexify $refpkg -t discord.xml
rppr convexify $refpkg -t discord.xml --node-numbers
rppr convexify $refpkg --cut-seqs cut.csv
rppr convexify $refpkg --alternates alternates.csv
rppr convexify $refpkg --alternates alternates.csv --check-all-ranks
rppr convexify $refpkg --cutoff 3
rppr convexify $refpkg --limit-rank genus
rppr convexify $refpkg --limit-rank genus --limit-rank species
rppr convexify $refpkg --limit-rank genus,species
rppr convexify $refpkg --timing timing.csv
rppr convexify $refpkg --rooted
rppr convexify $refpkg --no-early
rppr convexify $refpkg --naive --cutoff 3

# Test `rppr infer`.
#XXX: todo

# Test `rppr info`.
rppr info $refpkg
rppr info $refpkg -o all.tab
rppr info $refpkg --prefix test_ -o all.tab
rppr info $refpkg --out-dir test -o all.tab
rppr info $refpkg --prefix test_ --out-dir test -o all.tab
rppr info $refpkg --csv

# Test `rppr pdprune`.
#XXX: todo (maybe?)

# `rppr prep_db` is tested in `tests/classification/demo.sh`.

# Test `rppr prepsim`.
rppr prepsim $refpkg --prefix prepsim_
rppr prepsim $refpkg --prefix prepsim_ --out-dir test
rppr prepsim $refpkg --prefix prepsim_ -r 186826
rppr prepsim $refpkg --prefix prepsim_ -r 186826 -r 72274
rppr prepsim $refpkg --prefix prepsim_ -r 186826,72274

# Test `rppr reclass`.
#XXX: todo

# Test `rppr ref_tree`.
rppr ref_tree $refpkg -o all.xml
rppr ref_tree $refpkg --prefix test_ -o all.xml
rppr ref_tree $refpkg --out-dir test -o all.xml
rppr ref_tree $refpkg --prefix test_ --out-dir test -o all.xml
rppr ref_tree $refpkg --node-numbers -o all.xml
rppr ref_tree $refpkg --painted -o all.xml
rppr ref_tree $refpkg --rank-colored -o all.xml

# Test `rppr reroot`.
rppr reroot $refpkg -o all.xml
rppr reroot $refpkg --prefix test_ -o all.xml
rppr reroot $refpkg --out-dir test -o all.xml
rppr reroot $refpkg --prefix test_ --out-dir test -o all.xml

# Test `rppr voronoi`.
rppr voronoi --leaves 5 p4z1r36.jplace
rppr voronoi --leaves 10 p4z1r36.jplace
rppr voronoi --leaves 5 p4z1r36.jplace -o all.csv
rppr voronoi --leaves 5 p4z1r36.jplace --prefix test_ -o all.csv
rppr voronoi --leaves 5 p4z1r36.jplace --out-dir test -o all.csv
rppr voronoi --leaves 5 p4z1r36.jplace --prefix test_ --out-dir test -o all.csv
rppr voronoi --leaves 5 p4z1r36.jplace --no-csv
rppr voronoi --leaves 5 p4z1r36.jplace -v
rppr voronoi --leaves 5 p4z1r36.jplace -t trimmed.xml
rppr voronoi --leaves 5 p4z1r36.jplace -t trimmed.xml --node-numbers
rppr voronoi --leaves 5 p4z1r36.jplace -t trimmed.xml $refpkg
rppr voronoi --leaves 50 p4z1r36.jplace --algorithm greedy
#XXX: skipping this for now because it takes way too long to run
#rppr voronoi --leaves 1 p4z1r36.jplace --algorithm force
rppr voronoi --leaves 5 p4z1r36.jplace --all-eclds-file eclds.csv
rppr voronoi --leaves 5 p4z1r36.jplace --log log.csv
rppr voronoi --leaves 5 p4z1r36.jplace --leaf-mass 0
rppr voronoi --leaves 5 p4z1r36.jplace --leaf-mass 0.5
rppr voronoi --leaves 5 p4z1r36.jplace --leaf-mass 0.75
rppr voronoi --leaves 5 p4z1r36.jplace --leaf-mass 1

rppr voronoi --leaves 5 --pp p4z1r36.jplace
rppr voronoi --leaves 5 --point-mass p4z1r36.jplace
rppr voronoi --leaves 5 --pp --point-mass p4z1r36.jplace

# Test `rppr vorotree`.
rppr vorotree --leaves 5 $tree
rppr vorotree --leaves 10 $tree
rppr vorotree --leaves 5 $tree -o all.csv
rppr vorotree --leaves 5 $tree --prefix test_ -o all.csv
rppr vorotree --leaves 5 $tree --out-dir test -o all.csv
rppr vorotree --leaves 5 $tree --prefix test_ --out-dir test -o all.csv
rppr vorotree --leaves 5 $tree --no-csv
rppr vorotree --leaves 5 $tree -v
rppr vorotree --leaves 5 $tree -t trimmed.xml
rppr vorotree --leaves 5 $tree -t trimmed.xml --node-numbers
rppr vorotree --leaves 50 $tree --algorithm greedy
rppr vorotree --leaves 5 $tree --all-eclds-file eclds.csv
rppr vorotree --leaves 5 $tree --log log.csv
rppr vorotree --leaves 5 $tree --query-seqs S001903884,S002166618,S000805616
