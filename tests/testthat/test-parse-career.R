test_that("female career JS is parsed into match records", {
  js <- paste(readLines(test_path("fixtures", "female-career.js")),
              collapse = "\n")
  matches <- parse_career_js(js)
  expect_length(matches, 3)
  expect_identical(matches[[1]][[1]], "19951030")
  expect_identical(matches[[1]][[17]], "19770119")
})

test_that("male career JS preserves opponent ages and results", {
  js <- paste(readLines(test_path("fixtures", "male-career.js")),
              collapse = "\n")
  matches <- parse_career_js(js)
  expect_length(matches, 3)
  expect_identical(matches[[1]][[17]], "22.264202601")
  expect_identical(matches[[3]][[5]], "W")
})

test_that("invalid JS gives a helpful error", {
  expect_error(parse_career_js("<html>Not found</html>"),
               "career match data")
})
