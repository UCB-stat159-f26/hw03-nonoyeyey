parse_career_js <- function(js_text, variable = "morematchmx") {
  variable <- match.arg(variable, c("morematchmx", "matchmx"))
  pattern <- paste0("(?s)\\bvar\\s+", variable,
                    "\\s*=\\s*(\\[.*?\\])\\s*(?:;|$)")
  parts <- regmatches(js_text, regexec(pattern, js_text, perl = TRUE))[[1]]
  if (length(parts) != 2L) stop("Could not parse career match data.", call. = FALSE)
  tryCatch(
    jsonlite::fromJSON(parts[2], simplifyVector = FALSE),
    error = function(e) stop("Could not parse career match data.", call. = FALSE)
  )
}
