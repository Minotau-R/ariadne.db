
x2y <- rbind(
    data.frame(x = "gbm", y = c("ko", "eggnog", "tigr")),
    data.frame(x = "gmm", y = "ko")
)

# Create resource
write.table(x2y, "GM.tsv", sep = "\t", row.names = FALSE)
