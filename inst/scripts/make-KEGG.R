
library(igraph)
library(KEGGREST)

# Find available KEGG databases
dbs <- listDatabases() |>
    unique() |>
    c("network")
# Initialise edges data
edge_df <- data.frame(from = character(), to = character())
# For each source
for (from in dbs) {
    # For each target
    for (to in dbs) {
        # Try keggLink
        res <- tryCatch({
            keggLink(to, from)
            TRUE
        # Capture errors
        }, error = function(e) {
            FALSE
        })
        # Store pair if successful
        if( res ){
            edge_df <- rbind(edge_df, data.frame(from, to))
        }
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
write_graph(graph, "KEGG.gml", format = "gml")
