

feature.dictionary <- list(
    chembl = "ChEMBL",
    cpd = "compound",
    ec = c("enzyme", "level4ec"),
    eggnog = "eggNOG",
    go = "GO",
    ko = "kegg",
    metacyc = "protein",
    orthodb = "OrthoDB",
    pdb = "PDB",
    reactome = "Reactome",
    refseq = "RefSeq",
    tigr = c("TIGRFAMS", "TIGRfams", "tigrfams")
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
    specific <- get_unique_features(edges)
    # Translate features
    generic <- translate_features(specific, feature.dictionary)
    # Build node
    nodes <- data.frame(specific, generic)
    return(nodes)
}
