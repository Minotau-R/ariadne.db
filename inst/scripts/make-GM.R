
library(igraph)

# Set resource name
res.name <- "GM"
# Make edges data
edge_df <- data.frame(from = c("gbm", "gmm"), to = "ko")
# Make nodes data
node_df <- edge2node(edge_df)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(graph, paste0(res.name, ".gml"), format = "gml")
