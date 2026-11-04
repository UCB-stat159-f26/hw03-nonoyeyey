combine_career_matches <- function(player_js, career_js) {
  history <- parse_career_js(career_js)
  if (!grepl("\\bvar\\s+matchmx\\s*=", player_js, perl = TRUE)) return(history)
  recent <- parse_career_js(player_js, variable = "matchmx")
  c(history, recent)
}
