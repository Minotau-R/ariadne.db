
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
    str_split("_", simplify = TRUE) |>
    tolower()
# Convert to data.frame
x2y <- as.data.frame(file_names)
colnames(x2y) <- c("x", "y")
# Translate features
x2y$x <- translate_features(x2y$x, feature.dictionary)
x2y$y[x2y$y == "role"] <- "tigr_role"
# Create resource
write.table(x2y, "TIGRfams.tsv", sep = "\t", row.names = FALSE)
