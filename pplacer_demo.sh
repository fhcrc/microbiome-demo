#!/bin/bash -eu

# This is a demonstration for the use of the pplacer suite of programs. It
# covers the use of placement, visualization, classification, and comparison.
# If you are looking at this file in a web browser after processing with
# [shocco](http://rtomayko.github.com/shocco/), the left column will describe
# what is going on in the right column.
#
# It is assumed that java is available and that you have installed `pplacer`
# and `guppy`. See the [README](https://github.com/fhcrc/microbiome-demo)
# for details.


# Getting set up (for this demo)
# ------------------------------

# We start with a couple of little functions to make this script run smoothly.
# You can safely ignore them.

# For the purposes of this demo, we have a little script function `aptx` to
# run archaeopteryx from within this script (you can also open them directly
# from the archaeopteryx user interface if you prefer).
aptx() {
    java -jar bin/forester.jar -c bin/_aptx_configuration_file $1
}

# A little `pause` function to pause between steps.
pause() {
  echo "Please press return to continue..."
  read
}

# Make sure that guppy can be found.
which guppy > /dev/null 2>&1 || {
  echo "Couldn't find guppy. \
There is a download script in the bin directory for you to use."
  exit 1
}

# Echo the commands to the terminal.
set -o verbose


# Phylogenetic placement
# ----------------------

# This makes p4z1r2.json, which is a "place" file.  Place files contain
# information about collections of phylogenetic placements on a tree. You may
# notice that one of the arguments to this command is `vaginal_16s.refpkg`,
# which is a "reference package". Reference packages are simply an organized
# collection of files including a reference tree, reference alignment, and
# taxonomic information. They are optional at this point, but we have found
# them to be quite useful. The other arguments include `-r` which is our
# reference alignment, and the anonymous argument, which contains the reads to
# be placed.
pplacer -c vaginal_16s.refpkg src/p4z1r36.fasta
pause

# We haven't done the alignment in this tutorial, because that would require
# another external dependency, but there are scripts which appropriately wrap
# HMMER and Infernal in the latest version of pplacer.


# guppy
# -----

# `guppy` is our Swiss army knife for phylogenetic placements.  It has a lot of
# different subcommands, which you can learn about with online help by invoking
# the `--cmds` option.
guppy --cmds
pause


# These subcommands are used by writing out the name of the subcommand like
#
#     guppy SUBCOMMAND [options] [files]
#
# For example, we can get help for the `fat` subcommand.
guppy fat --help
pause


# Visualization
# -------------

# Now run `guppy fat` to make a phyloXML format visualization, and run
# archaeopteryx to look at it. Note that fat can be run without the reference
#
#     guppy fat p4z1r36.json
#
# but in that case there won't be any taxonomic information in the
# visualizations.
# [Here](http://matsen.fhcrc.org/pplacer/demo/p4z1r36.html)
# is an online version.
guppy fat -c vaginal_16s.refpkg p4z1r36.json
aptx p4z1r36.xml &


# Statistical comparison
# ----------------------

# `kr` is the command to calculate things using the
# [Kantorovich-Rubinstein (KR) metric](http://arxiv.org/abs/1005.1699)
# which is a generalization of UniFrac. It simply takes in .json files and
# spits out numbers. You can run it with the `--list-out` option to make
# tabular output appropriate for R or SQL.
guppy kr src/*.json
pause

# The KR metric can be thought of as the amount of work it takes to move the
# distribution of reads from one collection of samples to another along the
# edges of the tree. This can be nicely visualized by thickening the branches
# of the tree in proportion to the reads which get transported through there.
# To get such a visualization, we use guppy's `heat` subcommand. The
# reference package is included again to add in taxonomic annotation.
# [Here](http://matsen.fhcrc.org/pplacer/demo/bv.heat.html) is a version which
# compares all of the vaginosis-positive samples with the negative ones.
guppy heat -c vaginal_16s.refpkg/ src/p1z1r2.json src/p1z1r34.json 
aptx p1z1r2.p1z1r34.heat.xml &

# `guppy` can its own variant of hierarchical clustering called squash
# clustering. One nice thing about squash clustering is that you can see what
# the internal nodes of the clustering tree signify. The clustering is done
# with the `squash` subcommand, which makes a directory containing
# `cluster.tre`, which is the clustering tree, and then a subdirectory
# `mass_trees` which contain all of the mass averages for the internal nodes of
# the tree.
# [Here](http://matsen.fhcrc.org/pplacer/demo/clusters_0121.html)
# is a link to a page showing the clustering of all of the samples.
guppy squash -c vaginal_16s.refpkg -o squash_out src/*.json
aptx squash_out/mass_trees/0006.phy.fat.xml &
aptx squash_out/cluster.tre &

# `guppy` does a new kind of principal components analysis (PCA), called "edge
# PCA". Edge PCA takes the special structure of phylogenetic placement data
# into account. Consequently, it is possible to visualize the principal
# component eigenvectors, and it can find consistent differences between
# samples which may not be so far apart in the tree. The `pca.trans` file
# contains the samples projected onto principal coordinate axes.
# [Here](http://matsen.fhcrc.org/pplacer/demo/pca.html) is the version which
# comes from running all of the samples.
guppy pca -o pca -c vaginal_16s.refpkg src/*.json
cat pca.trans
aptx pca.xml &


# Classification
# --------------

# Next we run guppy's `classify` subcommand to classify the reads. The columns
# are as follows: read name, attempted rank for classification, actual rank for
# classification, taxonomic identifier, and confidence.  We use `head` here
# just to get the first 30 lines so that you can look at them.
guppy classify -c vaginal_16s.refpkg p4z1r36.json
head -n 30 p4z1r36.class.tab
pause

# The rest of the demo requires sqlite3, so we exit if that's not available.
which sqlite3 > /dev/null 2>&1 || {
  echo "No sqlite3, so stopping here."
  exit 0
}

# We can quickly explore the classification results via SQL by importing them
# into a sqlite database. To do this, we must first create a table containing
# the taxonomic names.
guppy taxtable -c vaginal_16s.refpkg | sqlite3 taxtable.db

# One can also query against the taxonomic data without needing to import the
# placements at all.
sqlite3 -header -column taxtable.db "SELECT tax_name FROM taxa WHERE rank = 'phylum'"
pause

# Now we can use SQL statements to explore the results.

# how many sequences per input file?

# What is the lineage of a specific sequence?
sqlite3 -header -column sqlite.db "
SELECT p.rank,
       tax_name,
       likelihood
FROM placements AS p
JOIN taxa USING (tax_id)
JOIN ranks USING (rank)
WHERE name ='FUM0LCO01DX37Q'
  AND p.rank = desired_rank
ORDER BY rank_order
"
pause

# ...and another, with much lower confidence in the classification result.
sqlite3 -header -column sqlite.db "
SELECT p.rank,
       tax_name,
       likelihood
FROM placements AS p
JOIN taxa USING (tax_id)
JOIN ranks USING (rank)
WHERE name ='GLKT0ZE02HFAHN'
  AND p.rank = desired_rank
ORDER BY rank_order
"
pause

# `guppy classify` can also emit .sqlite files, which can be run through
# `sqlite3` to build a database of placements, which can be correlated with the
# taxonomic data via SQL.

guppy classify --sqlite -c vaginal_16s.refpkg src/*.json
cat *.sqlite | sqlite3 taxtable.db

# And at that point, one can write SQL queries operating on placements and taxa
# using the sqlite3 database.
sqlite3 -header -column taxtable.db "
    SELECT taxa.tax_name,
           taxa.rank,
           COUNT(*) AS n_placements
    FROM   taxa
           JOIN placements USING (tax_id)
    GROUP  BY taxa.tax_name,
              taxa.rank
    ORDER  BY n_placements DESC
"
pause



