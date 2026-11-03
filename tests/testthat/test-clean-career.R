test_that("female match dates and birthdays produce correct ages", {
  js <- paste(readLines(test_path("fixtures", "female-career.js")),
              collapse = "\n")
  matches <- parse_career_js(js)
  data <- clean_career_data(matches, "1981-09-26")

  expect_s3_class(data, "data.frame")
  expect_equal(nrow(data), 3)
  expect_s3_class(data$match_date, "Date")
  expect_equal(data$player_age[1], 14.092007, tolerance = 1e-6)
  expect_equal(data$opponent_age[1], 18.776566, tolerance = 1e-6)
  expect_equal(data$age_difference[1], -4.684559, tolerance = 1e-6)
  expect_identical(data$result, c("L", "L", "L"))
})

test_that("male opponent ages are used directly", {
  js <- paste(readLines(test_path("fixtures", "male-career.js")),
              collapse = "\n")
  matches <- parse_career_js(js)
  data <- clean_career_data(matches, "1986-06-03")

  expect_equal(nrow(data), 3)
  expect_equal(data$player_age[1], 15.272045, tolerance = 1e-6)
  expect_equal(data$opponent_age,
               c(22.264202601, 24.2902121834, 18.7597535934))
  expect_equal(data$age_difference[1], -6.992157, tolerance = 1e-6)
  expect_identical(data$result, c("L", "L", "W"))
})

test_that("missing opponent information preserves the match record", {
  js <- paste(readLines(test_path("fixtures", "female-career.js")),
              collapse = "\n")
  matches <- parse_career_js(js)
  matches[[1]][[17]] <- ""
  data <- clean_career_data(matches, "1981-09-26")

  expect_equal(nrow(data), 3)
  expect_true(is.na(data$opponent_age[1]))
  expect_true(is.na(data$age_difference[1]))
})
