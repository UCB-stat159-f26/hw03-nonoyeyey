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
