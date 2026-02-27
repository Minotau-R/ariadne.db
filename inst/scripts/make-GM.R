
library(igraph)

# Make edges data
edge_df <- rbind(
    data.frame(from = "gbm", to = c("ko", "eggnog", "tigr")),
    data.frame(from = "gmm", to = "ko")
)
# Make nodes data
node_df <- edge2node(edge_df)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = FALSE)
# Create resource
write_graph(graph, "GM.graphml", format = "graphml")
