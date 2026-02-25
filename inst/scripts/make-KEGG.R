
library(KEGGREST)

dbs <- listDatabases() |>
    translate_features(feature.dictionary) |>
    unique()

dbs <- c(dbs, "network")

x2y <- data.frame(x = character(), y = character())

for (x in dbs) {
    
    for (y in dbs) {
      
        # Try calling keggLink, capture errors
        res <- tryCatch({
            keggLink(x, y)
            TRUE
        }, error = function(e) {
            FALSE
        })
        
        if (res) {
            x2y <- rbind(x2y, data.frame(x, y))
        }
    }
}

# Create resource
write.table(x2y, "KEGG.tsv", sep = "\t", row.names = FALSE)
