
library(rvest)
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
x2y <- as.data.frame(file_names)
colnames(x2y) <- c("x", "y")
# Create resource
write.table(x2y, "GO.tsv", sep = "\t", row.names = FALSE)
