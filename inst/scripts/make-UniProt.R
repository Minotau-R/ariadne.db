
# Define first batch of pairs
from.ids <- c("uniref50", "uniref90", "uniref100")
to.ids <- c("taxname", "taxid", "uniprotkb", "ec")
# Expand combinations
edge_df <- expand.grid(from = from.ids, to = to.ids, stringsAsFactors = FALSE)
# Define additional single pair
edge_df <- rbind(edge_df, data.frame(from = "taxname", to = "taxid"))
# Define second batch of pairs
to.ids <- c(
    "RefSeq", "PIR", "CCDS", "EMBL", "PDB", "BioGRID", "ComplexPortal", "DIP",
    "STRING", "ChEMBL", "DrugBank", "GuidetoPHARMACOLOGY", "SwissLipids",
    "Allergome", "ESTHER", "MEROPS", "PeroxiBase", "REBASE", "TCDB",
    "GlyConnect", "BioMuta", "DMDM", "CPTAC", "ProteomicsDB", "DNASU",
    "Ensembl", "GeneID", "KEGG", "PATRIC", "UCSC", "WBParaSite", "eggNOG",
    "GeneTree", "HOGENOM", "OMA", "OrthoDB", "TreeFam", "BioCyc",
    "PlantReactome", "Reactome", "UniPathway", "CollecTF", "ChiTaRS",
    "GeneWiki","GenomeRNAi", "PHI-base", "DisProt", "IDEAL"
)
# Expand combinations
edge_df <- rbind(edge_df, data.frame(from = "uniprotkb", to = to.ids))
# Make nodes data
node_df <- edge2node(edge_df)
# Use generic names in edges data
edge_df <- apply(
    edge_df, 2L, function(col) node_df$generic[match(col, node_df$specific)]
)
# Create resource
write_graph(edge_df, node_df, "UniProt")
