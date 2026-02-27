
library(igraph)
library(stringr)

# ChocoPhlAn v201901b
chocophlan_id <- "17100034"
file_names <- fetch_zenodo_resource(chocophlan_id)
# Clean and split file names
file_names <- str_remove_all(file_names, "map_|\\.txt.*")
file_names <- str_split(file_names, "_", simplify = TRUE)
# Convert to data.frame
edge_df <- as.data.frame(file_names)
colnames(edge_df) <- c("from", "to")
# Filter name mappings
edge_df <- edge_df[!(edge_df$from == "name" | edge_df$to == "name"), ]
# Make nodes data
node_df <- edge2node(edge_df)
# Use generic names in edges data
edge_df <- apply(
    edge_df, 2L, function(col) node_df$generic[match(col, node_df$specific)]
)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = FALSE)
# Create resource
write_graph(graph, "ChocoPhlAn.graphml", format = "graphml")
