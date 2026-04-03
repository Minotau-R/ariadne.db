
library(igraph)
library(stringr)

# Set resource name
res.name <- "BugSigDB"
# Set url for BugSigDB v1.3.0
url <- "https://zenodo.org/records/15272273/"
# Fetch file names from Zenodo
file_names <- fetch_zenodo_resource(basename(url))
# Filter desired file names
file_names <- file_names[str_detect(file_names, "mixed")]
file_names <- file_names[!str_detect(file_names, "metaphlan")]
# Clean and split file names
file_names <- str_remove_all(file_names, "signatures_mixed_|\\.gmt")
file_names <- str_split(file_names, "_", simplify = TRUE)
# Convert to data.frame
edge_df <- as.data.frame(file_names)
colnames(edge_df) <- c("from", "to")
# Add url paths for resources
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
write_graph(graph, paste0(res.name, ".gml"), format = "gml")
