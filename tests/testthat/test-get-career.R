test_that("Serena career data is retrieved using only her name", {
  career_js <- paste(readLines(test_path("fixtures", "female-career.js")),
                     collapse = "\n")
  responses <- list(
    "https://www.tennisabstract.com/jsmatches/SerenaWilliams.js" =
      "var dob=19810926;",
    "https://www.tennisabstract.com/jsmatches/SerenaWilliamsCareer.js" =
      career_js
  )
  local_mocked_bindings(read_url_text = function(url) {
    if (!url %in% names(responses)) stop("Unexpected URL: ", url)
    responses[[url]]
  })

  data <- get_career_data("serena williams")
  expect_s3_class(data, "data.frame")
  expect_equal(nrow(data), 3)
  expect_equal(data$player_age[1], 14.092007, tolerance = 1e-6)
  expect_equal(data$age_difference[1], -4.684559, tolerance = 1e-6)
})

test_that("Nadal career data uses his own birthday", {
  career_js <- paste(readLines(test_path("fixtures", "male-career.js")),
                     collapse = "\n")
  responses <- list(
    "https://www.tennisabstract.com/jsmatches/RafaelNadal.js" =
      "var dob=19860603;",
    "https://www.tennisabstract.com/jsmatches/RafaelNadalCareer.js" =
      career_js
  )
  local_mocked_bindings(read_url_text = function(url) {
    if (!url %in% names(responses)) stop("Unexpected URL: ", url)
    responses[[url]]
  })

  data <- get_career_data("Rafael Nadal")
  expect_s3_class(data, "data.frame")
  expect_equal(nrow(data), 3)
  expect_equal(data$player_age[1], 15.272045, tolerance = 1e-6)
  expect_equal(data$age_difference[1], -6.992157, tolerance = 1e-6)
})

test_that("an unavailable player gives an error containing their name", {
  local_mocked_bindings(read_url_text = function(url) {
    stop("HTTP 404: Not Found")
  })

  expect_error(get_career_data("GastonSanchez"), "GastonSanchez")
})

test_that("career data includes matches from both source files", {
  history_js <- paste(readLines(test_path("fixtures", "male-career.js")),
                      collapse = "\n")
  recent <- parse_career_js(history_js)[1]
  recent[[1]][[1]] <- "20170102"
  player_js <- paste0("var dob=19860603; var matchmx=",
                     jsonlite::toJSON(recent, auto_unbox = TRUE), ";")
  responses <- list()
  responses[["https://www.tennisabstract.com/jsmatches/RafaelNadal.js"]] <- player_js
  responses[["https://www.tennisabstract.com/jsmatches/RafaelNadalCareer.js"]] <- history_js
  local_mocked_bindings(read_url_text = function(url) {
    if (!url %in% names(responses)) stop("Unexpected URL: ", url)
    responses[[url]]
  })

  data <- get_career_data("Rafael Nadal")
  expect_equal(nrow(data), 4)
  expect_identical(max(data$match_date), as.Date("2017-01-02"))
})

test_that("a profile is preferred only when it covers the static date range", {
  history_js <- paste(readLines(test_path("fixtures", "male-career.js")),
                      collapse = "\n")
  history <- parse_career_js(history_js)
  newer <- history[1:2]
  newer[[1]][[1]] <- "20170102"
  newer[[2]][[1]] <- "20180101"
  profile_rows <- c(history, newer)

  local_mocked_bindings(read_url_text = function(url) {
    if (endsWith(url, "p=RafaelNadal")) {
      return(paste0("var dob=19860603; var matchmx=",
                    jsonlite::toJSON(profile_rows, auto_unbox = TRUE), ";"))
    }
    if (endsWith(url, "RafaelNadal.js")) return("var dob=19860603;")
    if (endsWith(url, "RafaelNadalCareer.js")) return(history_js)
    stop("Unexpected URL: ", url)
  })

  expect_equal(nrow(get_career_data("Rafael Nadal")), 5)
  profile_rows <- profile_rows[-1]
  expect_equal(nrow(get_career_data("Rafael Nadal")), 3)
})
