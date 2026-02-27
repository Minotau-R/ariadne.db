
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
