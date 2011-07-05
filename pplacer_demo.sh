#!/bin/bash -eu

# This is a demonstration for the use of the pplacer suite of programs. It
# covers the use of placement, visualization, classification, and comparison.
# If you are looking at this file in a web browser after processing with
# [shocco](http://rtomayko.github.com/shocco/), the left column will describe
# what is going on in the right column.
#
# It is assumed that java is available and that you have installed `pplacer`
# and `guppy`. See the [README](http://github.com/fhcrc/microbiome-demo)
# for details.
#
# **Download tutorial files:**
#
# * [zip archive](http://github.com/fhcrc/microbiome-demo/zipball/master)
# * [tar archive](http://github.com/fhcrc/microbiome-demo/tarball/master)

# Getting set up (for this demo)
# ------------------------------

# We start with a couple of little functions to make this script run smoothly.
# You can safely ignore them.

# We have a little script function `aptx` to run archaeopteryx from within this
# script (you can also open them directly from the archaeopteryx user interface
# if you prefer).
aptx() {
    java -jar bin/forester.jar -c bin/_aptx_configuration_file $1
}

# A little `pause` function to pause between steps.
pause() {
  echo "Please press return to continue..."
  read
}

# Make sure that `guppy` can be found.
which guppy > /dev/null 2>&1 || {
  echo "Couldn't find guppy. \
There is a download script in the bin directory for you to use."
  exit 1
}

# Echo the commands to the terminal.
set -o verbose


# Phylogenetic placement
# ----------------------

# This makes p4z1r2.json, which is a "place" file in JSON format.  Place files
# contain information about collections of phylogenetic placements on a tree.
# You may notice that one of the arguments to this command is
# `vaginal_16s.refpkg`, which is a "reference package". Reference packages are
# simply an organized collection of files including a reference tree, reference
# alignment, and taxonomic information. We have the beginnings of a
# [database](http://microbiome.fhcrc.org/apps/refpkg/) of reference packages
# and some [software](http://github.com/fhcrc/taxtastic) for putting them
# together.
pplacer -c vaginal_16s.refpkg src/p4z1r36.fasta
pause


# Grand Unified Phylogenetic Placement Yanalyzer (guppy)
# ------------------------------------------------------

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

# Now run `guppy fat` to make a phyloXML "fat tree" visualization, and run
# archaeopteryx to look at it. Note that `fat` can be run without the reference
# package specification, e.g.:
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
# which is a generalization of UniFrac. It simply takes in JSON placement files and
# spits the matrix of distances between the corresponding samples.
guppy kr src/*.json
pause

# The KR metric can be thought of as the amount of work it takes to move the
# distribution of reads from one collection of samples to another along the
# edges of the tree. This can be visualized by thickening the branches of the
# tree in proportion to the number of reads transported along that branch. To
# get such a visualization, we use guppy's `kr_heat` subcommand. The reference
# package is included again to add in taxonomic annotation. Red indicates
# movement towards the root and blue away from the root.
# [Here](http://matsen.fhcrc.org/pplacer/demo/bv.heat.html) is a version which
# compares all of the vaginosis-positive samples with the negative ones.
guppy kr_heat -c vaginal_16s.refpkg/ src/p1z1r2.json src/p1z1r34.json
aptx p1z1r2.p1z1r34.heat.xml &

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
guppy pca --prefix pca_out -c vaginal_16s.refpkg src/*.json
aptx pca_out.xml &

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
guppy squash -c vaginal_16s.refpkg --out-dir squash_out src/*.json
aptx squash_out/cluster.tre &

# We can look at `6.phy.fat.xml`: the mass distribution for the internal
# node number 6 in the clustering tree.
# [Here](http://matsen.fhcrc.org/pplacer/demo/squash.html)
# is an online version.
aptx squash_out/mass_trees/6.phy.fat.xml &


# Classification
# --------------

# Next we run guppy's `classify` subcommand to classify the reads. The columns
# are as follows: read name, attempted rank for classification, actual rank for
# classification, taxonomic identifier, and confidence.  We use `head` here
# just to get the first 30 lines so that you can look at them.
guppy classify -c vaginal_16s.refpkg p4z1r36.json
head -n 30 p4z1r36.class.tab
pause

# We can quickly explore the classification results via SQL by importing them
# into a SQLite3 database. We exit if SQLite3 is not available, and clean up in
# case the script is getting run for the second time.
which sqlite3 > /dev/null 2>&1 || {
  echo "No sqlite3, so stopping here."
  exit 0
}
rm -f taxtable.db

# Create a table containing the taxonomic names.
guppy taxtable -c vaginal_16s.refpkg --sqlite taxtable.db

# Explore the taxonomic table itself, without reference to placements.
sqlite3 -header -column taxtable.db "SELECT tax_name FROM taxa WHERE rank = 'phylum'"
pause

# `guppy classify` can build SQLite databases for easy and fast access to
# results.
guppy classify --sqlite taxtable.db -c vaginal_16s.refpkg src/*.json

# Now we can investigate placement classifications using SQL queries. Here we
# ask for the lineage of a specific sequence.
sqlite3 -header taxtable.db "
SELECT pc.rank,
       tax_name,
       likelihood
FROM   placement_names AS pn
       JOIN placement_classifications AS pc USING (placement_id)
       JOIN taxa USING (tax_id)
       JOIN ranks USING (rank)
WHERE  pc.rank = desired_rank
       AND pn.name = 'FUM0LCO01DX37Q'
ORDER  BY rank_order
"
pause

# Here is another example, with somewhat less confidence in the
# species-level classification result.
sqlite3 -header taxtable.db "
SELECT pc.rank,
       tax_name,
       likelihood
FROM   placement_names AS pn
       JOIN placement_classifications AS pc USING (placement_id)
       JOIN taxa USING (tax_id)
       JOIN ranks USING (rank)
WHERE  pc.rank = desired_rank
       AND pn.name = 'FUM0LCO01A2HOA'
ORDER  BY rank_order
"
pause

# That's it for the demo. For further information, please consult the
# [pplacer documentation](http://matsen.github.com/pplacer/).
echo "Thanks!"

