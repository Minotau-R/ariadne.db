
[![Zenodo](https://zenodo.org/badge/DOI/10.5281/zenodo.18788726.svg)](https://doi.org/10.5281/zenodo.18788726)

# ariadne.db

ariadne database containing feature mappings for various biological databases.
Each item corresponds to one source database and includes two files:

- `edges.tsv` describes the links between source features (`from`) and target
  features (`to`)
- `nodes.tsv` lists the available features with their database names
  (`specific`) and ariadne names (`generic`)
