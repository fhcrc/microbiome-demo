#!/bin/sh
set -eu

# Setup.
. $MICROBIOME_ROOT/common.sh

# Create and populate the classification database.
rm -f example.db
rppr prep_db -c $SRC/vaginal_16s.refpkg --sqlite example.db
guppy classify --mrca-class --sqlite example.db \
    -c $SRC/vaginal_16s.refpkg $SRC/*.jplace

# The normal case for multiclass is that the rank of classification is the same
# as the desired rank of classification (the `want_rank`).
sqlite3 -header -line example.db "
SELECT tax_name,
       rank,
       likelihood
FROM   multiclass
       JOIN taxa USING (tax_id, rank)
WHERE  want_rank = 'species'
       AND name = 'FUM0LCO01A0001'
"

# However, it is possible to get a rank of classification higher than the
# desired rank.
sqlite3 -header -line example.db "
SELECT tax_name,
       want_rank,
       rank,
       likelihood
FROM   multiclass
       JOIN taxa USING (tax_id, rank)
WHERE  want_rank = 'species'
       AND placement_id = '5'
"

# In this particular case, there is insufficient bayes evidence at the species
# rank. Bayes factor filtering will filter out any classifications which are at
# ranks below the most specific rank with a `bayes_factor` value below a
# particular cutoff (specified by `--bayes-cutoff`). The default `bayes_factor`
# cutoff is 1.
sqlite3 -header -line -nullvalue NULL example.db "
SELECT rank,
       evidence,
       bayes_factor
FROM   placement_evidence
WHERE  placement_id = '5'
       AND rank IN ('family', 'genus', 'species')
"

# It's also possible that there are multiple classifications for a sequence at
# a particular rank. These are shown because there is sufficient bayes evidence
# at the species rank. Classifications which have a likelihood of below a
# particular value (specified by `--multiclass-min`) are still filtered out.
# The default minimum likelihood value is 0.2.
sqlite3 -header -line example.db "
SELECT tax_name,
       rank,
       likelihood
FROM   multiclass
       JOIN taxa USING (tax_id, rank)
WHERE  want_rank = 'species'
       AND name = 'FUM0LCO01A584X'
"
