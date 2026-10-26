test_that("missing package is identified", {
  withr::local_options(rlib_message_verbosity = "verbose")
  expect_message(
    installed <- source_pef_elf("dependencies", "is_installed2", "missing")
  )
  expect_false(installed)
})

test_that("present package is identified", {
  withr::local_options(rlib_message_verbosity = "verbose")
  expect_silent(
    installed <- source_pef_elf("dependencies", "is_installed2", "present")
  )
  expect_true(installed)
})
