
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18788725.svg)](https://doi.org/10.5281/zenodo.18788725)

# ariadne.db

## Resources

ariadne database containing feature mappings for various biological databases.
Each graphml file corresponds to one source database and includes a graph:

- edges describe the links between source features (`from`) and target
  features (`to`)
- nodes list the available features with their ariadne names (`name`),
  database-specific names (`specific`) and self-generated identifiers (`id`)

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
