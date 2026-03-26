
library(igraph)

# Set resource name
res.name <- "GM"
# Set url for GM v1.0
url <- "https://github.com/omixer/omixer-rpmR/raw/refs/heads/main/inst/extdata/"
# Make edges data
edge_df <- data.frame(from = c("gbm", "gmm"), to = "ko")
# Add url paths for resources
edge_df <- build_edge_paths(edge_df, res.name, url)
# Make nodes data
node_df <- edge2node(edge_df)
# Add url paths for feature names
node_df <- build_node_paths(node_df, res.name, url)
node_df$url[node_df$name == "ko"] <- NA
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(graph, paste0(res.name, ".graphml"), format = "graphml")

