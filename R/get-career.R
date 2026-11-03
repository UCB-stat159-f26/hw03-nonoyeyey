read_url_text <- function(url) {
  text <- suppressWarnings(readLines(url, warn = FALSE, encoding = "UTF-8"))
  paste(text, collapse = "\n")
}

#' Retrieve a player's career match data
#'
#' @param player_name A single player name, with or without spaces.
#' @return A data frame containing match_date, tournament, surface, result,
#'   opponent, player_age, opponent_age and age_difference.
#' @details Ages use 365.2425 days per year. Missing opponent ages remain NA.
#' @export
#' @examples
#' \dontrun{
#' serena <- get_career_data("Serena Williams")
#' }
get_career_data <- function(player_name) {
  slug <- format_player_name(player_name)
  base_url <- "https://www.tennisabstract.com/jsmatches/"
  tryCatch({
    player_js <- read_url_text(paste0(base_url, slug, ".js"))
    career_js <- read_url_text(paste0(base_url, slug, "Career.js"))
    matches <- parse_career_js(career_js)
    clean_career_data(matches, parse_player_dob(player_js))
  }, error = function(e) {
    stop(sprintf("Could not get career data for '%s': %s",
                 player_name, conditionMessage(e)), call. = FALSE)
  })
}
