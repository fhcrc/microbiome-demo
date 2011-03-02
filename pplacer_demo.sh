#!/bin/bash -eu

# This is a demonstration for the use of the pplacer suite of programs. It
# covers the use of placement, visualization, classification, and comparison.
# If you are looking at this file in a web browser after processing with
# [shocco](http://rtomayko.github.com/shocco/), the left column will describe
# what is going on in the right column.
#
# It is assumed that java is available and that you have installed `pplacer`
# and `guppy`. See the README for details.

# For the purposes of this demo, we have a little script function `aptx` to
# run archaeopteryx from within this script (not necessary if you would rather
# just use the archaeopteryx user interface).
aptx() {
    java -jar bin/forester.jar -c bin/_aptx_configuration_file $1 
}

# A little `pause` function to pause between steps (also ignore).
pause() {
  echo "Please press return to continue..."
  read
}

# echo commands
set -o verbose

# Make sure that guppy can be found.
#which guppy > /dev/null 2>&1 || {
#  echo "Couldn't find guppy. \
#There is a download script in the bin directory for you to use."
#  exit 1
#}


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


# Visualization
# -------------

# Now run `guppy fat` to make a phyloXML format visualization, and run
# archaeopteryx to look at it. Note that fat can be run without the reference
# package specification, e.g.:
#
#     guppy fat p4z1r36.json
#
# but in that case there won't be any taxonomic information in the
# visualizations.
guppy fat -c vaginal_16s.refpkg p4z1r36.json
aptx p4z1r36.xml &


# Classification
# --------------

# Next we run guppy's `classify` subcommand to classify the reads. The columns
# are as follows: read name, attempted rank for classification, actual rank for
# classification, taxonomic identifier, and confidence.  We use `head` here
# just to get the first 30 lines so that you can look at them.
guppy classify -c vaginal_16s.refpkg p4z1r36.json
head -n 30 p4z1r36.class.tab
pause

# We can quickly explore the classification results by importing them
# into a sql database. First, we create a table containing the tax_ids
# and taxonomic names.
guppy taxtable -c vaginal_16s.refpkg | sqlite3 taxtable.db

# Next we insert placement and classification results from multiple
# files into our database.
guppy classify -c vaginal_16s.refpkg --sqlite src/*.json
cat *.sqlite | sqlite3 taxtable.db
sqlite3 -header -column taxtable.db "select * from placements limit 10"
sqlite3 -header -column taxtable.db "select * from taxa limit 10"
pause

# Now we can use sql statements to explore the results.

# how many sequences per input file?

# how many sequences were classified to the species level in each input file?

# Statistical comparison
# ----------------------

# `guppy` is our tool for comparing collections of phylogenetic placements.  It
# has a lot of different subcommands, which you can learn about with online
# help like so. (Note that the `read` in this script is just so that the shell
# will pause before spitting out the next bunch of text).
guppy --cmds
pause

# `kr` is the command to calculate things using the
# [Kantorovich-Rubinstein metric](http://arxiv.org/abs/1005.1699)
# which is a generalization of UniFrac. It simply takes in .json files and
# spits out numbers. You can run it with the `--list-out` option to make
# tabular output appropriate for R or SQL.
guppy kr src/*.json
pause

# `guppy` does a special kind of principal components analysis (PCA), called
# "edge PCA". Edge PCA takes the special structure of phylogenetic placement
# data into account. Consequently, it is possible to visualize the principal
# component eigenvectors, and it can find consistent differences between
# samples which may not be so far apart in the tree. The `pca.trans` file
# contains the samples projected onto principal coordinate axes. You can see an
# example of edge PCA in our XXX upcoming paper.
guppy pca -o pca -c vaginal_16s.refpkg src/*.json
cat pca.trans
aptx pca.xml &

# `guppy` can also cluster place files using its own variant of hierarchical
# clustering called squash clustering. One nice thing about squash clustering
# is that you can see what the internal nodes of the clustering tree signify.
# The clustering is done with the `cluster` subcommand, which makes a directory
# containing `cluster.tre`, which is the clustering tree, and then a
# subdirectory `mass_trees` which contain all of the mass averages for the
# internal nodes of the tree.
guppy cluster -c vaginal_16s.refpkg -o my_cluster src/*.json
aptx my_cluster/mass_trees/0006.phy.fat.xml my_cluster/cluster.tre

# There is also a way using guppy to collect all of these together into named
# units to ease visualization of the mass distributions corresponding to
# internal nodes of cluster trees. Here we just view one of those
# visualizations.
aptx src/clusters_0121.xml

# `guppy classify` can also emit .sqlite files, which can be run through
# `sqlite3` to build a database of placements, which can be correlated with the
# taxonomic data via SQL.
guppy classify --sqlite -c vaginal_16s.refpkg src/*.json

# `guppy taxtable` must first be used to create the schema for the database,
# and populate it with the taxonomic data from the reference package.
guppy taxtable -c vaginal_16s.refpkg | sqlite3 sqlite.db

# After that, the .sqlite files can be used to populate the database with the
# placements.
cat *.sqlite | sqlite3 sqlite.db

# And at that point, one can write SQL queries against the sqlite3 database.
sqlite3 -header -column sqlite.db "
    SELECT taxa.tax_name,
           taxa.rank,
           COUNT(*) AS n_placements
    FROM   taxa
           JOIN placements USING (tax_id)
    GROUP  BY taxa.tax_name,
              taxa.rank
    ORDER  BY n_placements
"
pause
