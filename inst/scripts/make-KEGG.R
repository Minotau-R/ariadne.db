
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
node_df$generic[node_df$specific == "module"] <- "kegg_module"
# Use generic names in edges data
edge_df <- apply(
    edge_df, 2L, function(col) node_df$generic[match(col, node_df$specific)]
)
# Create resource
write_graph(edge_df, node_df, "KEGG")
