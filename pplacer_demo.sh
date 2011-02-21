#!/bin/bash -eu
# This is a demonstration for the use of the pplacer suite of programs. It
# covers the use of placement, visualization, classification, and comparison.
# If you are looking at this file in a web browser after processing with
# [shocco](http://rtomayko.github.com/shocco/), the left column will describe
# what is going on in the right column.
#
# It is assumed that you have installed the 
# [pplacer software](http://matsen.fhcrc.org/pplacer/download.html),
# and that you have java installed. So far, the software is only compiled for
# OS X and linux. A reasonably recent laptop with 2GB of memory should be able
# to run this code just fine if you don't have too many other things open.
#
# For the purposes of this demo, we have a little script function `aptx` to
# run archaeopteryx from within this script (not necessary if you would rather
# just use the archaeopteryx user interface).
aptx() {
  java -jar bin/forester.jar -c bin/_aptx_configuration_file $1
}

# We also have a little `pause` function to pause between steps (also ignore).
pause() {
  echo "Please press return to continue..."
  read
}

# Running pplacer
# ---------------

# This makes p4z1r2.place, which is a "place" file.
# Place files contain information about collections of phylogenetic placements
# on a tree. You may notice that one of the arguments to this command is
# `vaginal_16s.refpkg`, which is a "reference package". Reference packages are
# simply an organized collection of files including a reference tree, reference
# alignment, and taxonomic information. We haven't done the alignment in this
# tutorial, because that would require another external dependency, but there
# are scripts which appropriately wrap HMMER and Infernal in the latest version
# of pplacer.
# pplacer -c vaginal_16s.refpkg -r src/refalign.p4z1r36.fasta src/p4z1r36.fasta
# pause

# Now run placeviz to make a phyloXML format visualization, and run
# archaeopteryx to look at it. Note that placeviz can be run without the
# reference package specification, e.g.:
#
#     placeviz p4z1r36.place
#
# but in that case there won't be any taxonomic information in the
# visualizations.
placeviz fat -c vaginal_16s.refpkg p4z1r36.place
aptx p4z1r36.xml

# `mokaphy` is our tool for comparing collections of phylogenetic placements.
# It has a lot of different subcommands, which you can learn about with online
# help like so. (Note that the `read` in this script is just so that the shell
# will pause before spitting out the next bunch of text).
mokaphy --cmds
pause

# `kr` is the command to calculate things using the 
# [Kantorovich-Rubinstein metric](http://arxiv.org/abs/1005.1699)
# which is a generalization of UniFrac. It simply takes in .place files and
# spits out numbers. You can run it with the `--list-out` option to make
# tabular output appropriate for R or SQL.
mokaphy kr src/*.place
pause

# `mokaphy` do a special kind of principal components analysis (PCA), called
# "edge PCA". Edge PCA takes the special structure of phylogenetic placement
# data into account. Consequently, it is possible to visualize the principal
# component eigenvectors, and it can find consistent differences between
# samples which may not be so far apart in the tree. The `pca.trans` file
# contains the samples projected onto principal coordinate axes. You can 
# see an example of edge PCA in our XXX upcoming paper.
mokaphy pca -o pca -c vaginal_16s.refpkg src/*.place
cat pca.trans
aptx pca.xml

# `mokaphy` can also cluster place files using its own variant of hierarchical
# clustering called squash clustering. One nice thing about squash clustering
# is that you can see what the internal nodes of the clustering tree signify.
# The clustering is done with the `cluster` subcommand, which makes a directory
# containing `cluster.tre`, which is the clustering tree, and then a
# subdirectory `mass_trees` which contain all of the mass averages for the
# internal nodes of the tree.
mokaphy cluster -o my_cluster src/*.place
aptx my_cluster/mass_trees/0006.phy.fat.xml my_cluster/cluster.tre 

# There is also a way using mokaphy to collect all of these together into named
# units to ease visualization of the mass distributions corresponding to
# internal nodes of cluster trees.
aptx src/clusters_0121.xml

