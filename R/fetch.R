
# Build URL paths to resources
#' @export
build_edge_paths <- function(edges, resource, repo){
    # Prepare function factory
    .build_path <- switch(
        resource,
        BugSigDB = function(from, to, repo){
            paste0(repo, "files/bugsigdb_signatures_mixed_", to, ".gmt")
        },
        ChocoPhlAn = function(from, to, repo){
            paste0(repo, "files/map_", from, "_", to, ".txt.gz")
        },
        GM = function(from, to, repo){
            if( from == "gmm" ){
                file_name <- "GMMs.v1.07.txt"
            }else if( from == "gbm" ){
                file_name <- "GBMs.v1.0.txt"
            }
            paste0(repo, file_name)
        },
        GO = function(from, to, repo){
            paste0(repo, from, "2", to)
        },
        TIGRFAMs = function(from, to, repo){
            paste0(repo, from, "_", to, "_LINK")
        },
        WoL = function(from, to, repo){
            # Account for exceptions
            prefix <- ifelse(to == "all", "go", to)
            prefix <- ifelse(to == "ko", "kegg", prefix)
            prefix <- ifelse(to == "protein", "metacyc", prefix)
            # Create path
            paste0(repo, prefix, "/", to, ".map.xz")
        },
        function(from, to, repo) NA
    )
    # Build resource paths
    paths <- mapply(
        FUN = .build_path,
        from = edges$from,
        to = edges$to,
        MoreArgs = list(repo = repo),
        USE.NAMES = FALSE
    )
    # Add urls to edges data
    edges$url <- as.vector(paths)
    return(edges)
}


# Build URL paths to feature names
#' @export
build_node_paths <- function(nodes, resource, repo){
    # Prepare function factory
    .build_path <- switch(
        resource,
        BugSigDB = function(name, spec, repo){
            paste0(repo, "files/bugsigdb_signatures_mixed_ncbi.gmt")
        },
        GM = function(name, spec, repo){
            file_name <- switch(
                name, gmm = "GMMs.v1.07.names", gbm = "GBMs.v1.0.names", NA
            )
            paste0(repo, file_name)
        },
        function(from, to, repo) NA
    )
    # Build resource paths
    paths <- mapply(
        FUN = .build_path,
        name = nodes$name,
        spec = nodes$specific,
        MoreArgs = list(repo = repo),
        USE.NAMES = FALSE
    )
    # Add urls to nodes data
    nodes$url <- as.vector(paths)
    return(nodes)
}


#' @export
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 request req_timeout req_perform resp_check_status
#'   resp_body_string
fetch_zenodo_resource <- function(record_id) {
    # Build Zenodo URL
    url <- paste0("https://zenodo.org/api/records/", record_id)
    # Make request
    req <- request(url) |>
        req_timeout(30)
    # Get response
    resp <- req_perform(req)
    resp_check_status(resp)
    # Read json
    json_text <- resp_body_string(resp)
    data <- fromJSON(json_text, flatten = TRUE)
    # Extract file names
    files <- data$files
    file_names <- files$key
    return(file_names)
}


#' @export
#' @importFrom rvest read_html html_nodes html_attr
fetch_page_links <- function(url){
    
    page <- read_html(url)
    
    links <- page |>
        html_nodes("a") |>
        html_attr("href")
    
    return(links)
}


#' @export
#' @importFrom data.table fread
#' @importFrom httr2 request req_method req_body_form req_body_string
#'   req_headers req_perform
fetch_sparql_output <- function(query, endpoint){
    # Build request with Accept header for CSV format
    req <- request(endpoint) |>
        req_method("POST") |>
        req_body_form(query = query) |>
        req_headers(Accept = "text/csv")
    # Get response
    resp <- req_perform(req)
    # Parse CSV content into data frame
    out <- fread(text = resp_body_string(resp), header = TRUE)
    return(out)
}
