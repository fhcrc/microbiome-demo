#!/bin/sh
set -veu

# Setup.
. $MICROBIOME_ROOT/common.sh

# Clean up previous tests.
rm -rf test *.tre *.xml *.kr *.tab *.csv *.abc
rm -rf test_* pca_* squash_* demulti_* islands_* round_* density.*
rm -f *.jplace

# Prepare some useful things.
guppy merge $SRC/*.jplace -o all.jplace
pplacer -j 4 -p -c $SRC/vaginal_16s.refpkg $SRC/p4z1r36.fasta
guppy trim all.jplace -o all-trimmed.jplace
guppy trim p4z1r36.jplace -o p4z1r36-trimmed.jplace
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

# Test `guppy fat`.
guppy fat all.jplace
guppy fat all.jplace -o all.xml
guppy fat all.jplace --prefix test_
guppy fat all.jplace --out-dir test
guppy fat all.jplace --prefix test_ --out-dir test
guppy fat --min-fat .5 all.jplace
guppy fat --min-fat 0 all.jplace
guppy fat --total-width 500 all.jplace
guppy fat --node-numbers all.jplace
guppy fat --width-factor 1 all.jplace
guppy fat $refpkg all.jplace

guppy fat $all_split
guppy fat $all_split -o all.xml
guppy fat --edpl .03 $all_split
guppy fat --average $all_split -o all.xml

guppy fat p4z1r36.jplace
guppy fat --pp p4z1r36.jplace
guppy fat --point-mass p4z1r36.jplace
guppy fat --pp --point-mass p4z1r36.jplace

guppy fat $p4z1r36_two
guppy fat $p4z1r36_four
guppy fat $p4z1r36_four -o out.xml

guppy fat all-trimmed.jplace
guppy fat $refpkg all-trimmed.jplace

# Test `guppy heat`.
#XXX: todo

# Test `guppy sing`.
guppy sing all.jplace
guppy sing all.jplace -o all.tre
guppy sing all.jplace --prefix test_
guppy sing all.jplace --out-dir test
guppy sing all.jplace --prefix test_ --out-dir test
guppy sing --node-numbers all.jplace
guppy sing --xml all.jplace
guppy sing --xml --node-numbers all.jplace
guppy sing --min-fat .5 all.jplace
guppy sing --min-fat 0 all.jplace
guppy sing --total-width 500 all.jplace
guppy sing --node-numbers all.jplace
guppy sing --width-factor 1 all.jplace

guppy sing p4z1r36.jplace
guppy sing --pp p4z1r36.jplace

guppy sing $p4z1r36_two
guppy sing $p4z1r36_four

# Test `guppy tog`.
guppy tog all.jplace
guppy tog all.jplace -o all
guppy tog all.jplace --prefix test_
guppy tog all.jplace --out-dir test
guppy tog all.jplace --prefix test_ --out-dir test
guppy tog --node-numbers all.jplace
guppy tog --xml all.jplace
guppy tog --xml --node-numbers all.jplace

guppy tog p4z1r36.jplace
guppy tog --pp p4z1r36.jplace

guppy tog $p4z1r36_two
guppy tog $p4z1r36_four

# Test `guppy bary`.
guppy bary all.jplace
guppy bary all.jplace -o all.xml
guppy bary all.jplace --prefix test_ -o all.xml
guppy bary all.jplace --out-dir test -o all.xml
guppy bary all.jplace --prefix test_ --out-dir test -o all.xml
guppy bary --node-numbers all.jplace

guppy bary $all_split
guppy bary $all_split -o all.xml

guppy bary p4z1r36.jplace
guppy bary --pp p4z1r36.jplace
guppy bary --point-mass p4z1r36.jplace
guppy bary --pp --point-mass p4z1r36.jplace

guppy bary $p4z1r36_two
guppy bary $p4z1r36_four

# Test `guppy edpl`.
guppy edpl all.jplace
guppy edpl all.jplace -o all.tab
guppy edpl all.jplace --prefix test_ -o all.tab
guppy edpl all.jplace --out-dir test -o all.tab
guppy edpl all.jplace --prefix test_ --out-dir test -o all.tab
guppy edpl --first-only all.jplace

guppy edpl p4z1r36.jplace
guppy edpl --pp p4z1r36.jplace

# Test `guppy error`.

# Test `guppy fpd`.
guppy fpd all.jplace
guppy fpd all.jplace -o all.tab
guppy fpd all.jplace --prefix test_ -o all.tab
guppy fpd all.jplace --out-dir test -o all.tab
guppy fpd all.jplace --prefix test_ --out-dir test -o all.tab
guppy fpd --include-pendant all.jplace
guppy fpd --theta 0.5 all.jplace
guppy fpd --theta 0.5 --theta 0.75 all.jplace
guppy fpd --theta 0.5,0.75 all.jplace
guppy fpd --csv all.jplace

guppy fpd $all_split

guppy fpd p4z1r36.jplace
guppy fpd --pp p4z1r36.jplace

guppy fpd $p4z1r36_two
guppy fpd $p4z1r36_four

# Test `guppy kr`.
guppy kr $all_placefiles
guppy kr $all_placefiles -o all.kr
guppy kr $all_placefiles --prefix test_ -o all.kr
guppy kr $all_placefiles --out-dir test -o all.kr
guppy kr $all_placefiles --prefix test_ --out-dir test -o all.kr
guppy kr -p .5 $all_placefiles
guppy kr -p 2 $all_placefiles
guppy kr --normalize tree-length $all_placefiles
guppy kr --list-out $all_placefiles
guppy kr -s 2 $all_placefiles
guppy kr -s 2 --seed 2 $all_placefiles
guppy kr -s 2 --density $all_placefiles
#XXX: revisit this eventually
#guppy kr -s 2 --gaussian $all_placefiles

guppy kr $all_split
guppy kr $all_split -o all.kr

guppy kr $p4z1r36_two
guppy kr $p4z1r36_four
guppy kr $refpkg $p4z1r36_four
guppy kr --pp $p4z1r36_four
guppy kr --point-mass $p4z1r36_four
guppy kr --pp --point-mass $p4z1r36_four

guppy kr $p4z1r36_two_trimmed
guppy kr $p4z1r36_four_trimmed
guppy kr $refpkg $p4z1r36_four_trimmed

# Test `guppy kr_heat`.
guppy kr_heat $two_placefiles
guppy kr_heat $two_placefiles -o all.xml
guppy kr_heat $two_placefiles --prefix test_ -o all.xml
guppy kr_heat $two_placefiles --out-dir test -o all.xml
guppy kr_heat $two_placefiles --prefix test_ --out-dir test -o all.xml
guppy kr_heat -p .5 $two_placefiles
guppy kr_heat -p 2 $two_placefiles
guppy kr_heat --min-fat .5 $two_placefiles
guppy kr_heat --min-fat 0 $two_placefiles
guppy kr_heat --total-width 500 $two_placefiles
guppy kr_heat --node-numbers $two_placefiles
guppy kr_heat --width-factor 2 $two_placefiles
guppy kr_heat --gray-black $two_placefiles
guppy kr_heat --min-width 2 $two_placefiles

guppy kr_heat $two_split
guppy kr_heat $two_split -o all.xml

guppy kr_heat $p4z1r36_two
guppy kr_heat --pp $p4z1r36_two
guppy kr_heat --point-mass $p4z1r36_two
guppy kr_heat --pp --point-mass $p4z1r36_two

guppy kr_heat $p4z1r36_two_trimmed
guppy kr_heat $refpkg $p4z1r36_two_trimmed

# Test `guppy pca`.
guppy pca --prefix pca_ $all_placefiles
guppy pca --prefix pca_ --out-dir test $all_placefiles
guppy pca --prefix pca_ --min-fat .5 $all_placefiles
guppy pca --prefix pca_ --min-fat 0 $all_placefiles
guppy pca --prefix pca_ --total-width 500 $all_placefiles
guppy pca --prefix pca_ --node-numbers $all_placefiles
guppy pca --prefix pca_ --width-factor 2 $all_placefiles
guppy pca --prefix pca_ --gray-black $all_placefiles
guppy pca --prefix pca_ --min-width 2 $all_placefiles
guppy pca --prefix pca_ --write-n 4 $all_placefiles
guppy pca --prefix pca_ --scale $all_placefiles
guppy pca --prefix pca_ --symmv $all_placefiles
guppy pca --prefix pca_ --kappa 0 $all_placefiles
guppy pca --prefix pca_ --kappa 0.5 $all_placefiles
guppy pca --prefix pca_ --kappa 1 $all_placefiles
guppy pca --prefix pca_ --rep-edges 0.3 $all_placefiles
guppy pca --prefix pca_ --rep-edges 0.5 $all_placefiles
guppy pca --prefix pca_ --epsilon 1e-4 $all_placefiles

guppy pca --prefix pca_ $all_split

guppy pca --prefix pca_ $p4z1r36_four
guppy pca --prefix pca_ --pp $p4z1r36_four
guppy pca --prefix pca_ --point-mass $p4z1r36_four
guppy pca --prefix pca_ --pp --point-mass $p4z1r36_four

guppy pca --prefix pca_ $p4z1r36_four_trimmed
guppy pca --prefix pca_ $refpkg $p4z1r36_four_trimmed

# Test `guppy rarefact`.
guppy rarefact all.jplace
guppy rarefact all.jplace -o all.tab
guppy rarefact all.jplace --prefix test_ -o all.tab
guppy rarefact all.jplace --out-dir test -o all.tab
guppy rarefact all.jplace --prefix test_ --out-dir test -o all.tab
guppy rarefact --csv all.jplace

guppy rarefact p4z1r36.jplace
guppy rarefact --pp p4z1r36.jplace

# Test `guppy splitify`.
guppy splitify all.jplace
guppy splitify all.jplace -o all.xml
guppy splitify all.jplace --prefix test_ -o all.xml
guppy splitify all.jplace --out-dir test -o all.xml
guppy splitify all.jplace --prefix test_ --out-dir test -o all.xml
guppy splitify --kappa 0 all.jplace
guppy splitify --kappa 0.5 all.jplace
guppy splitify --kappa 1 all.jplace
guppy splitify --rep-edges 0.3 all.jplace
guppy splitify --rep-edges 0.5 all.jplace
guppy splitify --epsilon 1e-4 all.jplace

guppy splitify p4z1r36.jplace
guppy splitify --pp p4z1r36.jplace
guppy splitify --point-mass p4z1r36.jplace
guppy splitify --pp --point-mass p4z1r36.jplace

# Test `guppy squash`.
guppy squash --prefix squash_ $all_placefiles
guppy squash --prefix squash_ --out-dir test $all_placefiles
guppy squash --prefix squash_ --min-fat .5 $all_placefiles
guppy squash --prefix squash_ --min-fat 0 $all_placefiles
guppy squash --prefix squash_ --total-width 500 $all_placefiles
guppy squash --prefix squash_ --node-numbers $all_placefiles
guppy squash --prefix squash_ --width-factor 2 $all_placefiles
guppy squash --prefix squash_ --seed 2 $all_placefiles
guppy squash --prefix squash_ --normalize tree-length $all_placefiles
guppy squash --prefix squash_ --bootstrap 2 $all_placefiles
guppy squash --prefix squash_ --pre-round $all_placefiles

guppy squash --prefix squash_ $all_split

guppy squash --prefix squash_ $p4z1r36_four
guppy squash --prefix squash_ $refpkg --tax-cluster unit $p4z1r36_four
guppy squash --prefix squash_ $refpkg --tax-cluster inv $p4z1r36_four
guppy squash --prefix squash_ --pp $p4z1r36_four
guppy squash --prefix squash_ --point-mass $p4z1r36_four
guppy squash --prefix squash_ --pp --point-mass $p4z1r36_four

guppy squash --prefix squash_ $p4z1r36_four_trimmed
guppy squash --prefix squash_ $refpkg $p4z1r36_four_trimmed

# `guppy classify` is tested in `tests/classification/demo.sh`.

# Test `guppy classify_rdp` and `guppy to_rdp`.
#XXX: todo (maybe?)

# Test `guppy compress`.
guppy compress --cutoff 1.75 all.jplace -o out.jplace
guppy compress --cutoff 1.75 all.jplace --prefix test_ -o out.jplace
guppy compress --cutoff 1.75 all.jplace --out-dir test -o out.jplace
guppy compress --cutoff 1.75 all.jplace --prefix test_ --out-dir test -o out.jplace
guppy compress --cutoff 1.75 --discard-below .3 all.jplace -o out.jplace

guppy compress --cutoff 1.75 p4z1r36.jplace -o out.jplace
guppy compress --cutoff 1.75 --pp p4z1r36.jplace -o out.jplace

# Test `guppy demulti`.
guppy demulti --prefix demulti_ $all_placefiles
guppy demulti --prefix demulti_ --out-dir test $all_placefiles

guppy demulti --prefix demulti_ $all_split
guppy demulti --prefix demulti_ p4z1r36.jplace
guppy demulti --prefix demulti_ $p4z1r36_two
guppy demulti --prefix demulti_ $p4z1r36_four

# Test `guppy adcl`.
guppy adcl all.jplace
guppy adcl all.jplace -o all.csv
guppy adcl all.jplace --prefix test_ -o all.csv
guppy adcl all.jplace --out-dir test -o all.csv
guppy adcl all.jplace --prefix test_ --out-dir test -o all.csv
guppy adcl --no-csv all.jplace
guppy adcl --min-distance 0.2 all.jplace
guppy adcl --max-matches 10 all.jplace
guppy adcl --no-collapse all.jplace

guppy adcl p4z1r36.jplace
guppy adcl --pp p4z1r36.jplace

# Test `guppy distmat`.
guppy distmat all.jplace >/dev/null
guppy distmat all.jplace -o all.tab
guppy distmat all.jplace --prefix test_ -o all.tab
guppy distmat all.jplace --out-dir test -o all.tab
guppy distmat all.jplace --prefix test_ --out-dir test -o all.tab

guppy distmat $all_split >/dev/null
guppy distmat $all_split -o all.tab

guppy distmat $p4z1r36_two >/dev/null
guppy distmat $p4z1r36_four >/dev/null

# Test `guppy filter`.
guppy filter all.jplace -o out.jplace
guppy filter all.jplace --prefix test_ -o out.jplace
guppy filter all.jplace --out-dir test -o out.jplace
guppy filter all.jplace --prefix test_ --out-dir test -o out.jplace
guppy filter -Vr -Ir GLKT0ZE02G all.jplace -o out.jplace
guppy filter -Vr -Ir GLKT0ZE02G -Ir GLKT0ZE02I all.jplace -o out.jplace
guppy filter -Er GLKT0ZE02G all.jplace -o out.jplace
guppy filter -Er GLKT0ZE02G -Er GLKT0ZE02I all.jplace -o out.jplace
guppy filter --mass-gt 0.5 all.jplace -o out.jplace
guppy filter --mass-le 0.5 all.jplace -o out.jplace
guppy filter --mass-gt 0.4 --mass-le 0.7 all.jplace -o out.jplace

guppy filter $refpkg -Ex 186826 p4z1r36.jplace -o out.jplace
guppy filter $refpkg -Ex 186826 -Ex 72274 p4z1r36.jplace -o out.jplace
guppy filter $refpkg -Ex 186826 --cutoff 0.5 p4z1r36.jplace -o out.jplace
guppy filter $refpkg -Vx -Ix 186826 p4z1r36.jplace -o out.jplace
guppy filter $refpkg -Vx -Ix 186826 -Ix 72274 p4z1r36.jplace -o out.jplace
guppy filter $refpkg -Vx -Ix 186826 --cutoff 0.5 p4z1r36.jplace -o out.jplace
guppy filter $refpkg --pp -Ex 186826 p4z1r36.jplace -o out.jplace

guppy filter $all_split -o out.jplace
guppy filter $p4z1r36_two -o out.jplace
guppy filter $p4z1r36_four -o out.jplace

# Test `guppy info`.
guppy info all.jplace
guppy info all.jplace -o all.tab
guppy info all.jplace --prefix test_ -o all.tab
guppy info all.jplace --out-dir test -o all.tab
guppy info all.jplace --prefix test_ --out-dir test -o all.tab
guppy info --csv all.jplace

guppy info p4z1r36.jplace
guppy info $all_split
guppy info $p4z1r36_two
guppy info $p4z1r36_four

# Test `guppy islands`.
guppy islands --prefix islands_ all.jplace
guppy islands --prefix islands_ all.jplace --out-dir test
guppy islands --prefix islands_ --discard-below 0.5 all.jplace

guppy islands --prefix islands_ p4z1r36.jplace
guppy islands --prefix islands_ --pp p4z1r36.jplace

guppy islands --prefix islands_ $all_split
guppy islands --prefix islands_ $p4z1r36_two
guppy islands --prefix islands_ $p4z1r36_four

# Test `guppy merge`.
guppy merge all.jplace -o out.jplace
guppy merge all.jplace --prefix test_ -o out.jplace
guppy merge all.jplace --out-dir test -o out.jplace
guppy merge all.jplace --prefix test_ --out-dir test -o out.jplace
guppy merge --split-csv all.csv all.jplace -o out.jplace

guppy merge $all_split -o out.jplace
guppy merge $p4z1r36_two -o out.jplace
guppy merge $p4z1r36_four -o out.jplace

# Test `guppy mft`.
guppy mft all.jplace -o out.jplace
guppy mft all.jplace --prefix test_ -o out.jplace
guppy mft all.jplace --out-dir test -o out.jplace
guppy mft all.jplace --prefix test_ --out-dir test -o out.jplace
guppy mft --transform log all.jplace -o out.jplace
guppy mft --transform unit all.jplace -o out.jplace
guppy mft --transform asinh all.jplace -o out.jplace
guppy mft --transform no_trans all.jplace -o out.jplace

guppy mft $all_split
guppy mft $all_split --unitize
guppy mft $all_split -o out.jplace
guppy mft $all_split --unitize -o out.jplace
guppy mft $p4z1r36_two
guppy mft $p4z1r36_two -o out.jplace
guppy mft $p4z1r36_four
guppy mft $p4z1r36_four -o out.jplace

# Test `guppy ograph`.
guppy ograph all.jplace -o out.abc
guppy ograph all.jplace --prefix test_ -o out.abc
guppy ograph all.jplace --out-dir test -o out.abc
guppy ograph all.jplace --prefix test_ --out-dir test -o out.abc

guppy ograph p4z1r36.jplace -o out.abc
guppy ograph --pp p4z1r36.jplace -o out.abc

# Test `guppy rarefy`.
guppy rarefy -n 5 p4z1r36.jplace -o out.jplace
guppy rarefy -n 5 p4z1r36.jplace --prefix test_ -o out.jplace
guppy rarefy -n 5 p4z1r36.jplace --out-dir test -o out.jplace
guppy rarefy -n 5 p4z1r36.jplace --prefix test_ --out-dir test -o out.jplace
guppy rarefy -n 10 p4z1r36.jplace -o out.jplace
guppy rarefy -n 5 --seed 42 p4z1r36.jplace -o out.jplace

guppy rarefy -n 5 $all_split -o out.jplace
guppy rarefy -n 5 $p4z1r36_two -o out.jplace
guppy rarefy -n 5 $p4z1r36_four -o out.jplace

# Test `guppy redup`.
#XXX: todo

# Test `guppy round`.
guppy round --prefix round_ all.jplace
guppy round --prefix round_ all.jplace --out-dir test
guppy round --prefix round_ --sig-figs 0 all.jplace
guppy round --prefix round_ --sig-figs 0 --cutoff 0.1 all.jplace
guppy round --prefix round_ --sig-figs 2 all.jplace
guppy round --prefix round_ --sig-figs 4 all.jplace
guppy round --prefix round_ --cutoff 0.1 all.jplace

guppy round --prefix round_ $all_split
guppy round --prefix round_ $p4z1r36_two
guppy round --prefix round_ $p4z1r36_four

# Test `guppy to_csv`.
guppy to_csv all.jplace >/dev/null
guppy to_csv all.jplace -o all.tab
guppy to_csv all.jplace --prefix test_ -o all.tab
guppy to_csv all.jplace --out-dir test -o all.tab
guppy to_csv all.jplace --prefix test_ --out-dir test -o all.tab
guppy to_csv --no-csv all.jplace >/dev/null

guppy to_csv p4z1r36.jplace >/dev/null
guppy to_csv $all_split >/dev/null
guppy to_csv $p4z1r36_two >/dev/null
guppy to_csv $p4z1r36_four >/dev/null

# Test `guppy to_json`.
#XXX: todo

# Test `guppy trim`.
guppy trim p4z1r36.jplace -o out.jplace
guppy trim p4z1r36.jplace --prefix test_ -o out.jplace
guppy trim p4z1r36.jplace --out-dir test -o out.jplace
guppy trim p4z1r36.jplace --prefix test_ --out-dir test -o out.jplace
guppy trim --min-path-mass 0.05 p4z1r36.jplace -o out.jplace
guppy trim --discarded discarded.tab p4z1r36.jplace -o out.jplace
guppy trim --rewrite-discarded-mass p4z1r36.jplace -o out.jplace

guppy trim $all_split -o out.jplace
guppy trim $p4z1r36_two -o out.jplace
guppy trim $p4z1r36_four -o out.jplace
guppy trim --pp $p4z1r36_four -o out.jplace
guppy trim --point-mass $p4z1r36_four -o out.jplace
guppy trim --pp --point-mass $p4z1r36_four -o out.jplace

# Test `guppy unifrac`.
guppy unifrac $all_placefiles
guppy unifrac $all_placefiles -o all.tab
guppy unifrac $all_placefiles --prefix test_ -o all.tab
guppy unifrac $all_placefiles --out-dir test -o all.tab
guppy unifrac $all_placefiles --prefix test_ --out-dir test -o all.tab
guppy unifrac --list-out $all_placefiles
guppy unifrac --csv $all_placefiles

guppy unifrac $p4z1r36_two
guppy unifrac $p4z1r36_four
guppy unifrac --pp $p4z1r36_four
guppy unifrac --point-mass $p4z1r36_four
guppy unifrac --pp --point-mass $p4z1r36_four
