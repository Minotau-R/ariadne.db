
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18788725.svg)](https://doi.org/10.5281/zenodo.18788725)

# ariadne.db

## Resources

ariadne database containing feature mappings for various biological databases.
Each GML* file corresponds to one source database and includes a graph:

- edges link source features (`from`) with target features (`to`) and contain
  paths to mappings when available (`url`)
- nodes list the available features with their ariadne names (`name`),
  database-specific names (`specific`) and self-generated identifiers (`id`)

*GML = Graph Modelling Language

## Usage

GML files can be imported in R using the igraph library.

```
library(igraph)

# Set url
url <- "https://zenodo.org/records/18788726/files/ChocoPhlAn.gml"

# Import resource
graph <- read_graph(url, format = "gml")
```

Alternatively, all ariadne database can be fetched via the ariadne library.

```
library(ariadne)

# Fetch resources
graph <- ariadne()

# Visualise network
plotPath(graph)
```
