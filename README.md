
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18788725.svg)](https://doi.org/10.5281/zenodo.18788725)

# ariadne.db

## Resources

ariadne database containing feature mappings for various biological databases.
Each graphml file corresponds to one source database and includes a graph:

- edges describe the links between source features (`from`) and target
  features (`to`) with self-generated unique identifiers (`id`)
- nodes list the available features with their ariadne names (`name`) and
  database-specific names (`specific`)

## Usage

graphML files can be imported in R using the igraph library.

```
library(igraph)

# Set url
url <- "https://zenodo.org/records/18788725/files/ChocoPhlAn.graphml"

# Import resource
graph <- read_graph(url, format = "graphml")
```

Alternatively, all ariadne database can be fetched via the ariadne library.

```
library(ariadne)

# Fetch resources
graph <- ariadne()

# Visualise network
plotPath(graph)
```
