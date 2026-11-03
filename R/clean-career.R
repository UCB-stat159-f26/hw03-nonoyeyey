calculate_opponent_age <- function(opponent_info, match_date) {
  is_dob <- grepl("^[0-9]{8}$", opponent_info)
  age <- rep(NA_real_, length(opponent_info))
  age[!is_dob] <- suppressWarnings(as.numeric(opponent_info[!is_dob]))
  dob <- as.Date(opponent_info[is_dob], format = "%Y%m%d")
  age[is_dob] <- as.numeric(match_date[is_dob] - dob) / 365.2425
  age
}

clean_career_data <- function(matches, player_dob) {
  field <- function(i) vapply(matches, function(x) x[[i]], character(1))
  data <- data.frame(
    match_date = as.Date(field(1), format = "%Y%m%d"),
    tournament = field(2),
    surface = field(3),
    result = field(5),
    opponent = field(12)
  )
  data$player_age <- as.numeric(data$match_date - as.Date(player_dob)) / 365.2425
  data$opponent_age <- calculate_opponent_age(field(17), data$match_date)
  data$age_difference <- data$player_age - data$opponent_age
  data
}
