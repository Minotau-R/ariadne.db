
library(rvest)
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

x2y <- data.frame(x = "uniref90", y = file_names)

x2y$y <- str_remove_all(x2y$y, ".map.xz$")

x2y <- x2y[!x2y$y %in% c("component", "function", "process"), ]

x2y$y[x2y$y == "all"] <- "go"
x2y$y[x2y$y == "protein"] <- "metacyc"
x2y$y[x2y$y == "uniref"] <- "uniref50"

write.table(x2y, "WoL.tsv", sep = "\t", row.names = FALSE)
