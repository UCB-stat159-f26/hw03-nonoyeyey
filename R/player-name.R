format_player_name <- function(player_name) {
  if (!is.character(player_name) || length(player_name) != 1L ||
      is.na(player_name) || !nzchar(trimws(player_name))) {
    stop("Please provide a single non-empty player name.", call. = FALSE)
  }
  words <- strsplit(trimws(player_name), "[[:space:]]+")[[1]]
  paste0(toupper(substr(words, 1, 1)), substring(words, 2), collapse = "")
}
