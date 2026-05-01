
library(igraph)
library(stringr)

# Set resource name
res.name <- "WoL"
# Set url for WoL v2
base_url <- "https://ftp.microbio.me/pub/"
url <- paste0(base_url, "wol2/function/")
# List key dirs
dirs <- c("uniref/idmaps/", "go/uniref/")
# Initialise file names
file_names <- c()
# Search subdirectories
for( d in dirs ){
    # Fetch subdirectory links
    dir_url <- paste0(url, d)
    links <- fetch_page_links(dir_url)
    # Filter files ending with map.xz
    file_names <- c(file_names, links[str_detect(links, "map\\.xz$")])
}
# Initialise edges data
edge_df <- data.frame(from = "uniref90", to = file_names)
# Fetch metacyc directory links
links <- fetch_page_links(paste0(url, "metacyc/"))
# Filter files ending with map.xz
file_names <- links[str_detect(links, "map$")]
# Split features for metacyc bindings
file_names <- str_split(file_names, "-to-", simplify = TRUE)
# Add complex link type
file_names <- cbind(file_names)
# Add column names
colnames(file_names) <- c("from", "to")
# Combine uniref and metacyc bindings
edge_df <- rbind(edge_df, file_names)
# Clean feature names
edge_df$to <- str_remove_all(edge_df$to, "\\.map(\\.xz)?$")
# Remove unnecessary pairs
to_remove <- c(
    "Gene_Name", "component", "function", "process", "regulation", "regulator",
    "pathway", "gene_list", "gene", "go", "left_compound", "right_compound", 
    "reaction_layout", "taxonomic_range"
)
edge_df <- edge_df[!edge_df$to %in% to_remove, ]
# Add url paths for resources
url <- paste0(base_url, "{version}/")
edge_df <- build_edge_paths(edge_df, res.name, url)
# Avoid multiple specifics for some nodes
edge_df$to[edge_df$to == "BioCyc"] <- "protein"
edge_df$to[edge_df$to == "reaction_list"] <- "reaction"
# Make nodes data
node_df <- edge2node(edge_df)
# Define ambiguous names
node_df$name[node_df$specific == "all"] <- "go"
node_df$name[node_df$specific == "protein"] <- "metacyc_prt"
node_df$name[node_df$specific == "reaction"] <- "metacyc_rxn"
node_df$name[node_df$specific == "pathway"] <- "metacyc_path"
node_df$name[node_df$specific == "super_pathway"] <- "metacyc_spath"
# Use generic names in edges data
edge_df[c("from", "to")] <- lapply(
    edge_df[c("from", "to")],
    function(col) node_df$name[match(col, node_df$specific)]
)
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(
    graph, paste0(res.name, ".gml"), format = "gml", id = seq_along(graph)
)
