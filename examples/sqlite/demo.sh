#!/bin/sh
set -eu

# Setup.
. $MICROBIOME_ROOT/common.sh

# Create a table containing the taxonomic names.
rm -f example.db
rppr prep_db -c $SRC/vaginal_16s.refpkg --sqlite example.db

# Explore the taxonomic table itself, without reference to placements.
sqlite3 -header -column example.db "SELECT tax_name FROM taxa WHERE rank = 'phylum'"

# `guppy classify` can build SQLite databases for easy and fast access to
# results.
guppy classify --mrca-class --sqlite example.db -c $SRC/vaginal_16s.refpkg $SRC/*.jplace

# Now we can investigate placement classifications using SQL queries. Here we
# ask for the lineage of a specific sequence.
sqlite3 -header example.db "
SELECT mc.rank,
       tax_name,
       likelihood
FROM   multiclass AS mc
       JOIN taxa USING (tax_id)
       JOIN ranks USING (rank)
WHERE  mc.want_rank = mc.rank
       AND mc.name = 'FUM0LCO01DX37Q'
ORDER  BY rank_order
"

# Here is another example, with insufficient confidence to classify
# at the species-level.
sqlite3 -header example.db "
SELECT mc.rank,
       tax_name,
       likelihood
FROM   multiclass AS mc
       JOIN taxa USING (tax_id)
       JOIN ranks USING (rank)
WHERE  mc.want_rank = mc.rank
       AND mc.name = 'FUM0LCO01A2HOA'
ORDER  BY rank_order
"
