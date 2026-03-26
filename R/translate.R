

feature.dictionary <- list(
    allergome = "Allergome",
    biocyc = "BioCyc",
    biogrid = "BioGRID",
    biomuta = "BioMuta",
    bugsig = c("bugsigdb", "BugSigDB"),
    chebi = c("ChEBI", "CHEBI"),
    chembl = "ChEMBL",
    chitars = "ChiTaRS",
    collectf = "CollecTF",
    cpd = "compound",
    disprot = "DisProt",
    drugbank = "DrugBank",
    ec = c("enzyme", "level4ec"),
    ecocyc = c("EcoCyc", "ECOCYC"),
    eggnog = "eggNOG",
    embl = "EMBL",
    ensembl = "Ensembl",
    esther = "ESTHER",
    go = "GO",
    gtop = c("GtoP", "GuidetoPHARMACOLOGY"),
    ko = "kegg",
    metacyc = c("MetaCyc", "METACYC"),
    orthodb = "OrthoDB",
    pdb = "PDB",
    peroxibase = "PeroxiBase",
    reactome = "Reactome",
    refseq = "RefSeq",
    taxid = "ncbi",
    tcdb = "TCDB",
    tigr = c("TIGRFAMS", "TIGRFAMs", "tigrfams"),
    treefam = "TreeFam",
    wbparasite = "WBParaSite"
)

#' @export
get_unique_features <- function(df){
    unique(c(as.matrix(df)))
}


#' @export
translate_features <- function(x, dict){
    x <- vapply(x, function(element) {
        matches <- vapply(dict, function(item) element %in% item, logical(1))
        if (any(matches)) {
            # return first matching list name
            names(dict)[which(matches)[1]]
        } else {
            # no match, keep original
            element
        }
    }, FUN.VALUE = character(1))
    
    x <- unname(x)
    return(x)
}

#' @export
edge2node <- function(edges){
    # Get unique features
    specific <- get_unique_features(edges[ , c("from", "to")])
    # Translate features
    generic <- translate_features(specific, feature.dictionary)
    # Build node
    nodes <- data.frame(name = generic, specific)
    return(nodes)
}
