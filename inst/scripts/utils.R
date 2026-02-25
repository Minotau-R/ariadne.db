
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


fetch_page_links <- function(url){
    
    page <- read_html(url)
    
    links <- page |>
        html_nodes("a") |>
        html_attr("href")
    
    return(links)
}


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
