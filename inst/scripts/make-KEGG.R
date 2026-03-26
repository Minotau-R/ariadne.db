
library(igraph)
library(KEGGREST)
library(utils)

# Set resource name
res.name <- "KEGG"
# Find available pairs of KEGG databases
db_pairs <- listDatabases() |>
    unique() |>
    c("network") |>
    combn(m = 2, simplify = FALSE)
# Initialise edges data
edge_df <- data.frame(from = character(), to = character())
# For each pair of databases
for( pair in db_pairs ){
    # Try keggLink
    res <- tryCatch({
        keggLink(pair[2], pair[1])
        TRUE
        # Capture errors
        }, error = function(e) {
        FALSE
    })
    # Store pair if successful
    if( res ){
        edge_df <- rbind(edge_df, data.frame(from = pair[1], to = pair[2]))
    }
}
# Make nodes data
node_df <- edge2node(edge_df)
# Define ambiguous names
node_df$name[node_df$specific == "module"] <- "kegg_module"
# Use generic names in edges data
edge_df[] <- lapply(edge_df, function(col) node_df$name[match(col, node_df$specific)])
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(graph, paste0(res.name, ".gml"), format = "gml")
