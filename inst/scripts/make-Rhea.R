
library(igraph)

# Set resource name
res.name <- "Rhea"
# List to ids
to.ids <- c(
    "chebi", "ec", "ecocyc", "go", "macie", "metacyc", "reaction", "reactome",
    "uniprotkb" 
)
# Expand first combinations
edge_df <- expand.grid(
    from = "rhea",
    to = to.ids,
    stringsAsFactors = FALSE
)
# Make nodes data
node_df <- edge2node(edge_df)
# Use generic names in edges data
edge_df[] <- lapply(edge_df, function(col) node_df$name[match(col, node_df$specific)])
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(graph, paste0(res.name, ".gml"), format = "gml")
