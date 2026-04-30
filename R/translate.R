

feature.dictionary <- list(
    agr = "AGR",
    allergome = "Allergome",
    beilstein = "Beilstein",
    biocyc = "BioCyc",
    biogrid = "BioGRID",
    biomuta = "BioMuta",
    bpdb = "BPDB",
    bugsig = c("bugsigdb", "BugSigDB"),
    cas = "CAS",
    cazy = "CAZy",
    ccds = "CCDS",
    chebi = c("ChEBI", "CHEBI"),
    chembl = "ChEMBL",
    chemspider = "Chemspider",
    chitars = "ChiTaRS",
    collectf = "CollecTF",
    complex_portal = "ComplexPortal",
    come = "COMe",
    cpd = "compound",
    cptac = "CPTAC",
    dip = "DIP",
    disprot = "DisProt",
    dmdm = "DMDM",
    dnasu = "DNASU",
    drugbank = "DrugBank",
    drugcentral = "Drug_Central",
    ec = c("enzyme", "level4ec"),
    ecmdb = "ECMDB",
    ecocyc = c("EcoCyc", "ECOCYC"),
    eggnog = "eggNOG",
    embl = "EMBL",
    ensembl = "Ensembl",
    envipath_cpd = "UM-BBD_compID",
    envipath_enzyme = "um-bbd_enzymeid",
    envipath_pathway = "um-bbd_pathwayid",
    envipath_reaction = "um-bbd_reactionid",
    esther = "ESTHER",
    foodb = "FooDB",
    geneid = c("GeneID", "ncbi-geneid"),
    genetree = "GeneTree",
    genewiki = "GeneWiki",
    genomernai = "GenomeRNAi",
    glyconnect = "GlyConnect",
    glygen = "GlyGen",
    glytoucan = "GlyTouCan",
    gmelin = "Gmelin",
    go = "GO",
    gtop = c("GtoP", "GuidetoPHARMACOLOGY"),
    hmdb = "HMDB",
    hogenom = "HOGENOM",
    ideal = "IDEAL",
    ko = "kegg",
    knapsack = "KNApSAcK",
    lincs = "LINCS",
    lipmaps_cls = "LIPID_MAPS_class",
    lipid_maps = "LIPID_MAPS_instance",
    merops = "MEROPS",
    metacyc = c("MetaCyc", "METACYC"),
    metacyc_enzrxn = "enzrxn",
    molbase = "MolBase",
    oma = "OMA",
    orthodb = "OrthoDB",
    pathcomms = "PathwayCommons",
    patric = "PATRIC",
    pdb = "PDB",
    pdb_echem = "PDBeChem",
    peroxibase = "PeroxiBase",
    phibase = "PHI-base",
    pir = "PIR",
    plant_reactome = "PlantReactome",
    pmcid = "PMCID",
    pmid = "PMID",
    ppdb = "PPDB",
    proteinid = c("ProteinID", "ncbi-proteinid"),
    proteomicsdb = "ProteomicsDB",
    pubchem = "Pubchem",
    reactome = "Reactome",
    reaxys = "Reaxys",
    rebase = "REBASE",
    refseq = "RefSeq",
    resid = "RESID",
    smid = "SMID",
    string = "STRING",
    swisslipids = "SwissLipids",
    taxid = "ncbi",
    tcdb = "TCDB",
    tigr = c("TIGRFAMS", "TIGRFAMs", "tigrfams"),
    tdp = "TopDownProteomics",
    treefam = "TreeFam",
    ucsc = "UCSC",
    unipath = "UniPathway",
    vsdb = "VSDB",
    xenbase = "Xenbase",
    wbparasite = "WBParaSite",
    webelements = "WebElements",
    wikipedia = "Wikipedia",
    ymdb = "YMDB",
    zfin = "ZFIN"
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
