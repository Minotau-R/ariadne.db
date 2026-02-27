
library(igraph)

# TIGRfams v15.0
url <- "https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/"
# Extract all links (anchor tags)
links <- fetch_page_links(url)
file_names <- basename(links)
# Filter file names
file_names <- file_names[str_detect(file_names, "^[A-Z]+_[A-Z]+_LINK$")]
# Clean and split file names
file_names <- file_names |>
    str_remove_all("_LINK") |>
    str_split("_", simplify = TRUE)
# Convert to data.frame
edge_df <- as.data.frame(file_names)
colnames(edge_df) <- c("from", "to")
# Make nodes data
node_df <- edge2node(edge_df)
# Define ambiguous names
node_df$name[node_df$specific == "ROLE"] <- "tigr_role"
# Use generic names in edges data
edge_df <- apply(
    edge_df, 2L, function(col) node_df$name[match(col, node_df$specific)]
)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = FALSE)
# Create resource
write_graph(graph, "TIGRfams.gml", format = "gml")
