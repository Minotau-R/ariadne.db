
# Make edges data
edge_df <- rbind(
    data.frame(from = "gbm", to = c("ko", "eggnog", "tigr")),
    data.frame(from = "gmm", to = "ko")
)
# Make nodes data
node_df <- edge2node(edge_df)
# Create resource
write_graph(edge_df, node_df, "GM")
