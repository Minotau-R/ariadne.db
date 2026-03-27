

feature.dictionary <- list(
    allergome = "Allergome",
    biocyc = "BioCyc",
    biogrid = "BioGRID",
    biomuta = "BioMuta",
    bugsig = c("bugsigdb", "BugSigDB"),
    ccds = "CCDS",
    chebi = c("ChEBI", "CHEBI"),
    chembl = "ChEMBL",
    chitars = "ChiTaRS",
    collectf = "CollecTF",
    complex_portal = "ComplexPortal",
    cptac = "CPTAC",
    dip = "DIP",
    disprot = "DisProt",
    dmdm = "DMDM",
    dnasu = "DNASU",
    drugbank = "DrugBank",
    ec = c("enzyme", "level4ec"),
    ecocyc = c("EcoCyc", "ECOCYC"),
    eggnog = "eggNOG",
    embl = "EMBL",
    ensembl = "Ensembl",
    esther = "ESTHER",
    geneid = c("GeneID", "ncbi-geneid"),
    genetree = "GeneTree",
    genewiki = "GeneWiki",
    genomernai = "GenomeRNAi",
    glyconnect = "GlyConnect",
    go = "GO",
    gtop = c("GtoP", "GuidetoPHARMACOLOGY"),
    hogenom = "HOGENOM",
    ideal = "IDEAL",
    ko = "kegg",
    merops = "MEROPS",
    metacyc = c("MetaCyc", "METACYC"),
    oma = "OMA",
    orthodb = "OrthoDB",
    patric = "PATRIC",
    pdb = "PDB",
    peroxibase = "PeroxiBase",
    phibase = "PHI-base",
    pir = "PIR",
    plant_reactome = "PlantReactome",
    proteinid = c("ProteinID", "ncbi-proteinid"),
    proteomicsdb = "ProteomicsDB",
    reactome = "Reactome",
    rebase = "REBASE",
    refseq = "RefSeq",
    string = "STRING",
    swisslipids = "SwissLipids",
    taxid = "ncbi",
    tcdb = "TCDB",
    tigr = c("TIGRFAMS", "TIGRFAMs", "tigrfams"),
    treefam = "TreeFam",
    ucsc = "UCSC",
    unipathway = "UniPathway",
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
