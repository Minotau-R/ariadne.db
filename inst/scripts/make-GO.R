
library(igraph)
library(stringr)

# Set resource name
res.name <- "GO"
# Set url for GO v2026-01-23
url <- "https://current.geneontology.org/ontology/external2go/"
# Extract all links
links <- fetch_page_links(url)
file_names <- basename(links)
# Filter and split file names
file_names <- file_names[str_detect(file_names, "^[a-z0-9\\-]+2go$")]
file_names <- str_split(file_names, "2", simplify = TRUE)
# Convert to data.frame
edge_df <- as.data.frame(file_names)
colnames(edge_df) <- c("from", "to")
# Add url paths for resources
edge_df <- build_paths(edge_df, res.name, url)
# Make nodes data
node_df <- edge2node(edge_df)
# Use generic names in edges data
edge_df[ , c("from", "to")] <- lapply(
    edge_df[ , c("from", "to")],
    function(col) node_df$name[match(col, node_df$specific)]
)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(graph, paste0(res.name, ".gml"), format = "gml")
