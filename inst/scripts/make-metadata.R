
library(dplyr)

meta <- list(
    BugSigDB = data.frame(
        SourceUrl = "https://zenodo.org/records/15272273/",
        SourceVersion = "v1.3",
        DataProvider = "BugSigDB",
        Location_Prefix = 18788725
    ),
    ChocoPhlAn = data.frame(
        SourceUrl = "https://zenodo.org/records/17100034/",
        SourceVersion = "v201901b",
        DataProvider = "bioBakery",
        Location_Prefix = 18788725
    ),
    GM = data.frame(
      SourceUrl = "https://github.com/omixer/omixer-rpmR/tree/main/inst/extdata/",
      SourceVersion = "v1",
      DataProvider = "Raes Lab",
      Location_Prefix = 18788725
    ),
    GO = data.frame(
        SourceUrl = "https://current.geneontology.org/ontology/external2go/",
        SourceVersion = "v2026-01-23+",
        DataProvider = "Gene Onthology",
        Location_Prefix = 18788725
    ),
    KEGG = data.frame(
        SourceUrl = "https://www.kegg.jp/",
        SourceVersion = "v117+",
        DataProvider = "Kyoto Encyclopedia of Genes and Genomes",
        Location_Prefix = 18788725
    ),
    OTT = data.frame(
        SourceUrl = "https://opentreeoflife.github.io/",
        SourceVersion = "v3.7+",
        DataProvider = "Open Tree Taxonomy",
        Location_Prefix = 18788725
    ),
    Rhea = data.frame(
        SourceUrl = "https://www.rhea-db.org/",
        SourceVersion = "v140+",
        DataProvider = "Swiss Institute of Bioinformatics",
        Location_Prefix = 18788725
    ),
    TIGRFAMs = data.frame(
        SourceUrl = "https://ftp.ncbi.nlm.nih.gov/hmm/TIGRFAMs/release_15.0/",
        SourceVersion = "v15",
        DataProvider = "NCBI",
        Location_Prefix = 18788725
    ),
    UniProt = data.frame(
        SourceUrl = "https://www.uniprot.org/",
        SourceVersion = "v2026_01+",
        DataProvider = "UniProt",
        Location_Prefix = 18788725
    ),
    WoL = data.frame(
        SourceUrl = "https://ftp.microbio.me/pub/wol-20April2021/",
        SourceVersion = "v20April2021",
        DataProvider = "Web of Life",
        Location_Prefix = 18788726
    ),
    WoL = data.frame(
        SourceUrl = "https://ftp.microbio.me/pub/wol2/",
        SourceVersion = "v2",
        DataProvider = "Web of Life",
        Location_Prefix = 18937991
    )
)

meta <- bind_rows(meta, .id = "id")

meta$Location_Prefix <- paste0(
    "https://zenodo.org/records/", meta$Location_Prefix, "/"
)

meta <- cbind(meta, data.frame(
    Title = paste("ariadne graph of", meta$id, meta$SourceVersion),
    Description = paste(
        "Graph of feature mappings for", meta$id, meta$SourceVersion
    ),
    BiocVersion = "3.23", Genome = NA, SourceType = "TSV", Species = NA,
    TaxonomyId = NA, Coordinate_1_based = FALSE,
    Maintainer = "Giulio Benedetti <giulio.benedetti@utu.fi>",
    RDataClass = "igraph", DispatchClass = "FilePath",
    RDataPath = paste0(meta$id, ".gml")
))

col.names <- c(
    "Title", "Description", "BiocVersion", "Genome", "SourceType", "SourceUrl",
    "SourceVersion", "Species", "TaxonomyId", "Coordinate_1_based",
    "DataProvider", "Maintainer", "RDataClass", "DispatchClass",
    "Location_Prefix", "RDataPath"
)

meta <- meta[col.names]

write.csv(meta, "metadata.csv", row.names = FALSE)

makeAnnotationHubMetadata(".")
