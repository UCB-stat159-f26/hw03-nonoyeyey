parse_player_dob <- function(js_text) {
  pattern <- "\\bvar\\s+dob\\s*=\\s*([0-9]{8})\\s*;"
  parts <- regmatches(js_text, regexec(pattern, js_text, perl = TRUE))[[1]]
  if (length(parts) != 2L) stop("Could not find player birth date.", call. = FALSE)
  dob <- as.Date(parts[2], format = "%Y%m%d")
  if (is.na(dob)) stop("Invalid player birth date.", call. = FALSE)
  dob
}
