
library(igraph)
library(stringr)

# Set resource name
res.name <- "ChocoPhlAn"
# Set url for ChocoPhlAn v201901b
url <- "https://zenodo.org/records/17100034/"
# Fetch file names from Zenodo
file_names <- fetch_zenodo_resource(basename(url))
# Clean and split file names
file_names <- str_remove_all(file_names, "map_|\\.txt.*")
file_names <- str_split(file_names, "_", simplify = TRUE)
# Convert to data.frame
edge_df <- as.data.frame(file_names)
colnames(edge_df) <- c("from", "to")
# Filter name mappings
edge_df <- edge_df[!(edge_df$from == "name" | edge_df$to == "name"), ]
# Add url paths for resources
url <- paste0(dirname(url), "/{version}/")
edge_df <- build_edge_paths(edge_df, res.name, url)
# Make nodes data
node_df <- edge2node(edge_df)
# Use generic names in edges data
edge_df[c("from", "to")] <- lapply(
    edge_df[c("from", "to")],
    function(col) node_df$name[match(col, node_df$specific)]
)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(
    graph, paste0(res.name, ".gml"), format = "gml", id = seq_along(graph)
)
