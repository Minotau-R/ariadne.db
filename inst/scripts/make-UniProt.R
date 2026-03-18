
library(igraph)

# Set resource name
res.name <- "UniProt"
# Expand first combinations
edge_df <- expand.grid(
    from = c("uniref50", "uniref90", "uniref100"),
    to = c("taxname", "taxid", "uniprotkb", "enzyme"),
    stringsAsFactors = FALSE
)
# Set from ids
from.ids <- c("uniprotkb", "uniref50", "uniref90", "uniref100")
# Define additional pairs
edge_df <- rbind(
    edge_df,
    data.frame(from = "taxname", to = "taxid"),
    expand.grid(from = from.ids, to = c("enzyme", "rhea", "metacyc", "ecocyc"))
)

# Expand second combinations
edge_df <- rbind(edge_df, expand.grid(
    from = from.ids,
    to = c("RefSeq", "PIR", "CCDS", "EMBL", "PDB", "BioGRID", "ComplexPortal",
        "DIP", "STRING", "ChEMBL", "DrugBank", "GuidetoPHARMACOLOGY",
        "SwissLipids", "Allergome", "ESTHER", "MEROPS", "PeroxiBase", "REBASE",
        "TCDB", "GlyConnect", "BioMuta", "DMDM", "CPTAC", "ProteomicsDB",
        "DNASU", "Ensembl", "GeneID", "KEGG", "PATRIC", "UCSC", "WBParaSite",
        "eggNOG", "GeneTree", "HOGENOM", "OMA", "OrthoDB", "TreeFam",
        "PlantReactome", "Reactome", "UniPathway", "CollecTF", "ChiTaRS",
        "GeneWiki","GenomeRNAi", "PHI-base", "DisProt", "IDEAL")
))
# Make nodes data
node_df <- edge2node(edge_df)
# Use generic names in edges data
edge_df[] <- lapply(edge_df, function(col) node_df$name[match(col, node_df$specific)])
# Adjust specifics for special cases
node_df$specific[grepl("uniref", node_df$name, fixed = TRUE)] <- "uniref"
node_df$specific[node_df$name %in% c("metacyc", "ecocyc")] <- "BioCyc"
# Combine to graph
graph <- graph_from_data_frame(edge_df, vertices = node_df, directed = TRUE)
# Create resource
write_graph(graph, paste0(res.name, ".gml"), format = "gml")
