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
    dob <- parse_player_dob(player_js)
    matches <- combine_career_matches(player_js, career_js)
    static <- clean_career_data(matches, dob)
    profile <- read_profile_career(slug, dob)
    if (covers_static_career(profile, static)) return(profile)
    static
  }, error = function(e) {
    stop(sprintf("Could not get career data for '%s': %s",
                 player_name, conditionMessage(e)), call. = FALSE)
  })
}

read_profile_career <- function(slug, dob) {
  url <- paste0("https://www.tennisabstract.com/cgi-bin/player-classic.cgi?p=",
                utils::URLencode(slug, reserved = TRUE))
  tryCatch({
    page <- read_url_text(url)
    if (!identical(parse_player_dob(page), dob)) return(NULL)
    matches <- parse_career_js(page, variable = "matchmx")
    clean_career_data(matches, dob)
  }, error = function(e) NULL)
}

covers_static_career <- function(profile, static) {
  if (is.null(profile) || nrow(profile) < nrow(static)) return(FALSE)
  profile_dates <- profile$match_date[!is.na(profile$match_date)]
  static_dates <- static$match_date[!is.na(static$match_date)]
  if (!length(profile_dates) || !length(static_dates)) return(FALSE)
  min(profile_dates) <= min(static_dates) &&
    max(profile_dates) >= max(static_dates)
}
