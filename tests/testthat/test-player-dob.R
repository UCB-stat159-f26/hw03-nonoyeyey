test_that("dob is selected instead of another date field", {
  js <- paste("var peakfirst=20020708;",
              "var dob=19810926;", sep = "\n")
  expect_identical(parse_player_dob(js), as.Date("1981-09-26"))
})

test_that("spaces around the dob assignment are accepted", {
  js <- "  var dob = 19860603 ;  "
  expect_identical(parse_player_dob(js), as.Date("1986-06-03"))
})

test_that("a missing dob gives a helpful error", {
  expect_error(parse_player_dob("var peakfirst=20020708;"),
               "birth date")
})

test_that("an invalid birth date gives a helpful error", {
  expect_error(parse_player_dob("var dob=19811340;"),
               "birth date")
})
