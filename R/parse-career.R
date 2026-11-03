parse_career_js <- function(js_text) {
  json_text <- sub("^\\s*var\\s+morematchmx\\s*=\\s*", "", js_text, perl = TRUE)
  json_text <- sub(";\\s*$", "", json_text, perl = TRUE)
  tryCatch(
    jsonlite::fromJSON(json_text, simplifyVector = FALSE),
    error = function(e) stop("Could not parse career match data.", call. = FALSE)
  )
}
