#' Plot career match age differences
#'
#' @param data A data frame returned by [get_career_data()].
#' @return Draws a scatter plot and returns NULL invisibly.
#' @export
plot_career <- function(data) {
  required <- c("player_age", "age_difference", "result")
  if (!is.data.frame(data) || !all(required %in% names(data))) {
    stop("Supply a data frame from get_career_data().", call. = FALSE)
  }
  colors <- c(W = "steelblue", L = "tomato")
  keep <- is.finite(data$player_age) & is.finite(data$age_difference) &
    data$result %in% names(colors)
  if (!any(keep)) stop("No matches with ages and a win or loss to plot.", call. = FALSE)
  graphics::plot(data$player_age[keep], data$age_difference[keep],
                 col = colors[data$result[keep]], pch = 16, cex = 0.7,
                 xlab = "Player age (years)", ylab = "Age difference (years)",
                 main = "Career match age differences")
  graphics::abline(h = 0, lty = 2, col = "gray")
  graphics::legend("topleft", legend = c("Win", "Loss"),
                   col = colors, pch = 16, bty = "n")
  invisible(NULL)
}
