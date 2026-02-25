

x.ids <- c("uniref50", "uniref90", "uniref100")
y.ids <- c("taxname", "taxid", "uniprotkb", "ec")

x2y <- expand.grid(x = x.ids, y = y.ids, stringsAsFactors = FALSE)

x2y <- rbind(x2y, data.frame(x = "taxname", y = "taxid"))

y.ids <- c(
    "RefSeq", "PIR", "CCDS", "EMBL", "PDB", "BioGRID", "ComplexPortal", "DIP",
    "STRING", "ChEMBL", "DrugBank", "GuidetoPHARMACOLOGY", "SwissLipids",
    "Allergome", "ESTHER", "MEROPS", "PeroxiBase", "REBASE", "TCDB",
    "GlyConnect", "BioMuta", "DMDM", "CPTAC", "ProteomicsDB", "DNASU",
    "Ensembl", "GeneID", "KEGG", "PATRIC", "UCSC", "WBParaSite", "eggNOG",
    "GeneTree", "HOGENOM", "OMA", "OrthoDB", "TreeFam", "BioCyc",
    "PlantReactome", "Reactome", "UniPathway", "CollecTF", "ChiTaRS",
    "GeneWiki","GenomeRNAi", "PHI-base", "DisProt", "IDEAL"
)

y.ids <- translate_features(y.ids, feature.dictionary)

x2y <- rbind(x2y, data.frame(x = "uniprotkb", y = to.ids))

# Create resource
write.table(x2y, "UniProt.tsv", sep = "\t", row.names = FALSE)
