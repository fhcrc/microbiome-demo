#!/bin/sh
set -eu

# Setup.
. $MICROBIOME_ROOT/common.sh

# Statistical comparison
# ----------------------

# `kr` is the command to calculate things using the
# [Kantorovich-Rubinstein (KR) metric](http://arxiv.org/abs/1005.1699)
# which is a generalization of UniFrac. It simply takes in JSON placement files and
# spits the matrix of distances between the corresponding samples.
guppy kr $SRC/*.jplace

# The KR metric can be thought of as the amount of work it takes to move the
# distribution of reads from one collection of samples to another along the
# edges of the tree. This can be visualized by thickening the branches of the
# tree in proportion to the number of reads transported along that branch. To
# get such a visualization, we use guppy's `kr_heat` subcommand. The reference
# package is included again to add in taxonomic annotation. Red indicates
# movement towards the root and blue away from the root.
# [Here](http://matsen.fhcrc.org/pplacer/demo/bv_heat.html) is a version which
# compares all of the vaginosis-positive samples with the negative ones.
guppy kr_heat -c $SRC/vaginal_16s.refpkg $SRC/p1z1r2.jplace $SRC/p1z1r34.jplace
aptx p1z1r2.p1z1r34.heat.xml

# Phylogenetic placement data has a special structure, and we have developed
# variants of classical ordination and clustering techniques, called "edge
# principal components analysis" and "squash clustering" which leverage this
# special structure. You can read more about these methods
# [in our paper](http://matsen.fhcrc.org/papers/11MatsenEvansEdgeSquash.pdf).

# ### Edge principal components analysis

# With edge principal components analysis (edge PCA), it is possible to
# visualize the principal component axes, and find differences between
# samples which may only differ in terms of read distributions on closely
# related taxa. `guppy pca` creates a tree file (here `pca_out.xml`) which
# shows the principal component axes projected onto the tree.
# [Here](http://matsen.fhcrc.org/pplacer/demo/pca.html) are the first five
# principal component axes for the full data set.
guppy pca --prefix pca_out -c $SRC/vaginal_16s.refpkg $SRC/*.jplace
aptx pca_out.xml

# The `pca_out.trans` file has the samples projected onto principal coordinate
# axes. [Here](http://fhcrc.github.com/microbiome-demo/edge_pca.svg) is the
# corresponding figure for the full data set.
cat pca_out.trans

# ### Squash clustering

# `guppy` can also do "squash clustering". Squash clustering is a type of
# hierarchical clustering that is designed for use with phylogenetic
# placements. In short, where UPGMA considers the average of distances between
# samples, squash clustering considers the distances between averages of
# samples. One nice thing about squash clustering is that you can see what the
# internal nodes of the clustering tree signify. The clustering is done with
# the `squash` subcommand, which makes a directory containing `cluster.tre`,
# which is the clustering tree, and then a subdirectory `mass_trees` which
# contain all of the mass averages for the internal nodes of the tree.
rm -rf squash_out; mkdir squash_out
guppy squash -c $SRC/vaginal_16s.refpkg --out-dir squash_out $SRC/*.jplace
aptx squash_out/cluster.tre

# We can look at `6.phy.fat.xml`: the mass distribution for the internal
# node number 6 in the clustering tree.
# [Here](http://matsen.fhcrc.org/pplacer/demo/squash.html)
# is an online version.
aptx squash_out/mass_trees/6.phy.fat.xml
