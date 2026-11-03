test_that("player names are formatted for career URLs", {
  expect_identical(format_player_name("serena williams"), "SerenaWilliams")
  expect_identical(format_player_name("Serena Williams"), "SerenaWilliams")
  expect_identical(format_player_name("SerenaWilliams"), "SerenaWilliams")
  expect_identical(format_player_name("Rafael Nadal"), "RafaelNadal")
})

test_that("extra spaces are handled", {
  expect_identical(format_player_name("  Serena   Williams  "), "SerenaWilliams")
})

test_that("empty or missing names give a helpful error", {
  expect_error(format_player_name(""), "player name")
  expect_error(format_player_name(NA_character_), "player name")
})
