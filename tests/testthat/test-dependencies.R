test_that("missing package is identified", {
  withr::local_options(rlib_message_verbosity = "verbose")
  expect_message(source_pef("dependencies", "is_installed2", "missing"))
  expect_false(source_pef("dependencies", "is_installed2", "missing"))
})

test_that("present package is identified", {
  withr::local_options(rlib_message_verbosity = "verbose")
  expect_silent(source_pef("dependencies", "is_installed2", "present"))
  expect_true(source_pef("dependencies", "is_installed2", "present"))
})
