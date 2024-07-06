test_that("missing package is identified", {
  withr::local_options(rlib_message_verbosity = "verbose")
  expect_message(rlang::with_interactive(is_installed2("idonotexist"), FALSE))
  expect_false(rlang::with_interactive(is_installed2("idonotexist"), FALSE))
})

test_that("present package is identified", {
  withr::local_options(rlib_message_verbosity = "verbose")
  expect_silent(rlang::with_interactive(is_installed2("base"), FALSE))
  expect_true(rlang::with_interactive(is_installed2("base"), FALSE))
})
