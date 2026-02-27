
library(igraph)
library(stringr)

# GO v2026-01-23
url <- "https://current.geneontology.org/ontology/external2go/"
# Extract all links (anchor tags)
links <- fetch_page_links(url)
file_names <- basename(links)
# Filter and split file names
file_names <- file_names[str_detect(file_names, "^[a-z0-9\\-]+2go$")]
file_names <- str_split(file_names, "2", simplify = TRUE)
# Convert to data.frame
edge_df <- as.data.frame(file_names)
colnames(edge_df) <- c("from", "to")
# Make nodes data
node_df <- edge2node(edge_df)
# Use generic names in edges data
edge_df <- apply(
    edge_df, 2L, function(col) node_df$generic[match(col, node_df$specific)]
)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = FALSE)
# Create resource
write_graph(graph, "GO.graphml", format = "graphml")
