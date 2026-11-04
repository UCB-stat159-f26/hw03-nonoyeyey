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

test_that("matchmx can be extracted from a player information file", {
  js <- paste(readLines(test_path("fixtures", "female-career.js")),
              collapse = "\n")
  js <- sub("morematchmx", "matchmx", js, fixed = TRUE)
  js <- paste("var dob=19810926;", js, "var currentrank=1204;",
              sep = "\n")
  matches <- parse_career_js(js, variable = "matchmx")
  expect_length(matches, 3)
  expect_identical(matches[[1]][[1]], "19951030")
})

test_that("an empty matchmx array is accepted", {
  expect_identical(parse_career_js("var matchmx=[];", variable = "matchmx"),
                   list())
})
