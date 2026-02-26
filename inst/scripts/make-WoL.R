
library(stringr)

# WoL v20April2021
url <- "https://ftp.microbio.me/pub/wol-20April2021/function/"
# Fetch page links
links <- fetch_page_links(url)
# Filter out parent directory links and anchors
dirs <- links[str_detect(links, "^[a-z]+/$")]
# Initialise file names
file_names <- c()
# Search subdirectories
for (d in dirs) {
    # Fetch subdirectory links
    dir_url <- paste0(url, d)
    links <- fetch_page_links(dir_url)
    # Filter files ending with map.xz
    file_names <- c(file_names, links[str_detect(links, "map\\.xz$")])
}
# Initialise edges data
edge_df <- data.frame(from = "uniref90", to = file_names)
# Clean feature names
edge_df$to <- str_remove_all(edge_df$to, ".map.xz$")
# Remove unnecessary pairs
edge_df <- edge_df[!edge_df$to %in% c("component", "function", "process"), ]
# Make nodes data
node_df <- edge2node(edge_df)
# Define ambiguous names
node_df$generic[node_df$specific == "all"] <- "go"
node_df$generic[node_df$specific == "uniref"] <- "uniref50"
# Use generic names in edges data
edge_df <- apply(
    edge_df, 2L, function(col) node_df$generic[match(col, node_df$specific)]
)
# Create resource
write_graph(edge_df, node_df, "WoL")
