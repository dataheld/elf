test_that("locally setting options works", {
  options::define_option("foo", default = "bar")
  expect_equal(options::opt("foo"), "bar")
  opt_set_local2("foo", "baz")
  expect_equal(options::opt("foo"), "baz")
  withr::deferred_run()
  expect_equal(options::opt("foo"), "bar")
})
