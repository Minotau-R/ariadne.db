
library(igraph)
library(stringr)

# BugSigDB v1.3.0
bugsigdb_id <- "15272273"
file_names <- fetch_zenodo_resource(bugsigdb_id)
# Filter desired file names
file_names <- file_names[str_detect(file_names, "mixed")]
file_names <- file_names[!str_detect(file_names, "metaphlan")]
# Clean and split file names
file_names <- str_remove_all(file_names, "signatures_mixed_|\\.gmt")
file_names <- str_split(file_names, "_", simplify = TRUE)
# Convert to data.frame
edge_df <- as.data.frame(file_names)
colnames(edge_df) <- c("from", "to")
# Make nodes data
node_df <- edge2node(edge_df)
# Use generic names in edges data
edge_df[] <- lapply(edge_df, function(col) node_df$name[match(col, node_df$specific)])
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(graph, "BugSigDB.gml", format = "gml")
