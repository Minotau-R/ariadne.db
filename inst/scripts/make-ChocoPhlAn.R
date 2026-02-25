library(httr2)
library(jsonlite)
library(stringr)

# ChocoPhlAn v201901b
chocophlan_id <- "17100034"
file_names <- fetch_zenodo_resource(chocophlan_id)
# Clean and split file names
file_names <- str_remove_all(file_names, "map_|\\.txt.*")
file_names <- str_split(file_names, "_", simplify = TRUE)
# Convert to data.frame
x2y <- as.data.frame(file_names)
colnames(x2y) <- c("x", "y")
# Filter name mappings
x2y <- x2y[!(x2y$x == "name" | x2y$y == "name"), ]
# Write resource
write.table(x2y, "ChocoPhlAn.tsv", sep = "\t", row.names = FALSE)
